package;

class WiimoteDPad {
    public var down:Bool;
    public var up:Bool;
    public var left:Bool;
    public var right:Bool;
    public var neutral:Bool;
    public var pressed:WiimoteDPad;
    public function new(down:Bool, up:Bool, left:Bool, right:Bool, neutral:Bool, ?pressed:WiimoteDPad) {
        this.down = down;
        this.up = up;
        this.left = left;
        this.right = right;
        this.neutral = neutral;
        this.pressed = pressed;
    }
}

class WiimoteButtons {
    public var a:Bool;
    public var b:Bool;
    public var minus:Bool;
    public var plus:Bool;
    public var home:Bool;
    public var one:Bool;
    public var two:Bool;
    public var pressed:WiimoteButtons;
    public function new(buttonA:Bool, buttonB:Bool, buttonMinus:Bool, buttonPlus:Bool, buttonHome:Bool, button1:Bool, button2:Bool, ?pressed:WiimoteButtons) {
        this.a = buttonA;
        this.b = buttonB;
        this.minus = buttonMinus;
        this.plus = buttonPlus;
        this.home = buttonHome;
        this.one = button1;
        this.two = button2;
        this.pressed = pressed;
    }
}

class WiimoteReadout {
    public var pitch:UInt;
    public var roll:UInt;
    public var dpad:WiimoteDPad;
    public var buttons:WiimoteButtons;
    public function new(pitch:UInt, roll:UInt, dpad:WiimoteDPad, buttons:WiimoteButtons) {
        this.pitch = pitch;
        this.roll = roll;
        this.dpad = dpad;
        this.buttons = buttons;
    }
}

class WiimoteHid {

    private static var _setup = cpp.Lib.load("wiimote", "Setup", 0);
    private static var _getWiimoteReadout = cpp.Lib.load("wiimote", "GetWiimoteReadout", 0);
    private static var prevReadout:WiimoteReadout;

    public static var lastReadout:WiimoteReadout;

    public static function setup():Bool {
        return cast(_setup(), Bool);
    }
    public static function getWiimoteReadout():WiimoteReadout {
        var result = _getWiimoteReadout();
        if(result == null) return null;
        var err = Reflect.field(result, "err");
        if(err != null) {
            var nerr:Int = cast(err, Int);
            var message:String = 'Wiimote Read Error ${nerr}\n';
            if(nerr == 1167) message += "This means you disconnected the Wiimote while playing the game.\nIf you didn't do that, please notify me on GitHub.";
            else message += "Please report this error to me on GitHub! It's probably a you problem, but it could be a me problem, or at least a common enough problem for me to have to put out a notice about it.";
            throw new haxe.Exception(message);
        }
        var dpadY:UInt = Reflect.field(result, "dpadY");
        var dpadX:UInt = Reflect.field(result, "dpadX");
        var wbuttons:UInt = Reflect.field(result, "buttons");

        var buttonsObj:WiimoteButtons = new WiimoteButtons(wbuttons & 4 == 4,
            wbuttons & 8 == 8,
            wbuttons & 32 == 32,
            wbuttons & 16 == 16,
            wbuttons & 64 == 64,
            wbuttons & 1 == 1,
            wbuttons & 2 == 2);
        buttonsObj.pressed = prevReadout != null ? new WiimoteButtons(
            (wbuttons & 4 == 4) && !prevReadout.buttons.a,
            (wbuttons & 8 == 8) && !prevReadout.buttons.b,
            (wbuttons & 32 == 32) && !prevReadout.buttons.minus,
            (wbuttons & 16 == 16) && !prevReadout.buttons.plus,
            (wbuttons & 64 == 64) && !prevReadout.buttons.home,
            (wbuttons & 1 == 1) && !prevReadout.buttons.one,
            (wbuttons & 2 == 2) && !prevReadout.buttons.two
        ) : buttonsObj; // this means that if you're holding a button on the first frame of a new state it will count it as a press. too bad!

        var dpadObj:WiimoteDPad = new WiimoteDPad(dpadY == 0xff, dpadY == 0x0, dpadX == 0xff, dpadX == 0x0, dpadX == 0x7f && dpadY == 0x7f);
        dpadObj.pressed = prevReadout != null ? new WiimoteDPad((dpadY == 0xff) && !prevReadout.dpad.down, 
            (dpadY == 0x0) && !prevReadout.dpad.up, 
            (dpadX == 0xff) && !prevReadout.dpad.left, 
            (dpadX == 0x0) && !prevReadout.dpad.right, 
            false) : dpadObj;
        var readout:WiimoteReadout = new WiimoteReadout(Reflect.field(result, "pitch"), Reflect.field(result, "roll"), dpadObj, buttonsObj);
        prevReadout = readout;
        return readout;
    }
}