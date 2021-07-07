#define IMPLEMENT_API
#include <hx/CFFI.h>

class WiimoteHid {
    public:
        static value testing();
    private:
        HANDLE OpenWiimote;
};
