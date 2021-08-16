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

    private var select:Array<String> = [
        "Please select your preferred language.",
        "ご希望の言語をお選びください。",
        "Selecciona tu idioma preferido."
    ];
    private var selectGroup:FlxSpriteGroup = new FlxSpriteGroup();

    private var option:Array<String> = [
        "You can choose this again in Options → Appearance",
        "「Options」→「Appearance」で再度選択することができます。",
        "Puede elegir esto nuevamente en Opciones → Apariencia"
    ];
    private var optionGroup:FlxSpriteGroup = new FlxSpriteGroup();

    private var textRotate:Int = 2;

    public var grpLanguage:FlxSpriteGroup = new FlxSpriteGroup();
    public var languageItems:Array<String> = ['English', '日本語', 'Español'];
    public var curSelected:Int = 0;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		add(bg);

        for (i in 0...select.length)
        {
            var selectTxt:FlxText = new FlxText(0, 5, FlxG.width, select[i], 30);
            selectTxt.alignment = CENTER;
            selectTxt.borderColor = FlxColor.BLACK;
            selectTxt.borderSize = 2;
            selectTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
            selectTxt.font = Paths.font("kgu-o.ttf");
            selectTxt.alpha = 0;
            selectGroup.add(selectTxt);
        }
        add(selectGroup);

        for (i in 0...option.length)
        {
            var optionTxt:FlxText = new FlxText(0, 100, FlxG.width, option[i], 30);
            optionTxt.alignment = CENTER;
            optionTxt.borderColor = FlxColor.BLACK;
            optionTxt.borderSize = 2;
            optionTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
            optionTxt.font = Paths.font("kgu-o.ttf");
            optionTxt.alpha = 0;
            optionGroup.add(optionTxt);
        }
        add(optionGroup);
		
        for (i in 0...languageItems.length)
        {
            var daText:FlxText = new FlxText(100 + (i * 400), FlxG.height/2, 0, languageItems[i], 60);
            daText.borderColor = FlxColor.BLACK;
            daText.borderSize = 2;
            daText.borderStyle = FlxTextBorderStyle.OUTLINE;
            daText.font = Paths.font("rhp.ttf");
            grpLanguage.add(daText);
        }
        add(grpLanguage);
		
		FlxTween.color(bg, 3, bg.color, FlxColor.fromString(bgColors[colorRotation]));
		
		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
			if(colorRotation < (bgColors.length - 1)) colorRotation++;
			else colorRotation = 0;
		}, 0);

        new FlxTimer().start(5, function(tmr:FlxTimer)
        {
            FlxTween.tween(selectGroup.members[textRotate], {alpha: 0}, 2);
            FlxTween.tween(optionGroup.members[textRotate], {alpha: 0}, 2);

            if (textRotate < 2) textRotate++;
            else textRotate = 0;

            FlxTween.tween(selectGroup.members[textRotate], {alpha: 1}, 2);
            FlxTween.tween(optionGroup.members[textRotate], {alpha: 1}, 2);
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
                        FlxG.save.data.inaLanguage = 'ENGLISH';
                        FlxG.save.data.languageINT = 0;
                    case "日本語":
                        trace('chose japanese');
                        FlxG.save.data.inaLanguage = 'JAPANESE';
                        FlxG.save.data.languageINT = 1;
                    case "Español":
                        trace('chose spanish');
                        FlxG.save.data.inaLanguage = 'SPANISH';
                        FlxG.save.data.languageINT = 2;
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