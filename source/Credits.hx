package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;

class Credits extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";

    var logoBl:FlxSprite;
	
	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;

    var devGroup:FlxGroup = new FlxGroup();
    var specialGroup:FlxGroup = new FlxGroup();
    var tako:FlxSprite;

    var devTeam:Array<String> = ["Codexes: Coded most of Ina Week", 
                                 "Awoofle: Coded whatever Codexes couldn't code\n\"master bait here we go\"", 
                                 "Tressa: Drew most assets for Ina Week", 
                                 "lam: Drew the title logo\n\"doko the hell am i\"", 
                                 "ASARI: Composed most of the music for Ina Week\n\"let's make this faster!!\"", 
                                 "Holo Bass: Composed the dialogue music for Ina Week", 
                                 "Tacocat: Gave moral support\n\"make it stop\""];

    var specialThanks:Array<String> = ["Holofunk Dev Team: Made Holofunk possible in the first place! Very pog!", 
                                       "FNF Dev Team: FNF is pog!", 
                                       "KadeDeveloper: Kade Engine is pog!", 
                                       "FNF HD Dev Team: Dialogue system is pog!",
                                       "Doggydentures: JP Translated assets are incredibly pog!!", 
                                       "Hololive: Hololive is very very pog!!!"];

    var takoTweens:FlxTweenManager = new FlxTweenManager();
    var takoColors:Array<String> = ['Blue', 'BlueDark', 'Cyan', 'Gold', 'Green', 'GreenLime', 
                                    'LightPink', 'Orange', 'Pink', 'Purple', 'Red', 
                                    'RedPink', 'Torquoise', 'Violet', 'Yellow'];

    var tressaText:FlxText;


	override function create()
	{
        Conductor.changeBPM(128);

        FlxG.sound.playMusic(Paths.music('image'), 1.0, true);
        FlxG.mouse.visible = true;

		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		add(bg);

        var logoButton:FlxButton = new FlxButton(100, FlxG.height - 50, "Logo", Logo);
        add(logoButton);

        var devButton:FlxButton = new FlxButton(100 + logoButton.x, FlxG.height - 50, "Dev Team", DevTeam);
        add(devButton);

        var specialButton:FlxButton = new FlxButton(100 + devButton.x, FlxG.height - 50, "Special Thanks", SpecialThanks);
        add(specialButton);

        var hfButton:FlxButton = new FlxButton(100 + specialButton.x, FlxG.height - 50, "Holofunk", Holofunk);
        add(hfButton);

        var takoButton:FlxButton = new FlxButton(100 + hfButton.x, FlxG.height - 50, "Tako!", Tako);
        add(takoButton);

        var tressaButton:FlxButton = new FlxButton(100 + takoButton.x, FlxG.height - 50, "From Tressa", FromTressa);
        add(tressaButton);

        var testButton:FlxButton = new FlxButton(500 + tressaButton.x, FlxG.height - 50, "Test", Test);
        add(testButton);

        logoBl = new FlxSprite(275, 1000);
        logoBl.frames = Paths.getSparrowAtlas('KadeEngineLogoBumpin');
        logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.updateHitbox();
        add(logoBl);

        for(i in 0...devTeam.length)
            {
                var devName = new FlxText(50, 75 + (i * 75), FlxG.width, devTeam[i], 24);
                devName.setFormat("VCR OSD Mono", 24, FlxColor.fromRGB(200, 200, 200));
                devName.borderColor = FlxColor.BLACK;
                devName.borderSize = 2;
                devName.borderStyle = FlxTextBorderStyle.OUTLINE;
                devGroup.add(devName);
            }
        add(devGroup);
        devGroup.visible = false;

        for(i in 0...specialThanks.length)
            {
                var specName = new FlxText(50, 50 + (i * 50), FlxG.width, specialThanks[i], 24);
                specName.setFormat("VCR OSD Mono", 24, FlxColor.fromRGB(200, 200, 200));
                specName.borderColor = FlxColor.BLACK;
                specName.borderSize = 2;
                specName.borderStyle = FlxTextBorderStyle.OUTLINE;
                specialGroup.add(specName);
            }
        add(specialGroup);
        specialGroup.visible = false;

        add(takoTweens);

        FlxTween.tween(logoBl,{y: 50}, 1.4, {ease: FlxEase.expoInOut});

        logoBl.angle = -4;

        new FlxTimer().start(0.01, function(tmr:FlxTimer)
            {
                if(logoBl.angle == -4) 
                    FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
                if (logoBl.angle == 4) 
                    FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
            }, 0);	
            
		
		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
			if(colorRotation < (bgColors.length - 1)) colorRotation++;
			else colorRotation = 0;
		}, 0);

        tressaText = new FlxText(0, 0, FlxG.width - 20, 
             "Message from Tressa:\n\n"
            +"   Thank you for playing our Non-Canon Ina mod for Holofunk." 
            +" This was one of the greatest passion projects the team has made." 
            +" It started as a joke in May, where the discord wondered if Ina would be an opponent since it was planned"
            +" that everyone else in HoloEN was confirmed to have a week."
            +" So I took it upon myself to make it a reality."
            +" An illustration concept of Non-Canon Ina was made by me, which turned into me animating her,"
            +" which turned into her being a skin for Botan, which turned into me asking the Holofunk team for help,"
            +" and ever since Non-Canon Ina became a real mod.\n\n"
            +"   What has transpired over these 2 months was something special."
            +" I can’t thank the team enough for committing all their efforts into making Non-Canon Ina a reality."
            +" To the coders who built the foundation of the mod, the musician who made the soundtrack beyond god-tier,"
            +" and the mate who made the logo when I was busy making assets. This truly is our personal magnum opus for the Hololive community.\n\n"
            +"   However, do remember to support the official Holofunk mod. They have been indeed working hard for the past year."
            +" They have a lot planned so give the official mod the love it deserves.\n\n"
            +"   I just wanted to make a certified cult classic. See you around heh.");
        tressaText.setFormat("VCR OSD Mono", 28, FlxColor.fromRGB(200, 200, 200), LEFT);
        tressaText.borderColor = FlxColor.BLACK;
        tressaText.borderSize = 3;
        tressaText.borderStyle = FlxTextBorderStyle.OUTLINE;
        tressaText.alpha = 0;
        add(tressaText);
		
	}

	override function update(elapsed:Float)
	{
        if (controls.ACCEPT)
            {
                FlxG.mouse.visible = false;
                leftState = true;
                FlxG.switchState(new MainMenuState());
            }
		super.update(elapsed);
	}

    function Logo():Void
        {
            logoBl.alpha = 1;
            devGroup.visible = false;
            specialGroup.visible = false;
            tressaText.alpha = 0;
        }

    function DevTeam():Void
        {
            logoBl.alpha = 0;
            devGroup.visible = true;
            specialGroup.visible = false;
            tressaText.alpha = 0;
        }
    
    function Holofunk():Void
        {
            #if linux
            Sys.command('usr/bin/xdg-open', ["https://gamebanana.com/mods/41250", "&"]);
            #else
            FlxG.openURL('https://gamebanana.com/mods/41250');
            #end
        }
    
    function SpecialThanks():Void
        {
            logoBl.alpha = 0;
            devGroup.visible = false;
            specialGroup.visible = true;
            tressaText.alpha = 0;
        }
    
    function Tako():Void
        {
            var takoGacha:Bool = FlxG.random.bool(50);
            var wahGacha:Int = FlxG.random.int(1, 3);
            var takoLeft:Bool = FlxG.random.bool(50);
            var takoDuration:Int = FlxG.random.int(2, 8);
            var takoRanY:Int = FlxG.random.int(20, 400);

            var daTako:FlxSprite = new FlxSprite(500,100);
            if (takoGacha)
                {
                    var colorElem = FlxG.random.int(0, takoColors.length - 1);
                    daTako.frames = Paths.getSparrowAtlas('ina/colors/Tako' + takoColors[colorElem], 'shared');
                }
            else
                {
                    daTako.frames = Paths.getSparrowAtlas('ina/colors/TakoNeutral', 'shared');
                }
            
            if (takoLeft)
                {
                    daTako.x = -500;
                }
            else
                {
                    daTako.x = 1500;
                }
            daTako.setGraphicSize(Std.int(daTako.width * 0.67));
            daTako.animation.addByPrefix('annoy', 'Tako0', 24, true);
            add(daTako);
            daTako.animation.play('annoy');

            if (takoLeft)
                {
                    daTako.flipX = true;
                    takoTweens.linearMotion(daTako, daTako.x, takoRanY, -daTako.x + 900, takoRanY, takoDuration, true, {ease: FlxEase.smoothStepIn, onComplete: function(tween:FlxTween){
                        remove(daTako);
                    }});        
                }
            else
                {
                    takoTweens.linearMotion(daTako, daTako.x, takoRanY, -daTako.x, takoRanY, takoDuration, true, {ease: FlxEase.smoothStepIn, onComplete: function(tween:FlxTween){
                        remove(daTako);
                    }});   
                }
            FlxG.sound.play(Paths.sound('wah_' + wahGacha));
            trace("tako!");
        }

    function FromTressa():Void
        {
            logoBl.alpha = 0;
            devGroup.visible = false;
            specialGroup.visible = false;
            tressaText.alpha = 1;
        }

    function Test():Void
        {
            FlxG.sound.music.stop();
            FlxG.switchState(new TestMenu());
        }

    override function beatHit()
        {
            super.beatHit();

            logoBl.animation.play('bump', true);
        }
}