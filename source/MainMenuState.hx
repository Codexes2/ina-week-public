package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import flash.events.KeyboardEvent;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{

	var takoColors:Array<String> = ['Blue', 'BlueDark', 'Cyan', 'Gold', 'Green', 'GreenLime', 
									'LightPink', 'Orange', 'Pink', 'Purple', 'Red', 
									'RedPink', 'Torquoise', 'Violet', 'Yellow'];

	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var debug:Bool = false;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'credits', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "CUSTOM" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		#if debug
		debug = true;
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		if(FlxG.save.data.antialiasing)
			{
				bg.antialiasing = true;
			}
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		if(FlxG.save.data.antialiasing)
			{
				magenta.antialiasing = true;
			}
		magenta.color = 0xFFfd719b;
		add(magenta);

		if (FlxG.save.data.inaHard || debug)
			{

				var tako:FlxSprite = new FlxSprite(1050, 80);
				tako.frames = Paths.getSparrowAtlas('ina/colors/TakoNeutral', 'shared');
				tako.scrollFactor.x = 0;
				tako.scrollFactor.y = 0.10;
				tako.setGraphicSize(Std.int(tako.width * 0.76));
				tako.animation.addByPrefix('hover', 'Tako0', 24, true);
				add(tako);
				tako.animation.play('hover');

				if (FlxG.save.data.beatInapurgation || debug)
					{
						var colorElem = FlxG.random.int(0, takoColors.length - 1);

						var takoPurgation:FlxSprite = new FlxSprite(tako.x, tako.y + 150);
						takoPurgation.frames = Paths.getSparrowAtlas('ina/colors/Tako' + takoColors[colorElem], 'shared');
						takoPurgation.scrollFactor.x = 0;
						takoPurgation.scrollFactor.y = 0.10;
						takoPurgation.setGraphicSize(Std.int(tako.width * 0.76));
						takoPurgation.animation.addByPrefix('hover', 'Tako0', 24, true);
						add(takoPurgation);
						takoPurgation.animation.play('hover');

						if (FlxG.save.data.beatEldritchPhantasm || debug)
							{
								var takoPhantasm:FlxSprite = new FlxSprite(tako.x, takoPurgation.y + 150);
								takoPhantasm.frames = Paths.getSparrowAtlas('ina/colors/TakoTrophy', 'shared');
								takoPhantasm.scrollFactor.x = 0;
								takoPhantasm.scrollFactor.y = 0.10;
								takoPhantasm.setGraphicSize(Std.int(tako.width * 0.76));
								takoPhantasm.animation.addByPrefix('hover', 'Tako0', 24, true);
								add(takoPhantasm);
								takoPhantasm.animation.play('hover');
							}
					}
			}
		
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		var languageSet:String = '';
		if (FlxG.save.data.inaLanguage) {languageSet = 'jp/';}
		else {languageSet = 'en/';}

		var tex = Paths.getSparrowAtlas(languageSet + 'FNF_main_menu_assets');
		var creditTex = Paths.getSparrowAtlas('en/FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			if (FlxG.save.data.inaLanguage && i == 2)
				{
					menuItem.frames = creditTex;
				}
			else
				{
					menuItem.frames = tex;
				}
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			if(FlxG.save.data.antialiasing)
				{
					menuItem.antialiasing = true;
				}
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 60 + (i * 160);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

		super.create();
	}

	var selectedSomethin:Bool = false;

	var code = '';
	var keyTimer:Float =0;

	function onKeyDown(event:KeyboardEvent):Void{
		code = code + String.fromCharCode(event.charCode);
		keyTimer=2;
		if(code=="reflect"){
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('a'));
			new FlxTimer().start(15.2, function(deadTime:FlxTimer)
				{
					FlxG.sound.music.play();
				});
		}
	}




	override function update(elapsed:Float)
	{
		if(keyTimer>0){
			keyTimer-=elapsed;
		}
		if(keyTimer<=0){
			keyTimer=0;
			code="";
		}
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				FlxG.switchState(new FreeplayState());
				trace("Freeplay Menu Selected");
			case 'credits':
				FlxG.sound.music.fadeOut(1, 0);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				FlxG.switchState(new Credits());
				trace("Credits got");
			case 'options':
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}