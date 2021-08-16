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

	override function create()
	{
		super.create();

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
		txt.alpha = 0;

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
		jpTxt.alpha = 0;

		var esTxt:FlxText = new FlxText(0, 0, FlxG.width,
			"Este mod no está respaldado ni afiliado oficialmente con COVER Corporation, Hololive, o cualquiera de los talentos de Hololive.\n"
			+ "\nHoloFunk es ante todo un mod creado por fans impulsado por pasión y amor por hololive y Friday Night Funkin. "
			+ "Su continuidad debe tratarse como algo completamente separado de los de los dos medios principales mencionados anteriormente, y como tal, "
			+ "los eventos pueden desviarse de los sucesos de la vida real y lo establecido en el canon.\n"
			+ "\nTENGA EN CUENTA: INA WEEK NO ES CANON EN EL LORE DE HOLOFUNK!!!\n"
			+ "\nIna Week también fue desarrollado por un equipo separado del equipo principal de HoloFunk.\n"
			+ "\nHay una cancion que tomará unos cuantos minutos para cargar -- por favor se paciente durante ese tiempo!\n"
			+ "\nPresiona ESPACIO o ENTER para continuar.\n",
			32);
		esTxt.setFormat(Paths.font("rhp.ttf"), 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		esTxt.borderColor = FlxColor.BLACK;
		esTxt.borderSize = 3;
		esTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		esTxt.screenCenter();
		esTxt.alpha = 0;

		add(txt);
		add(jpTxt);
		add(esTxt);

		switch(FlxG.save.data.inaLanguage)
		{
			case 'ENGLISH':
				txt.alpha = 1;
			case 'JAPANESE':
				jpTxt.alpha = 1;
			case 'SPANISH':
				esTxt.alpha = 1;
			default:
				trace(FlxG.save.data.inaLanguage);
				trace("im sorry what");
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