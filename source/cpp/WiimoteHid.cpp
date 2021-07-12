#define IMPLEMENT_API
#include <hx/CFFI.h>

#include <string>

//#include <iostream>
//note to self: for some godforsaken reason, including iostream makes the ndll invalid when run outside of lime command.
//how and why does this happen? dont know dont care. thank the lord it wasnt caused by something i actually needed.

#include <Windows.h>
#include <sdkddkver.h>

#include <SetupAPI.h>
#include <initguid.h>
#include <hidclass.h>
extern "C" {
    #include <hidsdi.h>
    //nightmare nightmare nightmare https://stackoverflow.com/a/49540892
}
#include <hidpi.h>
#include <Devpkey.h>
#include <Cfgmgr32.h>
#include <bthdef.h>

#include <stdio.h>
#include <stdlib.h>
//#include "hidapi.h"
//#include "WiimoteHid.h"

HANDLE OpenWiimote;

value Setup()
{
    bool FoundWiimote = false;
    HDEVINFO handle = SetupDiGetClassDevs(&GUID_DEVINTERFACE_HID, NULL, NULL, DIGCF_PRESENT | DIGCF_DEVICEINTERFACE);
    SP_DEVICE_INTERFACE_DATA interfaceData;
    interfaceData.cbSize = sizeof(SP_DEVICE_INTERFACE_DATA);
    int i = 0;
    while(SetupDiEnumDeviceInterfaces(handle, NULL, &GUID_DEVINTERFACE_HID, i, &interfaceData)) {
        DWORD requiredSize;
        SetupDiGetInterfaceDeviceDetail(handle, &interfaceData, NULL, 0, &requiredSize, NULL);
        PSP_DEVICE_INTERFACE_DETAIL_DATA detailData = (PSP_DEVICE_INTERFACE_DETAIL_DATA)malloc(requiredSize);
        detailData->cbSize = sizeof(SP_DEVICE_INTERFACE_DETAIL_DATA);
        SetupDiGetInterfaceDeviceDetail(handle, &interfaceData, detailData, requiredSize, NULL, NULL);

        HANDLE file = CreateFile(detailData->DevicePath, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
        HIDD_ATTRIBUTES attrib;
        attrib.Size = sizeof(HIDD_ATTRIBUTES);
        HidD_GetAttributes(file, &attrib);
        free(detailData);
        if(attrib.VendorID == 0x057e && (attrib.ProductID == 0x0306 || attrib.ProductID == 0x0330)) {
            OpenWiimote = file;
            FoundWiimote = true;
            break;
        } else {
            CloseHandle(file);
        }
        i++;
    }
    //hid_device_info* list = hid_enumerate(0x7e05, 0x0603);
    //std::cout << list->path;
    SetupDiDestroyDeviceInfoList(handle);
    return alloc_bool(FoundWiimote);
}
DEFINE_PRIM(Setup, 0);

value GetWiimoteReadout() {
    UCHAR buf[255];
    DWORD bytesRead;
    bool keepReading = true;
    BOOL result = ReadFile(OpenWiimote, &buf, sizeof(buf), &bytesRead, NULL);
    DWORD err = GetLastError();
    /*while(keepReading) {
                if(!result) {
                    //this bit is copypasted from the hid wiimote sample program lol my patience is running out
                    
                    if (Error != ERROR_IO_PENDING)
                    {
                        std::cout << "Read Failed: " << std::hex << Error << std::endl;
                        err = true;
                        continue;
                    }
                    else
                    {
                        if (!GetOverlappedResult(file, &overlapped, &bytesRead, TRUE))
                        {
                            Error = GetLastError();
                            std::cout << "Read Failed: " << std::hex << Error << std::endl;
                            err = true;
                            continue;
                        }

                        if (overlapped.Internal == STATUS_PENDING)
                        {
                            std::cout << "Read Interrupted" << std::endl;
                            if (!CancelIo(file))
                            {
                                Error = GetLastError();
                                std::cout << "Cancel IO Faile: " << std::hex << Error << std::endl;
                            }
                            err = true;
                            continue;
                        }
                    }
                }
            }*/
    if (result)
    {
        value readout = alloc_empty_object();
        alloc_field(readout, val_id("dpadY"), alloc_int(buf[1]));
        alloc_field(readout, val_id("dpadX"), alloc_int(buf[2]));
        alloc_field(readout, val_id("buttons"), alloc_int(buf[3]));
        alloc_field(readout, val_id("pitch"), alloc_int(buf[6]));
        alloc_field(readout, val_id("roll"), alloc_int(buf[7]));
        return readout;
    } else if(err != ERROR_IO_PENDING)
    {
        value readout = alloc_empty_object();
        alloc_field(readout, val_id("err"), alloc_int(err));
        return readout;
    } else return alloc_null();
}
DEFINE_PRIM(GetWiimoteReadout, 0);