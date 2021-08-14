#if sys
package;

import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import flixel.ui.FlxBar;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

using StringTools;

class Caching extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;

	var loaded = false;

    var text:FlxText;
    var wah:FlxText;
    var kadeLogo:FlxSprite;

	public static var bitmapData:Map<String,FlxGraphic>;

	var images = [];
	var music = [];
	var charts = [];

	var haachama:Bool = false;


	override function create()
	{
		if (FileSystem.exists("assets/songs/eidolic-stained-heart") && FileSystem.exists("assets/data/eidolic-stained-heart/eidolic-stained-heart-hard.json"))
            {
                haachama = true;
                trace('ya its all there');
            }
        else
            {
                trace('nah bro');
            }

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();

        text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Loading...");
        text.size = 34;
        text.alignment = FlxTextAlign.CENTER;
        text.alpha = 0;

        kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('TitleLogo'));
        kadeLogo.x -= kadeLogo.width / 2;
        kadeLogo.y -= kadeLogo.height / 2 + 100;
        text.y -= kadeLogo.height / 2 - 125;
        text.x -= 170;
        kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.6));

        wah = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0, "Wah!");
        wah.size = 34;
        wah.alignment = FlxTextAlign.CENTER;
        wah.alpha = 0;
        wah.y -= kadeLogo.height / 2 - 125;
        wah.x -= 55;
		
		kadeLogo.alpha = 0;

		#if cpp
		if (FlxG.save.data.cacheImages)
		{
			trace("caching images...");

			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}
		}

		trace("caching music...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}
		#end

		toBeDone = Lambda.count(images) + Lambda.count(music);

		var bar = new FlxBar(10,FlxG.height - 50,FlxBarFillDirection.LEFT_TO_RIGHT,FlxG.width,40,null,"done",0,toBeDone);
		bar.color = FlxColor.PURPLE;

		add(bar);

		add(kadeLogo);
		add(text);
		add(wah);

		trace('starting caching..');
		
		#if cpp
		// update thread

		sys.thread.Thread.create(() -> {
			while(!loaded)
			{
				if (toBeDone != 0 && done != toBeDone)
					{
						var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
						kadeLogo.alpha = alpha;
						text.alpha = alpha;
						text.text = "Loading... (" + done + "/" + toBeDone + ")";
					}
					else
						{
							text.alpha = 0;
						}
			}
		
		});

		// cache thread

		sys.thread.Thread.create(() -> {
			cache();
		});
		#end

		super.create();
	}

	var calledDone = false;

	override function update(elapsed) 
	{
		super.update(elapsed);
	}


	function cache()
	{
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			trace('id ' + replaced + ' file - assets/shared/images/characters/' + i + ' ${data.width}');
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			done++;
		}

		for (i in music)
		{
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			trace("cached " + i);
			done++;
		}


		trace("Finished caching...");

		if (haachama)
			{
				new FlxTimer().start(.05, function(tmr:FlxTimer)
					{
						var laughter:FlxText = new FlxText(FlxG.width/2 + FlxG.random.int(-600, 400), FlxG.height/2 + FlxG.random.int(-350, 300), 0, "HAHAHA", 90);
						laughter.color = FlxColor.RED;
						add(laughter);
					}, 100);

				new FlxTimer().start(.05, function(tmr:FlxTimer)
					{
						var snd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('laugh', 'shared'));
						snd.play();
					});

				new FlxTimer().start(2.5, function(tmr:FlxTimer)
					{
						FlxG.switchState(new TitleState());
					});
			}
		else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						wah.alpha = 1;
						var snd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('wah', 'shared'));
						snd.play();
					});
		
		
		
				new FlxTimer().start(2.5, function(tmr:FlxTimer)
					{
						FlxG.switchState(new TitleState());
					});
			}
		loaded = true;
	}

}
#end
