package;

import lime.app.Application;
import lime.app.Event;
import lime.system.System;
import flixel.addons.ui.FlxUIInputText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.group.FlxSpriteGroup;

import sys.FileSystem;

using StringTools;

class TestMenu extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var goingBack:Bool = false;

	var camLerp:Float = 0.16;

	var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);

	var prefix:FlxText;

	var name:FlxUIInputText;

    var haachama:Bool = false;

	public static var nameResult:String = "";
	public static var coming:String = "";

	public function new()
	{
		super();

        if (FileSystem.exists("assets/songs/eidolic-stained-heart") && FileSystem.exists("assets/data/eidolic-stained-heart/eidolic-stained-heart-hard.json"))
            {
                haachama = true;
                trace('ya its all there');
            }
        else
            {
                trace('nah bro');
            }

		add(blackBarThingie);
		blackBarThingie.scrollFactor.set();
		blackBarThingie.scale.y = 750;

		prefix = new FlxText(FlxG.width * 0.7, 5, 0, "Testing enabled: Input your command", 32);
		prefix.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		prefix.alignment = CENTER;
		prefix.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		prefix.screenCenter(X);
		prefix.y = 38;
		prefix.scrollFactor.set();
		add(prefix);

		name = new FlxUIInputText(10, 10, FlxG.width, '', 8);
		name.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, RIGHT);
		name.alignment = CENTER;
		name.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		name.screenCenter();
		name.scrollFactor.set();
		add(name);
		name.backgroundColor = 0xFF000000;
		name.maxLength = 31;
		name.lines = 1;
		name.caretColor = 0xFFFFFFFF;

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			selectable = true;
		});
	}

	var selectable:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		name.hasFocus = true;

		blackBarThingie.y = 360 - blackBarThingie.height / 2;
		blackBarThingie.x = 640 - blackBarThingie.width / 2;

		if (selectable && !goingBack)
		{
			if (FlxG.keys.justPressed.ESCAPE)
			{
                FlxG.sound.music.stop();
                FlxG.switchState(new Credits());
			}

			if (FlxG.keys.justPressed.ENTER && name.text != '')
			{
                switch (name.text.toLowerCase())
                {
                    case 'my big red heart' | 'eidolic' | 'eidolic stained heart':
                        if(haachama)
                            {
                                trace('loading secret hopefully');

                                var songFormat = StringTools.replace("Eidolic Stained Heart", " ", "-");
                                var poop:String = Highscore.formatSong(songFormat.toLowerCase(), 2);
                                
                                PlayState.SONG = Song.loadFromJson(poop, "eidolic-stained-heart");
                                PlayState.isStoryMode = false;
                                PlayState.storyDifficulty = 2;
                                //trace('CUR WEEK' + PlayState.storyWeek);
                                FlxG.sound.music.stop();
                                LoadingState.loadAndSwitchState(new PlayState());
                            }
                        else
                            {
                                System.exit(0);
                            }
                    default:
                        name.text = "";
                        name.caretIndex = 0;
                        trace('something');
                }
			}
		}
	}
}
