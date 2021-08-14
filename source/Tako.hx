package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class Tako extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('InaBonk'));
		bg.screenCenter();
		add(bg);
		
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new PlayState());
		}
		super.update(elapsed);
	}
}