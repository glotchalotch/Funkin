# Friday Night Funkin with Wiimote Support

This is the repository for Friday Night Funkin, but I added Wii Remote support to it. God bless open source.

## **BIG IMPORTANT WARNING!!!!**
To play this game, it is **required** to have the [HID Wiimote](https://www.julianloehr.de/educational-work/hid-wiimote/) driver installed.
Unfortunately, this also locks the mod to Windows only for now and creates a lot of hassle. I think there's a Wiimote driver for Linux but I haven't looked into that too much.

---

GameBanana download: (coming soon probably, hopefully this will be allowed LOL)

Inspired by [this thread](https://www.newgrounds.com/bbs/topic/1473253) on the Newgrounds Video Games board

Play the original game at https://www.newgrounds.com/portal/view/770371 or https://ninja-muffin24.itch.io/funkin

IF YOU MAKE A MOD AND DISTRIBUTE A MODIFIED / RECOMIPLED VERSION, YOU MUST OPEN SOURCE YOUR MOD AS WELL

## Credits / shoutouts

- [glotch (me!)](https://twitter.com/glotchalotch) - Programmer
- [MechaRM](https://sketchfab.com/Mecha_05) - [Wiimote 3D model used in tutorial](https://sketchfab.com/3d-models/mas-2-asn02-wii-remote-plus-real-scale-f36ab634318d41009699b4cffea7c255)
- [ninjamuffin99](https://twitter.com/ninja_muffin99) - OG FNF Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician

This game was made with love to Newgrounds and it's community. Extra love to Tom Fulp.

## Build instructions

THESE INSTRUCTIONS ARE FOR COMPILING THE GAME'S SOURCE CODE!!!

IF YOU WANT TO JUST DOWNLOAD AND INSTALL AND PLAY THE GAME NORMALLY, GO TO GAMEBANANA TO DOWNLOAD THE GAME!!

(coming soon)

IF YOU WANT TO COMPILE THE GAME YOURSELF, CONTINUE READING!!!

### Installing the Required Programs

First you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe 4.1.5](https://haxe.org/download/version/4.1.5/) (Download 4.1.5 instead of 4.2.0 because 4.2.0 is broken and is not working with gits properly...)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe
3. [Install the HID Wiimote Driver](https://www.julianloehr.de/educational-work/hid-wiimote/) so the game will work when you run it
4. [Install MINGW-W64](http://mingw-w64.org/doku.php) so you have g++ to recompile the C++ code

Other installations you'd need is the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
flixel
flixel-addons
flixel-ui
hscript
newgrounds
```
So for each of those type `haxelib install [library]` so shit like `haxelib install newgrounds`

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build.
2. Follow instructions to install the application properly.
3. Run `haxelib git polymod https://github.com/larsiusprime/polymod.git` to install Polymod.
4. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.

You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed out cameras.
- Run `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in the terminal/command-prompt.

### Compiling the C++
If you alter the C++ code, you'll need to recompile the wiimote.ndll file. Luckily, I prepared a compile.bat file in source/cpp to do that
for you. Just navigate to the folder in MINGW-W64 and run the batch file and it should run the proper command. I set up the project.xml file
to move the wiimote.ndll file to the proper spot when compiling the game as well, so that shouldn't be an issue

### Ignored files

I gitignore the API keys for the game, so that no one can nab them and post fake highscores on the leaderboards. But because of that the game
doesn't compile without it.

Just make a file in `/source` and call it `APIStuff.hx`, and copy paste this into it

```haxe
package;

class APIStuff
{
	public static var API:String = "";
	public static var EncKey:String = "";
}

```

and you should be good to go there.

### Compiling game

~~Once you have all those installed, it's pretty easy to compile the game. You just need to run 'lime test html5 -debug' in the root of the project to build and run the HTML5 version. (command prompt navigation guide can be found here: [https://ninjamuffin99.newgrounds.com/news/post/1090480](https://ninjamuffin99.newgrounds.com/news/post/1090480))~~ i don't think it will ever be possible to run this in html5, if it is, let
me know

To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. For Linux, you only need to open a terminal in the project directory and run 'lime test linux -debug' and then run the executable file in export/release/linux/bin. For Windows, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)
* C++ Profiling tools
* C++ CMake tools for windows
* C++ ATL for v142 build tools (x86 & x64)
* C++ MFC for v142 build tools (x86 & x64)
* C++/CLI support for v142 build tools (14.21)
* C++ Modules for v142 build tools (x64/x86)
* Clang Compiler for Windows
* Windows 10 SDK (10.0.17134.0)
* Windows 10 SDK (10.0.16299.0)
* MSVC v141 - VS 2017 C++ x64/x86 build tools
* MSVC v140 - VS 2015 C++ build tools (v14.00)

This will install about 22GB of crap, but once that is done you can open up a command line in the project's directory and run `lime test windows -debug`. Once that command finishes (it takes forever even on a higher end PC), you can run FNF from the .exe file under export\release\windows\bin
As for Mac, 'lime test mac -debug' should work, if not the internet surely has a guide on how to compile Haxe stuff for Mac.

### Additional guides

- [Command line basics](https://ninjamuffin99.newgrounds.com/news/post/1090480)
