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

class Disclaimer extends MusicBeatState
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

	var language = false;

	override function create()
	{
		super.create();

		if (FlxG.save.data.inaLanguage)
			{
				language = true;
			}

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		add(bg);
		
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"This mod is not endorsed nor officially affiliated with COVER Corporation, hololive, or any of hololive’s talents."
			+ "\n\nHoloFunk is first and foremost a fan-made mod driven by"
			+ " passion and love for hololive and Friday Night Funkin."
			+ " Its continuity is to be treated as completely separate"
			+ " from those of both aforementioned parent media, and as such,"
			+ " events may deviate from real life occurrences"
			+ " and what is established in canon."
			+ "\n\nPLEASE NOTE: INA WEEK IS NON CANON TO THE HOLOFUNK LORE!!!\n"
			+ "\nIna Week was also developed by a team separate from the main HoloFunk team.\n"
			+ "\nThere is a song that will take a few minutes to load -- please be patient during that time!\n"
			+ "\nPress SPACE or ENTER to continue.\n\n",
			32);
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();

		var jpTxt:FlxText = new FlxText(0, 0, FlxG.width,
			"このMODはCOVER Corp.、ホロライブ、またはそのメンバーからの正式な認定や支持を受けておりません。\n"
			+ "\nHoloFunkは何よりもまず、ホロライブとFriday Night Funkin'への情熱と愛によって駆り立てられたファンメイドのMODです。\n\n"
			+ "\nその継続性は上記の両方の親メディアのそれとは全く別のものとして扱われます。\n"
			+ "\nそのため、現実の出来事や規範とは異なることがあります。\n"
			+ "\nご注意：イナ・ウィークはホロファンクの伝承とは無関係です！！\n"
			+ "\nIna Weekは、HoloFunkのメインチームとは別のチームが開発を担当しました\n"
			+ "\n読み込みに数分かかる曲がありますが、そのまましばらくお待ち下さい！\n"
			+ "\nSPACE_ か ENTER↲を押して続ける...\n",
			32);
		jpTxt.setFormat(Paths.font("rhp.ttf"), 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		jpTxt.borderColor = FlxColor.BLACK;
		jpTxt.borderSize = 3;
		jpTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		jpTxt.screenCenter();

		add(txt);
		add(jpTxt);
		if (language)
			{
				txt.alpha = 0;
				jpTxt.alpha = 1;
			}
		else
			{
				jpTxt.alpha = 0;
				txt.alpha = 1;
			}
		
		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
			if(colorRotation < (bgColors.length - 1)) colorRotation++;
			else colorRotation = 0;
		}, 0);
		
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}