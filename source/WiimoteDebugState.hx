package;

import flixel.FlxG;
import WiimoteHid.WiimoteReadout;
import flixel.FlxState;
import flixel.addons.ui.FlxUIText;
import haxe.ds.Vector;

class WiimoteDebugState extends FlxState {
    var test:FlxUIText;
    var lastPitch:Int;
    var lastRoll:Int;
    override public function create() {
        test = new FlxUIText(360, 40, 0, "If you're seeing this then the Wiimote isn't connected", 20);
        add(test);
    }
    override public function update(elapsed:Float) {
        var readout:WiimoteReadout = WiimoteHid.getWiimoteReadout();
        test.text = 'Up: ${readout.dpad.up}
Down: ${readout.dpad.down}
Left: ${readout.dpad.left}
Right: ${readout.dpad.right}
A: ${readout.buttons.a}
B: ${readout.buttons.b}
+: ${readout.buttons.plus}
-: ${readout.buttons.minus}
Home: ${readout.buttons.home}
1: ${readout.buttons.one}
2: ${readout.buttons.two}
Pitch: ${readout.pitch}
Roll: ${readout.roll}';
        if(readout.pitch >= 200 && lastPitch < 200) trace("pitch up");
        if(readout.pitch >= 200 && lastPitch >= 200) trace("pitch up held");
        if(readout.pitch < 200 && lastPitch >= 200) trace("pitch up release");
        lastPitch = readout.pitch;
        if(FlxG.keys.pressed.ANY) FlxG.switchState(new MainMenuState());
    }
}