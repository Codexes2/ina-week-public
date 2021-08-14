package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class SetLanguage extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";
	
	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;

    public var grpLanguage:FlxSpriteGroup = new FlxSpriteGroup();
    public var languageItems:Array<String> = ['English', '日本語'];
    public var curSelected:Int = 0;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		add(bg);

        var select:FlxText = new FlxText(0, 5, FlxG.width, "Please select your preferred language." + "\nご希望の言語をお選びください。", 30);
        select.alignment = CENTER;
        select.borderColor = FlxColor.BLACK;
        select.borderSize = 2;
        select.borderStyle = FlxTextBorderStyle.OUTLINE;
        select.font = Paths.font("kgu-o.ttf");
        add(select);

        var option:FlxText = new FlxText(0, select.y + 100, FlxG.width, "You can choose this again in Options → Appearance" + "\n「Options」→「Appearance」で再度選択することができます。", 30);
        option.alignment = CENTER;
        option.borderColor = FlxColor.BLACK;
        option.borderSize = 2;
        option.borderStyle = FlxTextBorderStyle.OUTLINE;
        option.font = Paths.font("kgu-o.ttf");
        add(option);

        var middleLine:FlxText = new FlxText (0, FlxG.height/2, 0, "|", 70);
        middleLine.screenCenter(X);
        middleLine.borderColor = FlxColor.BLACK;
        middleLine.borderSize = 2;
        middleLine.borderStyle = FlxTextBorderStyle.OUTLINE;
        middleLine.font = Paths.font("kgu-o.ttf");
        add(middleLine);

		
        for (i in 0...languageItems.length)
        {
            var daText:FlxText = new FlxText(200 + (i * 650), FlxG.height/2, 0, languageItems[i], 60);
            daText.borderColor = FlxColor.BLACK;
            daText.borderSize = 2;
            daText.borderStyle = FlxTextBorderStyle.OUTLINE;
            daText.font = Paths.font("kgu-o.ttf");
            grpLanguage.add(daText);
        }
        add(grpLanguage);
		
		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
			if(colorRotation < (bgColors.length - 1)) colorRotation++;
			else colorRotation = 0;
		}, 0);

        changeSelection();
		
	}

	override function update(elapsed:Float)
	{
        super.update(elapsed);

        var leftPcontroller:Bool = false;
        var rightPcontroller:Bool = false;

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (gamepad != null && KeyBinds.gamepad)
        {
			leftPcontroller = gamepad.justPressed.DPAD_LEFT;
			rightPcontroller = gamepad.justPressed.DPAD_RIGHT;
        }

        if (controls.LEFT_P || leftPcontroller)
        {
            //trace("going left");
            changeSelection(-1);
        }

        if (controls.RIGHT_P || rightPcontroller)
        {
            //trace("going right");
            changeSelection(1);
        }

        if (controls.ACCEPT)
            {
                var daSelected:String = languageItems[curSelected];
                switch (daSelected)
                {
                    case "English":
                        trace('chose english');
                        FlxG.save.data.inaLanguage = false;
                    case "日本語":
                        trace('chose japanese');
                        FlxG.save.data.inaLanguage = true;
                }
                leftState = true;
                FlxG.switchState(new Disclaimer());
            }
	}

    function changeSelection(change:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;
        if (curSelected < 0) {curSelected = languageItems.length - 1;}
        if (curSelected >= languageItems.length) {curSelected = 0;}

        var flag:Int = 0;
        grpLanguage.forEach(function(spr:FlxSprite)
        {
            spr.alpha = 0.6;
            flag++;
            //trace("curSelected + 1: " + (curSelected + 1));
            //trace("flag: " + flag);
            if (flag == curSelected + 1)
            {
                spr.alpha = 1;
            }
        });
    }
}