package;

import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextAlign;
import flixel.FlxG;
import flixel.addons.ui.FlxUIText;
import flixel.FlxState;

class WiimoteNotFoundState extends FlxState {
    var failedText:FlxUIText;
    override public function create() {
        var text:FlxUIText = new FlxUIText(60, 235, 0,
            "No Wiimote detected. Make sure the HID Wiimote driver is properly installed\nand the Wiimote is connected with its lights on solid.
Try using WiiPair for easier pairing.\n\nPress ENTER to retry\nPress SPACE to download HID Wiimote\nPress ESC to download WiiPair", 24);
        text.autoSize = false;
        text.alignment = FlxTextAlign.CENTER;
        add(text);
        failedText = new FlxUIText(525, 480, 0, "Retry Failed", 24);
        failedText.color = FlxColor.RED;
        failedText.visible = false;
        add(failedText);
        FlxG.sound.playMusic(Paths.music("breakfast", "shared"));
        FlxG.sound.music.fadeIn(4, 0, 0.7);
    }
    override public function update(elapsed:Float) {
        if(FlxG.keys.justPressed.ENTER) {
            var found:Bool = WiimoteHid.setup();
            if(found) {
                failedText.x = 500;
                failedText.text = "Retry Succeeded!";
                failedText.color = FlxColor.GREEN;
                failedText.visible = true;
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.music("gameOverEnd", "shared"));
				new FlxTimer().start(0.7, function(tmr:FlxTimer)
				{
					FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
					{
						LoadingState.loadAndSwitchState(new TitleState());
					});
				});
            }
            else {
                failedText.visible = true;
                var sound:FlxSound = FlxG.sound.play(Paths.sound("fnf_loss_sfx", "shared"), 0.5);
                new FlxTimer().start(0.7, (t:FlxTimer) -> sound.stop());
                new FlxTimer().start(1.5, (t:FlxTimer) -> failedText.visible = false);
            }
        } else if(FlxG.keys.justPressed.SPACE) {
            FlxG.openURL("https://www.julianloehr.de/educational-work/hid-wiimote/");
        } else if(FlxG.keys.justPressed.ESCAPE) {
            FlxG.openURL("https://github.com/jordanbtucker/WiiPair/releases");
        }
        super.update(elapsed);
    }
}