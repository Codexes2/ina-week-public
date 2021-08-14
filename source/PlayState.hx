package;

import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.group.FlxGroup;
import flixel.math.FlxRandom;
import openfl.media.Sound;
#if sys
import sys.io.File;
import smTools.SMFile;
#end
import openfl.ui.KeyLocation;
import openfl.events.Event;
import haxe.EnumTools;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Replay.Ana;
import Replay.Analysis;
#if cpp
import webm.WebmPlayer;
#end
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public var credGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var creditText:Array<String> = ["Holofunk:\nNon Canon Ina Week",
											"Epilogue:\nCalli:\nWith the studio literally catching on fire by an indoor volcano, alot of equipment Calli used was damaged and needed replacements. She decided to invite Kusotori on a shopping date to help repair the studio.",
											"Ame and Gura:\nEscaping the “Underwater Timeloop”, Ame and Gura needed time off from the sight of large bodies of water. They happily went off to spend their moment of relaxation at a nearby amusement park within the city.",
											"Haachama:\nUnfazed by the merging and dispication of the Painted World, Haachama went along her week as if nothing happened. However, the power resided within the merging made a tasty afternoon snack.",
											"Botan:\nAs the city began to shine where the day and night cycle returned to normal, Botan invited all her genmates to Kiryu Coco's bar and celebrated Aloe’s victory with a toast. Botan herself had enough craziness for one week.",
											"Ina:\nIna remained to keep check on the retraction of the Painted World. She apologized to the other Holo members that were affected by her actions. Ina now wanders the world to gather knowledge and improve her singing skills.",
											"Aloe and Nene:\nAfter their celebration with the gen 5 crew, Aloe and Nene spent a night alone watching fireworks. Aloe vowing to do everything to protect Nene, and Nene putting her trust in Aloe… Their bonds are truly inseparable and nothing will ever close to break them.",
											"Full Credits:",
											"Tressa\nDirector/Primary Artist",
										    "lam\nSecondary Artist",
										    "Codexes\nPrimary Programmer/Lead Charter",
										    "Awoofle\nSecondary Programmer",
										    "ASARI\nPrimary Musician",
										    "Holo Bass\nSecondary Musician",
										    "Tacocat\nBeta Tester/Motivational Cheerleader",
										    "Holofunk Dev Team:\nKeaton Hoshida, TheCoolStalker, GGalactigal\nDangermad, SaltyHotcakes, C013",
										    "Special thanks and love to:\nNINOMAE INA'NIS, HOLOEN, AND ALL OF HOLOLIVE!!\n\nSpecial thanks to the bros:\nAqwa, Bam, Barry, Blizz, Bumpadump, Dash4Speed, DatSatoGuy, Dewdrop, Dizzy, Futurechama, Grand Hammer 6, Inkami, Kotowari, Maki, Matt_Is_G, Mico, Osu, Telos, Tulsnd, Tunaki, You (the player)!"];

	public var textUnlock:FlxText;
	public var iconArray:Array<String> = ["dad", "spooky", "monster", "pico", "ina", "gf"];
	public var credIcon:HealthIcon;

	public var vignette:FlxSprite;
	public var olVoid:FlxSprite;
	public var olVoidTentacles:FlxSprite;
	public var holoSign:FlxSprite;
	public var lastRemote:FlxSprite;

	public var heartGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var extraLife:FlxSprite;
	public var hearts:Int = 3;

	private var vignetteCamera:FlxCamera;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;
	public static var inResults:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	private var dialogueList = CoolUtil.coolTextFile("assets/data/dialogueList.txt");
	private var dialogueEndList = CoolUtil.coolTextFile("assets/data/dialogueEndList.txt");

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var isSM:Bool = false;
	#if sys
	public static var sm:SMFile;
	public static var pathToSm:String;
	#end

	public var originalX:Float;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;

	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;

	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	public var maxhealth:Float = 2;
	public var maxHPtoChange:Float = 0.0;

	private var combo:Int = 0;

	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;
	

	public var accuracy:Float = 0.00;

	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camDialogue:FlxCamera;
	private var camGame:FlxCamera;
	public var cannotDie = false;

	public static var offsetTesting:Bool = false;

	public var isSMFile:Bool = false;

	var takoTweens:FlxTweenManager = new FlxTweenManager();
	var takoColors:Array<String> = ['Blue', 'BlueDark', 'Cyan', 'Gold', 'Green', 'GreenLime', 
									'LightPink', 'Neutral', 'Orange', 'Pink', 'Purple', 'Red', 
									'RedPink', 'Torquoise', 'Violet', 'Yellow'];

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;
	var idleToBeat:Bool = true; // change if bf and dad would idle to the beat of the song
	var idleBeat:Int = 2; // how frequently bf and dad would play their idle animation(1 - every beat, 2 - every 2 beats and so on)

	var dialogue:Array<String> = [];
	var dialogueEnd:Array<String> = [];
	public var usesDialogue:Bool = false;
	public var usesEndDialogue:Bool = false;
	var doof:DialogueBox;
	var doof2:DialogueBox;
	var fReturn:String;

	public var takoSquad1:Bool = false;
	public var takoSquad2:Bool = false;
	public var takoSquad3:Bool = false;
	public var takoSquad4:Bool = false;
	public var takoHPSquad1:Bool = false;
	public var takoHPSquad2:Bool = false;

	public static var isRadience:Bool = false;
	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;

	public var songScore:Int = 0;

	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	var usedTimeTravel:Bool = false;

	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;

	// Per song additive offset
	public static var songOffset:Float = 0;

	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	public static var sectionStart:Bool =  false;
	public static var sectionStartPoint:Int =  0;
	public static var sectionStartTime:Float =  0;

	private var executeModchart = false;

	// Animation common suffixes
	private var dataSuffix:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	private var dataColor:Array<String> = ['purple', 'blue', 'green', 'red'];

	public static var startTime = 0.0;

	// API stuff
	
	public function addObject(object:FlxBasic)
	{
		add(object);
	}

	public function removeObject(object:FlxBasic)
	{
		remove(object);
	}

	public var debug = false;

	// ⡯⡯⡾⠝⠘⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢊⠘⡮⣣⠪⠢⡑⡌ ㅤ
	// ⠟⠝⠈⠀⠀⠀. ⠡⠀⠠⢈⠠⢐⢠⢂⢔⣐⢄⡂⢔⠀⡁⢉⠸⢨⢑⠕⡌ ㅤ ⠀
	// ⠀ ⡀⠁⠀⠀⠀⡀⢂⠡⠈⡔⣕⢮⣳⢯⣿⣻⣟⣯⣯⢷⣫⣆⡂ ⢐⠑⡌
	// ⢀⠠⠐⠈⠀⢀⢂⠢⡂⠕⡁⣝⢮⣳⢽⡽⣾⣻⣿⣯⡯⣟⣞⢾⢜⢆⠀⡀⠀⠪
	// ⣬⠂⠀⠀⢀⢂⢪⠨⢂⠥⣺⡪⣗⢗⣽⢽⡯⣿⣽⣷⢿⡽⡾⡽⣝⢎⠀⠀⠀⢡
	// ⣿⠀⠀⠀⢂⠢⢂⢥⢱⡹⣪⢞⡵⣻⡪⡯⡯⣟⡾⣿⣻⡽⣯⡻⣪⠧⠑⠀⠁⢐
	// ⣿⠀⠀⠀⠢⢑⠠⠑⠕⡝⡎⡗⡝⡎⣞⢽⡹⣕⢯⢻⠹⡹⢚⠝⡷⡽⡨⠀⠀⢔
	// ⣿⡯⠀⢈⠈⢄⠂⠂⠐⠀⠌⠠⢑⠱⡱⡱⡑⢔⠁⠀⡀⠐⠐⠐⡡⡹⣪⠀⠀⢘
	// ⣿⣽⠀⡀⡊⠀⠐⠨⠈⡁⠂⢈⠠⡱⡽⣷⡑⠁⠠⠑⠀⢉⢇⣤⢘⣪⢽⠀⢌⢎
	// ⣿⢾⠀⢌⠌⠀⡁⠢⠂⠐⡀⠀⢀⢳⢽⣽⡺⣨⢄⣑⢉⢃⢭⡲⣕⡭⣹⠠⢐⢗
	// ⣿⡗⠀⠢⠡⡱⡸⣔⢵⢱⢸⠈⠀⡪⣳⣳⢹⢜⡵⣱⢱⡱⣳⡹⣵⣻⢔⢅⢬⡷
	// ⣷⡇⡂⠡⡑⢕⢕⠕⡑⠡⢂⢊⢐⢕⡝⡮⡧⡳⣝⢴⡐⣁⠃⡫⡒⣕⢏⡮⣷⡟
	// ⣷⣻⣅⠑⢌⠢⠁⢐⠠⠑⡐⠐⠌⡪⠮⡫⠪⡪⡪⣺⢸⠰⠡⠠⠐⢱⠨⡪⡪⡰
	// ⣯⢷⣟⣇⡂⡂⡌⡀⠀⠁⡂⠅⠂⠀⡑⡄⢇⠇⢝⡨⡠⡁⢐⠠⢀⢪⡐⡜⡪⡊
	// ⣿⢽⡾⢹⡄⠕⡅⢇⠂⠑⣴⡬⣬⣬⣆⢮⣦⣷⣵⣷⡗⢃⢮⠱⡸⢰⢱⢸⢨⢌
	// ⣯⢯⣟⠸⣳⡅⠜⠔⡌⡐⠈⠻⠟⣿⢿⣿⣿⠿⡻⣃⠢⣱⡳⡱⡩⢢⠣⡃⠢⠁
	// ⡯⣟⣞⡇⡿⣽⡪⡘⡰⠨⢐⢀⠢⢢⢄⢤⣰⠼⡾⢕⢕⡵⣝⠎⢌⢪⠪⡘⡌⠀
	// ⡯⣳⠯⠚⢊⠡⡂⢂⠨⠊⠔⡑⠬⡸⣘⢬⢪⣪⡺⡼⣕⢯⢞⢕⢝⠎⢻⢼⣀⠀
	// ⠁⡂⠔⡁⡢⠣⢀⠢⠀⠅⠱⡐⡱⡘⡔⡕⡕⣲⡹⣎⡮⡏⡑⢜⢼⡱⢩⣗⣯⣟
	// ⢀⢂⢑⠀⡂⡃⠅⠊⢄⢑⠠⠑⢕⢕⢝⢮⢺⢕⢟⢮⢊⢢⢱⢄⠃⣇⣞⢞⣞⢾
	// ⢀⠢⡑⡀⢂⢊⠠⠁⡂⡐⠀⠅⡈⠪⠪⠪⠣⠫⠑⡁⢔⠕⣜⣜⢦⡰⡎⡯⡾⡽
	
	override public function create()
	{

		#if debug
		debug = true;
		#end

		FlxG.mouse.visible = false;
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast(Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		highestCombo = 0;
		repPresses = 0;
		repReleases = 0;
		inResults = false;



		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) 
		{
			case 'dad-battle': 
				songLowercase = 'dadbattle';
			case 'philly-nice': 
				songLowercase = 'philly';
		}
		
		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialogue = new FlxCamera();
		camDialogue.bgColor.alpha = 0;

		vignetteCamera = new FlxCamera();
		vignetteCamera.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);
		FlxG.cameras.add(vignetteCamera);

		add(takoTweens);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		var songDialogue = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		trace(songDialogue);

		if(FlxG.save.data.inaLanguage)
			{
				if(dialogueList.contains(songDialogue))
					{
						trace("got the dialogue");
						dialogue = CoolUtil.coolTextFile("assets/data/" + songDialogue + "/dialogueJP.txt");
						usesDialogue = true;
					}
				
				if(dialogueEndList.contains(songDialogue))
					{
						trace("got the end dialogue");
						dialogueEnd = CoolUtil.coolTextFile("assets/data/" + songDialogue + "/dialogueEndJP.txt");
						usesEndDialogue = true;
					}
			}
		else
			{
				if(dialogueList.contains(songDialogue))
					{
						trace("got the dialogue");
						dialogue = CoolUtil.coolTextFile("assets/data/" + songDialogue + "/dialogue.txt");
						usesDialogue = true;
					}
				
				if(dialogueEndList.contains(songDialogue))
					{
						trace("got the end dialogue");
						dialogueEnd = CoolUtil.coolTextFile("assets/data/" + songDialogue + "/dialogueEnd.txt");
						usesEndDialogue = true;
					}
			}

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: '
			+ Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay);

		// dialogue shit
		switch (songLowercase)
		{
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/thorns/thornsDialogue'));
		}	

		// defaults if no stage was found in chart
		var stageCheck:String = 'stage';
		
		if (SONG.stage == null)
			{
				switch (storyWeek)
				{
					case 2:
						stageCheck = 'halloween';
					case 3:
						stageCheck = 'philly';
				}
			}
			else
			{
				stageCheck = SONG.stage;
			}

		if (!PlayStateChangeables.Optimize)
		{
		switch (stageCheck)
		{
			case 'halloween': 
				{
					curStage = 'spooky';
					halloweenLevel = true;

					var hallowTex = Paths.getSparrowAtlas('halloween_bg', 'week2');

							halloweenBG = new FlxSprite(-200, -100);
							halloweenBG.frames = hallowTex;
							halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
							halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
							halloweenBG.animation.play('idle');
							if(FlxG.save.data.antialiasing)
								{
									halloweenBG.antialiasing = true;
								}
							add(halloweenBG);

					isHalloween = true;
				}
			case 'halloweenPaint':
				{
					curStage = 'spooky';
					halloweenLevel = true;

					var hallowTex = Paths.getSparrowAtlas('halloweenPaint/halloween_bg', 'week2');

					halloweenBG = new FlxSprite(-200, -50);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					if(FlxG.save.data.antialiasing)
						{
							halloweenBG.antialiasing = true;
						}
					add(halloweenBG);

					isHalloween = true;
				}
			case 'philly': 
				{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if (FlxG.save.data.distractions)
					{
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							if(FlxG.save.data.antialiasing)
								{
									light.antialiasing = true;
								}
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
					if (FlxG.save.data.distractions)
					{
						add(phillyTrain);
					}

					if(FlxG.save.data.rushia)
					{
						trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes_rushia','week3'));
					}
					else
					{
						trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					}

					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
				}
				case 'phillyPaint':
					{
						curStage = 'philly';

						var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('phillyPaint/sky', 'week3'));
						bg.scrollFactor.set(0.1, 0.1);
						add(bg);

						var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('phillyPaint/city', 'week3'));
						city.scrollFactor.set(0.3, 0.3);
						city.setGraphicSize(Std.int(city.width * 0.85));
						city.updateHitbox();
						add(city);

						phillyCityLights = new FlxTypedGroup<FlxSprite>();
						if (FlxG.save.data.distractions)
						{
							add(phillyCityLights);
						}

						for (i in 0...5)
						{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('phillyPaint/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							if(FlxG.save.data.antialiasing)
								{
									light.antialiasing = true;
								}
							phillyCityLights.add(light);
						}

						var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('phillyPaint/behindTrain', 'week3'));
						add(streetBehind);

						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('phillyPaint/train', 'week3'));
						if (FlxG.save.data.distractions)
						{
							add(phillyTrain);
						}

						trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'week3'));
						FlxG.sound.list.add(trainSound);

						// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

						var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('phillyPaint/street', 'week3'));
						add(street);
					}
				case 'stagePaint':
					{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stagePaint/stageback', 'week1'));
						if(FlxG.save.data.antialiasing)
							{
								bg.antialiasing = true;
							}
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagePaint/stagefront', 'week1'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						if(FlxG.save.data.antialiasing)
							{
								stageFront.antialiasing = true;
							}
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);

						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagePaint/stagecurtains', 'week1'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						if(FlxG.save.data.antialiasing)
							{
								stageCurtains.antialiasing = true;
							}
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;

						add(stageCurtains);
					}
				case 'painted':
					{
						defaultCamZoom = 0.7;
						curStage = 'painted';
						var bg:FlxSprite = new FlxSprite(-300, -200).loadGraphic(Paths.image('inaStage/inaBG', 'week4'));
						bg.setGraphicSize(Std.int(bg.width * 1.1));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.3, 0.3);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('inaStage/inaFG', 'week4'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.3));
						stageFront.updateHitbox();
						stageFront.antialiasing = FlxG.save.data.antialiasing;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
				}
	
				case 'darkness':
					{
						defaultCamZoom = 0.7;
						curStage = 'darkness';
						var bg:FlxSprite = new FlxSprite(-300, -100).loadGraphic(Paths.image('inaStage/inaDBG', 'week4'));
						bg.setGraphicSize(Std.int(bg.width * 1.1));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.3, 0.3);
						bg.active = false;
						add(bg);
					}
					
				case 'radience':
					{
						defaultCamZoom = 0.7;
						curStage = 'radience';
						var bg:FlxSprite = new FlxSprite(-250, 0).loadGraphic(Paths.image('inaStage/inKnightBG', 'week4'));
						bg.setGraphicSize(Std.int(bg.width * 1.25));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('inaStage/inKnightFG', 'week4'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
						stageFront.updateHitbox();
						stageFront.antialiasing = FlxG.save.data.antialiasing;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
					}
				case 'gensokyo':
					{
						defaultCamZoom = 0.7;
						curStage = 'gensokyo';
						var bg:FlxSprite = new FlxSprite(-250, 0).loadGraphic(Paths.image('inaStage/Gensokyo_Background', 'week4'));
						bg.setGraphicSize(Std.int(bg.width * 2.15));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						
	
						var stageFront:FlxSprite = new FlxSprite(-350, -50).loadGraphic(Paths.image('inaStage/Gensokyo_Foreground', 'week4'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 2.15));
						stageFront.updateHitbox();
						stageFront.antialiasing = FlxG.save.data.antialiasing;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;

						bg.y = stageFront.y + 500;
						bg.x = stageFront.x + 500;

						add(bg);
						add(stageFront);
					}
				case 'saigyou':
					{
						defaultCamZoom = 0.6;
						curStage = 'saigyou';
						var bg:FlxSprite = new FlxSprite(-250, 0).loadGraphic(Paths.image('inaStage/Saigyou_Ayakashi', 'week4'));
						bg.setGraphicSize(Std.int(bg.width * 1.3));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
					}

				case 'extraStage1': //inaposter stage
					defaultCamZoom = 0.7;
					curStage = 'ES1';
					var bg:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('extraStage/FrigidCapital_Background', 'week4'));
					bg.setGraphicSize(Std.int(bg.width * 1.25));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-450, -250).loadGraphic(Paths.image('extraStage/FrigidCapital_Foreground', 'week4'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var crowdLeft:FlxSprite = new FlxSprite(-400, 210).loadGraphic(Paths.image('extraStage/cameos4', 'week4'));
					crowdLeft.updateHitbox();
					crowdLeft.flipX = true;
					crowdLeft.antialiasing = FlxG.save.data.antialiasing;
					crowdLeft.scrollFactor.set(0.9, 0.9);
					crowdLeft.active = false;
					add(crowdLeft);

					var crowdRight:FlxSprite = new FlxSprite(900, 150).loadGraphic(Paths.image('extraStage/cameos3', 'week4'));
					crowdRight.updateHitbox();
					crowdRight.flipX = true;
					crowdRight.antialiasing = FlxG.save.data.antialiasing;
					crowdRight.scrollFactor.set(0.9, 0.9);
					crowdRight.active = false;
					add(crowdRight);



				case 'extraStage2': //inapurgation stage
					{
						defaultCamZoom = 0.65;
						curStage = 'ES2';

						var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('extraStage/Back_Sky', 'week4'));
						bg.setGraphicSize(Std.int(bg.width * 1.3));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(1.0, 1.0);
						bg.active = false;

						var stageFront:FlxSprite = new FlxSprite(-700, -100).loadGraphic(Paths.image('extraStage/Front', 'week4'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.3));
						stageFront.updateHitbox();
						stageFront.antialiasing = FlxG.save.data.antialiasing;
						stageFront.scrollFactor.set(1.0, 1.0);
						stageFront.active = false;

						var stageTop:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('extraStage/Middle2', 'week4'));
						stageTop.setGraphicSize(Std.int(stageTop.width * 1.3));
						stageTop.updateHitbox();
						stageTop.antialiasing = FlxG.save.data.antialiasing;
						stageTop.scrollFactor.set(1.0, 1.0);
						stageTop.active = false;

						var stageMiddle:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('extraStage/Middle1', 'week4'));
						stageMiddle.setGraphicSize(Std.int(stageMiddle.width * 1.3));
						stageMiddle.updateHitbox();
						stageMiddle.antialiasing = FlxG.save.data.antialiasing;
						stageMiddle.scrollFactor.set(1.0, 1.0);
						stageMiddle.active = false;

						var crowdLeft:FlxSprite = new FlxSprite(-700, 500).loadGraphic(Paths.image('extraStage/cameos1', 'week4'));
						crowdLeft.setGraphicSize(Std.int(crowdLeft.width * 1.0));
						crowdLeft.updateHitbox();
						crowdLeft.antialiasing = FlxG.save.data.antialiasing;
						crowdLeft.scrollFactor.set(1.0, 1.0);
						crowdLeft.active = false;

						var crowdRight:FlxSprite = new FlxSprite(1100, 400).loadGraphic(Paths.image('extraStage/cameos2', 'week4'));
						crowdRight.setGraphicSize(Std.int(crowdRight.width * 1.0));
						crowdRight.updateHitbox();
						crowdRight.antialiasing = FlxG.save.data.antialiasing;
						crowdRight.scrollFactor.set(1.0, 1.0);
						crowdRight.active = false;

						bg.y = stageFront.y + 100;
						bg.x = stageFront.x + 100;
						stageTop.y = stageFront.y + 100;
						stageTop.x = stageFront.x;
						stageMiddle.y = stageFront.y + 100;
						stageMiddle.x = stageFront.x;

						add(bg);
						add(stageTop);
						add(stageMiddle);
						add(stageFront);
						add(crowdLeft);
						add(crowdRight);
					}
				case 'extraStage3': //eldritch phantasm stage
					{
						defaultCamZoom = 0.65;
						curStage = 'ES3';
						var bg:FlxSprite = new FlxSprite(-250, 0).loadGraphic(Paths.image('extraStage/ExtraStage', 'week4'));
						bg.setGraphicSize(Std.int(bg.width * 1.3));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
					}
				
				case 'eidolic': // :)
					{
						defaultCamZoom = 0.75;
						curStage = 'eidolic';
						var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('extraStage/eidolic/Emptiness_BG', 'week4'));
						bg.setGraphicSize(Std.int(bg.width * 1.1));
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;

						var fleshBG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('extraStage/eidolic/Flesh_Background', 'week4'));
						fleshBG.setGraphicSize(Std.int(fleshBG.width * 1.1));
						fleshBG.antialiasing = FlxG.save.data.antialiasing;
						fleshBG.scrollFactor.set(0.9, 0.9);
						fleshBG.active = false;

						var heart:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('extraStage/eidolic/CrimsonHeart', 'week4'));
						heart.setGraphicSize(Std.int(heart.width * 1.1));
						heart.antialiasing = FlxG.save.data.antialiasing;
						heart.scrollFactor.set(0.9, 0.9);
						heart.active = false;

						var stage:FlxSprite = new FlxSprite(-300, -200).loadGraphic(Paths.image('extraStage/eidolic/Flesh_Foreground', 'week4'));
						stage.setGraphicSize(Std.int(stage.width * 1.1));
						stage.antialiasing = FlxG.save.data.antialiasing;
						stage.scrollFactor.set(0.9, 0.9);
						stage.active = false;

						bg.x = stage.x;
						fleshBG.x = stage.x;
						heart.x = stage.x;

						add(bg);
						add(fleshBG);
						add(heart);
						add(stage);
					}
				default:
					{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stage/stageback', 'week1'));
						if(FlxG.save.data.antialiasing)
							{
								bg.antialiasing = true;
							}
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stage/stagefront', 'week1'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						if(FlxG.save.data.antialiasing)
							{
								stageFront.antialiasing = true;
							}
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stage/stagecurtains', 'week1'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						if(FlxG.save.data.antialiasing)
							{
								stageCurtains.antialiasing = true;
							}
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
		}
		}
		// defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null)
		{
			switch (storyWeek)
			{
				case 5:
					gfCheck = 'gf-christmas';
				case 6:
					gfCheck = 'gf-pixel';
			}
		}
		else
		{
			gfCheck = SONG.gfVersion;
		}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			default:
				curGf = 'gf';
		}

		if (curStage == 'ES1')
			{
				curGf = 'gf-sus';
			}
		
		gf = new Character(400, 130, curGf);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'gf-aloe':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 100;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 250;
			case 'ina':
				dad.x -= 100;
				dad.y += 130;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'ina2':
				dad.x -= 380;
				dad.y += 110;
			case 'inaKnight':
				dad.x -= 415;
				dad.y += 130;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'inaKnightP2':
				dad.x -= 415;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}


		var creditsSong:Bool = false;
		if (SONG.song == 'Stand By Me')
			{
				creditsSong = true;
			}
		
		if(creditsSong)
			{
				boyfriend = new Boyfriend(600 , -19, "ina");
			}
		else
			{
				boyfriend = new Boyfriend(758, 430, SONG.player1);
			}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'painted' | 'ES3':
				isRadience = false;
				boyfriend.x += 140;
				boyfriend.y += 160;
				gf.y += 80;
			case 'darkness':
				if (SONG.song == 'Stand By Me')
					{
						trace('im here');
						isRadience = false;
						boyfriend.x -= 100;
						boyfriend.y += 130;
						dad.alpha = 0;
						gf.alpha = 0;
					}
				else
					{
						isRadience = false;
						boyfriend.x += 140;
						boyfriend.y += 160;
						gf.alpha = 0;
					}
			case 'radience':
				isRadience = true;
				boyfriend.x += 80;
				boyfriend.y += 190;
				gf.x -= 60;
				gf.y += 150;
			case 'gensokyo':
				isRadience = false;
				boyfriend.y += 250;
				gf.y += 250;
			case 'saigyou':
				isRadience = false;
				boyfriend.y += 250;
				gf.y += 250;
			case 'ES1':
				isRadience = false;
				boyfriend.y += 150;
				gf.y += 150;
			case 'ES2':
				isRadience = false;
				dad.x -= 180;
				dad.y += 170;
				boyfriend.x -= 10;
				boyfriend.y += 330;
				gf.x -= 190;
				gf.y += 330;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'eidolic':
				boyfriend.x += 80;
				gf.alpha = 0;
		}

		if (!PlayStateChangeables.Optimize)
		{
			add(gf);

			// Shitty layering but whatev it works LOL
			if (curStage == 'limo')
				add(limo);

			add(dad);
			add(boyfriend);
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses', repPresses);
			FlxG.watch.addQuick('rep releases', repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		doof = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		doof2 = new DialogueBox(false, dialogueEnd);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof2.scrollFactor.set();
		doof2.finishThing = endReturn;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);
		
		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		if(SONG.opponentHealth>0)
			{
				maxhealth = SONG.opponentHealth;
			}
			else
			{
				maxhealth = 2;
				SONG.opponentHealth = 2;
			}
	
			if(SONG.startingHealth>0){
				health = SONG.startingHealth;
				SONG.startingHealth = health;}
			else{
				health = 1;
				SONG.startingHealth = 1;}
		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (PlayStateChangeables.useDownscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5), songPosBG.y, 0, SONG.song, 16);
				if (PlayStateChangeables.useDownscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

	var characterCol:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/characterList'));
	var col:Array<FlxColor> = [
		0xFF800080, // ALOE
		0xFF800080, // ALOE SCARED
		0xFFE5ACB6, // CALLIOPE
		0xFFFFF29E, // NENE
		0xFF57B692, // AMELIA AND GURA
		0xFFC0CAE5, // BOTAN
		0xFF33254c, // INA
		0xFF33254c, // INA P2
		0xFF33254c, // INAKNIGHT
		0xFF33254c  // INAKNIGHT P2
	];
		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, maxhealth);
		healthBar.scrollFactor.set();
		var curcol:FlxColor = col[characterCol.indexOf(dad.curCharacter)]; // Dad Icon
		var curcol2:FlxColor = col[characterCol.indexOf(boyfriend.curCharacter)]; // Bf Icon
		healthBar.createFilledBar(curcol, curcol2); // Use those colors
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4, healthBarBG.y
			+ 50, 0,
			SONG.song
			+ " - "
			+ CoolUtil.difficultyFromInt(storyDifficulty)
			+ (Main.watermarks ? " | KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		if (curStage == 'ES2')
			{
				kadeEngineWatermark.alpha = 0;
			}
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		scoreTxt.screenCenter(X);

		originalX = scoreTxt.x;

		scoreTxt.scrollFactor.set();
		
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY",
			20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0,
			"BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if (PlayStateChangeables.botPlay && !loadRep)
			add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		switch(curSong) //changing certain healthicons
		{
			case 'Inapurgation' | 'Eldritch Phantasm':
				{
					iconP2 = new HealthIcon('inapurgation', false);
					iconP2.y = healthBar.y - (iconP2.height / 2);
					add(iconP2);
				}
			case 'Bordering Final Story':
				{
					iconP2 = new HealthIcon('inaKnightP2Ow', false);
					iconP2.y = healthBar.y - (iconP2.height / 2);
					add(iconP2);
				}
			default:
				{	
					iconP2 = new HealthIcon(SONG.player2, false);
					iconP2.y = healthBar.y - (iconP2.height / 2);
					add(iconP2);
				}
		}


		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camDialogue];
		doof2.cameras = [camDialogue];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (curSong.toLowerCase() == 'stand by me' || curSong.toLowerCase() == 'radiant heaven' 
			|| curSong.toLowerCase() == 'eidolic stained heart')
			{
				trace('hiding shit');
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong, " ", "-").toLowerCase())
			{					
				default:
					if(usesDialogue && storyPlaylist.length >= 1){
						//trace("it somehow got through???");
						startCutscene(doof);
					}
					else if (usesEndDialogue && storyPlaylist.length == 0) {
						fReturn = "story";
						trace(PlayState.storyPlaylist[0]);
						if (PlayState.storyPlaylist[0] == null && storyWeek == 4)
							{
								trace("you're going to credit jail");
								fReturn = "credits";
							}
						endCutscene(doof2);
					}
					else{
						startCountdown();
					}
			}
		}
		else
		{
			startCountdown();
		}

		//gotta hardcode these vignettes!
		//very weird!
		vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
		vignette.width = 1280;
		vignette.height = 720;
		vignette.x = 0;
		vignette.y = 0;
		add(vignette);
		vignette.cameras = [vignetteCamera];
		vignette.alpha = 0;

		olVoid = new FlxSprite().loadGraphic(Paths.image('Overlay_Void'));
		olVoid.width = 1280;
		olVoid.height = 720;
		olVoid.x = 0;
		olVoid.y = 0;
		add(olVoid);
		olVoid.cameras = [vignetteCamera];
		olVoid.alpha = 0;

		olVoidTentacles = new FlxSprite().loadGraphic(Paths.image('Overlay_Void_Tentacles'));
		olVoidTentacles.width = 1280;
		olVoidTentacles.height = 720;
		olVoidTentacles.x = 0;
		olVoidTentacles.y = 0;
		add(olVoidTentacles);
		olVoidTentacles.cameras = [vignetteCamera];
		olVoidTentacles.alpha = 0;

		holoSign = new FlxSprite().loadGraphic(Paths.image('HoloSign_Activation'));
		holoSign.x = 400;
		holoSign.y = 200;
		add(holoSign);
		holoSign.cameras = [vignetteCamera];
		holoSign.alpha = 0;

		for (i in 0...3)
			{
				extraLife = new FlxSprite(1050, -50 + (i * 150)).loadGraphic(Paths.image('Lives'));
				extraLife.setGraphicSize(Std.int(extraLife.width * 0.50));
				heartGroup.add(extraLife);
			}
		add(heartGroup);
		heartGroup.cameras = [camHUD];
		if (curSong != 'Eldritch Phantasm')
			{
				heartGroup.visible = false;
			}

		textUnlock = new FlxText(0, FlxG.height/2, FlxG.width/2, "Ina Week unlocked in Freeplay \n+ an extra song!", 32);
		textUnlock.setFormat("VCR OSD Mono", 24, FlxColor.fromRGB(200, 200, 200), CENTER);
		textUnlock.borderColor = FlxColor.BLACK;
		textUnlock.borderSize = 2;
		textUnlock.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(textUnlock);
		textUnlock.cameras = [camHUD];
		textUnlock.alpha = 0;


		for (i in 0...creditText.length)
			{
				if (i <= 6 && i > 0) //for epilogue text
					{
						var credIcon = new HealthIcon(iconArray[i-1], false);
						var credline = new FlxText(0, 100 + (i * 300), FlxG.width/2, creditText[i], 32);
						credline.setFormat("VCR OSD Mono", 24, FlxColor.fromRGB(200, 200, 200), CENTER);
						credline.borderColor = FlxColor.BLACK;
						credline.borderSize = 2;
						credline.borderStyle = FlxTextBorderStyle.OUTLINE;

						credIcon.x = credline.x + 240;
						credIcon.y = credline.y + 155;
						if(iconArray[i-1] == 'dad')
							{
								credIcon.y = credline.y + 165;
							}
						if(iconArray[i-1] == 'monster')
							{
								credIcon.y = credline.y + 145;
							}
						if(iconArray[i-1] == 'ina')
							{
								credIcon.y = credline.y + 145;
							}
						if(iconArray[i-1] == 'gf')
							{
								credIcon.animation.curAnim.curFrame = 1;
							}
						credGroup.add(credIcon);
						credGroup.add(credline);
					}
				else if (i == 0) //this is the 1st element because i forgot how to do arrays wwwwww
					{
						var credline = new FlxText(0, 200, FlxG.width/2, creditText[i], 32);
						credline.setFormat("VCR OSD Mono", 24, FlxColor.fromRGB(200, 200, 200), CENTER);
						credline.borderColor = FlxColor.BLACK;
						credline.borderSize = 2;
						credline.borderStyle = FlxTextBorderStyle.OUTLINE;
						credGroup.add(credline);
					}
				else //for credit text
					{
						var credline = new FlxText(0, 1600 + (i * 100), FlxG.width/2, creditText[i], 32);
						credline.setFormat("VCR OSD Mono", 24, FlxColor.fromRGB(200, 200, 200), CENTER);
						credline.borderColor = FlxColor.BLACK;
						credline.borderSize = 2;
						credline.borderStyle = FlxTextBorderStyle.OUTLINE;
						credGroup.add(credline);
					}
			}
		add(credGroup);
		credGroup.y = 600;
		credGroup.cameras = [camHUD];
		credGroup.visible = false;
		
		lastRemote = new FlxSprite().loadGraphic(Paths.image('LastRemote_Activation'));
		lastRemote.x = 400;
		lastRemote.y = 200;
		add(lastRemote);
		lastRemote.cameras = [vignetteCamera];
		lastRemote.alpha = 0;

		if (!loadRep)
			rep = new Replay("na");

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, releaseInput);
		super.create();
	}

	function sendoutTako(tako:Int = 0, duration:Float = 0)
	{
		//trace ('tako ' + tako);
		var daTako:FlxSprite = new FlxSprite(0,0);

		var colorElem = FlxG.random.int(0, takoColors.length - 1);
		//trace(colorElem);

		daTako.frames = Paths.getSparrowAtlas('ina/colors/Tako' + takoColors[colorElem], 'shared');

		daTako.setGraphicSize(Std.int(daTako.width * 0.67));

		daTako.cameras = [camHUD];

		daTako.x = 2000;
		daTako.y = strumLine.y - 150;

		var takoYPosBegin:Float = strumLine.y - 50;
		var takoYPosEnd:Float = strumLine.y - 300;

		if(FlxG.save.data.downscroll){
			daTako.y = strumLine.y + 150;
			takoYPosEnd = strumLine.y + 150;
		}

		if (duration <= 0.0)
			{
				duration = FlxG.random.int(2, 10);
			}

		daTako.animation.addByPrefix('annoy', 'Tako0', 24, true);

		daTako.antialiasing = true;
		add(daTako);

		daTako.animation.play('annoy');

		var randomNum:Int = FlxG.random.int(600, 800);
		var randomNumY:Int = FlxG.random.int(200, 400);

		switch(tako)
		{
			case 0: //hover over strumline presses
				daTako.x = 1100;
				takoTweens.tween(daTako, {y: takoYPosBegin}, 0.7, {ease: FlxEase.elasticOut, onComplete:function(tween:FlxTween)
					takoTweens.tween(daTako, {x: 550}, duration, {ease: FlxEase.backInOut, onComplete:function(tween:FlxTween)
						{
							daTako.flipX = true;
							takoTweens.tween(daTako, {x: 1100}, duration, {ease: FlxEase.backInOut, onComplete:function(tween:FlxTween)
								takoTweens.tween(daTako, {y: takoYPosEnd}, 0.7, {ease: FlxEase.backIn, onComplete:function(tween:FlxTween)
									remove(daTako)})});
						}})});
			case 1: //hover all over the strumline
				daTako.x = 2000;
				daTako.y = strumLine.y + 300;
				
				//trace(randomNum);

				takoTweens.tween(daTako, {x: daTako.x - 900, y: randomNumY}, 0.7, {ease: FlxEase.quintInOut, onComplete:function(tween:FlxTween)
					takoTweens.quadMotion(daTako, daTako.x, daTako.y, randomNum, randomNum, 550, daTako.y, duration, true, {ease: FlxEase.quintInOut, onComplete:function(tween:FlxTween)
					{
						daTako.flipX = true;
						takoTweens.quadMotion(daTako, daTako.x, daTako.y, randomNum, randomNum, 1100, daTako.y, duration, true, {ease: FlxEase.quintInOut, onComplete:function(tween:FlxTween)
							takoTweens.tween(daTako, {x: 2000, y: daTako.y}, 0.7, {ease: FlxEase.quintInOut, onComplete:function(tween:FlxTween)
								remove(daTako)})});
					}})});
			case 2: //hover all over the strumline (y curve is different)
				daTako.x = 2000;
				daTako.y = strumLine.y + 300;
				
				//trace(randomNum);

				takoTweens.tween(daTako, {x: daTako.x - 900, y: randomNumY}, 0.7, {ease: FlxEase.quintInOut, onComplete:function(tween:FlxTween)
					takoTweens.quadMotion(daTako, daTako.x, daTako.y, randomNum, -randomNum + 300, 550, daTako.y, duration, true, {ease: FlxEase.quintInOut, onComplete:function(tween:FlxTween)
					{
						daTako.flipX = true;
						takoTweens.quadMotion(daTako, daTako.x, daTako.y, randomNum, -randomNum + 300, 1100, daTako.y, duration, true, {ease: FlxEase.quintInOut, onComplete:function(tween:FlxTween)
							takoTweens.tween(daTako, {x: 2000, y: daTako.y}, 0.7, {ease: FlxEase.quintInOut, onComplete:function(tween:FlxTween)
								remove(daTako)})});
					}})});
		}
	}

	var totalDamageTaken:Float = 0;

	var shouldBeDead:Bool = false;

	var interupt = false;

	// basic explanation of this is:
	// get the health to go to
	// tween the gremlin to the icon
	// play the grab animation and do some funny maths,
	// to figure out where to tween to.
	// lerp the health with the tween progress
	// if you loose any health, cancel the tween.
	// and fall off.
	// Once it finishes, fall off.

	//Credits to Kade
	function doGremlin(hpToTake:Int, duration:Int,persist:Bool = false)
	{
		interupt = false;

		grabbed = true;
		
		totalDamageTaken = 0;

		var gramlan:FlxSprite = new FlxSprite(0,0);

		gramlan.frames = Paths.getSparrowAtlas('ina/Takodachi','shared');

		gramlan.setGraphicSize(Std.int(gramlan.width * 0.76));

		gramlan.cameras = [camHUD];

		gramlan.x = iconP2.x + 200;
		gramlan.y = healthBarBG.y + 150;


		gramlan.animation.addByIndices('come','Tako', [0,1,2,3,4,5,6,7,8,9,10,11], "", 24, true);
		gramlan.animation.addByIndices('grab','TakoSucc',[12,13,14,15,16,17,18,19], "", 24, false);
		gramlan.animation.addByIndices('hold','TakoSucc',[20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39],"",30);
		gramlan.animation.addByIndices('release','TakoSucc',[40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60],"",30,false);

		gramlan.antialiasing = true;

		add(gramlan);

		var scrollSetting1:Float = healthBarBG.y - 120;
		var scrollSetting2:Float = healthBarBG.y + 300;

		if(FlxG.save.data.downscroll){
			gramlan.flipY = true;
			gramlan.y = healthBarBG.y - 300;
			scrollSetting1 = healthBarBG.y - 90;
			scrollSetting2 = healthBarBG.y - 500;
		}
		
		// over use of flxtween :)

		var startHealth = health;
		var toHealth = (hpToTake / 100) * startHealth; // simple math, convert it to a percentage then get the percentage of the health

		var perct = toHealth / 2 * 100;

		//trace('start: $startHealth\nto: $toHealth\nwhich is prect: $perct');

		var onc:Bool = false;



		FlxG.sound.play(Paths.sound('GremlinWoosh'));
		gramlan.animation.play('come');
		takoTweens.tween(gramlan, {y: scrollSetting1}, 0.7, {ease:FlxEase.elasticOut, onComplete: function(tween:FlxTween) {
			gramlan.animation.play('grab');
			gramlan.animation.finishCallback = function(pog:String)
				{
					//trace('time to succ');
					gramlan.animation.play('hold');
					takoTweens.tween(gramlan, {
						x: ((healthBar.x + 200) +
						(healthBar.width * (FlxMath.remapToRange(perct, 0, 100, 100, 0) * 0.01)
						- 26)) - 75}, duration,
					{
						onUpdate: function(tween:FlxTween) {
							if (interupt && !onc && !persist)
							{
								onc = true;
								//trace('wah');
								gramlan.animation.play('release');
								gramlan.animation.finishCallback = function(pog:String)
									{
										takoTweens.tween(gramlan, {y: scrollSetting2}, 0.7, {ease: FlxEase.backIn, onComplete: function(tween:FlxTween) {
											remove(gramlan);
										}});
									}
							}
							else if (!interupt || persist)
							{
								var pp = FlxMath.lerp(startHealth, toHealth, tween.percent);
								if (pp <= 0)
									pp = 0.1;
								health = pp;
							}
		
							if (shouldBeDead)
								health = 0;
						},
						onComplete: function(tween:FlxTween)
						{
							if (interupt && !persist)
								{
									remove(gramlan);
									grabbed = false;
								}
							else
								{
									//trace ('wah');
									if (persist && totalDamageTaken >= 0.7)
									health -= totalDamageTaken; // just a simple if you take a lot of damage wtih this, you'll loose probably.
									gramlan.animation.play('release');
									gramlan.animation.finishCallback = function(pog:String)
										{
											takoTweens.tween(gramlan, {y: scrollSetting2}, 0.5, {ease: FlxEase.backIn, onComplete: function(tween:FlxTween) {
												remove(gramlan);
											}});
										}
									grabbed = false;
								}
						}
					});
				}
		}});
	}	

	function startCutscene(?dialogueBox:DialogueBox):Void{

		inCutscene = true;
		camHUD.visible = false;
		add(dialogueBox);

	}

	function endCutscene(?dialogueBox:DialogueBox):Void{

		trace("endCutscene");
		var black:FlxSprite = new FlxSprite(-256, -256).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set(0);
		inCutscene = true;
		black.alpha = 0;
		add(black);
		camHUD.visible = false;
		FlxTween.tween(black, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		vocals.stop();
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			add(dialogueBox);
		});

	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;
		camHUD.visible = true;

		generateStaticArrows(0);
		generateStaticArrows(1);

		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) 
		{
			case 'dad-battle': 
				songLowercase = 'dadbattle';
			case 'philly-nice': 
				songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start', [songLowercase]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";
			var languageSet:String = '';
			if (FlxG.save.data.inaLanguage) {languageSet = 'jp/';}
			else {languageSet = 'en/';}

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					trace(value + " - " + curStage);
					introAlts = introAssets.get(value);
					if (curStage.contains('school'))
						altSuffix = '-pixel';
				}
			}
			switch (curSong.toLowerCase())
			{
				case 'weight of the universe' | 'unravelling distortion' | 'radiant heaven' | 'our nonstop story' 
					| 'bordering final story' | 'inapurgation' | 'eldritch phantasm' | 'stand by me' | 'eidolic stained heart':

					switch (swagCounter)
					{
						case 0:
						case 1:
						case 2:
						case 3:
						case 4:
					}
		
					swagCounter += 1;
				default:
					switch (swagCounter)
					{
						case 0:
							FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
						case 1:
							var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(languageSet + introAlts[0]));
							ready.scrollFactor.set();
							ready.updateHitbox();
		
							if (curStage.startsWith('school'))
								ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
		
							ready.screenCenter();
							add(ready);
							FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									ready.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
						case 2:
							var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(languageSet + introAlts[1]));
							set.scrollFactor.set();
		
							if (curStage.startsWith('school'))
								set.setGraphicSize(Std.int(set.width * daPixelZoom));
		
							set.screenCenter();
							add(set);
							FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									set.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
						case 3:
							var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(languageSet + introAlts[2]));
							go.scrollFactor.set();
		
							if (curStage.startsWith('school'))
								go.setGraphicSize(Std.int(go.width * daPixelZoom));
		
							go.updateHitbox();
		
							go.screenCenter();
							add(go);
							FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									go.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
						case 4:
					}
		
					swagCounter += 1;

			}

			// generateSong('fresh');
		}, 5);
	}	

	var grabbed = false;

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}

	var keys = [false, false, false, false];

	private function releaseInput(evt:KeyboardEvent):Void // handles releases
	{
		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode));
	
		var binds:Array<String> = [
			FlxG.save.data.leftBind,
			FlxG.save.data.downBind,
			FlxG.save.data.upBind,
			FlxG.save.data.rightBind
		];

		var data = -1;
		
		switch (evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (data == -1)
			return;

		keys[data] = false;
	}

	private function handleInput(evt:KeyboardEvent):Void
	{ // this actually handles press inputs

		if (PlayStateChangeables.botPlay || loadRep || paused)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode));
	
		var binds:Array<String> = [
			FlxG.save.data.leftBind,
			FlxG.save.data.downBind,
			FlxG.save.data.upBind,
			FlxG.save.data.rightBind
		];

		var data = -1;
		
		switch (evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}
		if (data == -1)
		{
			// trace("couldn't find a keybind with the code " + key);
			return;
		}
		if (keys[data])
		{
			// trace("ur already holding " + key);
			return;
		}

		keys[data] = true;

		var ana = new Ana(Conductor.songPosition, null, false, "miss", data);

		var dataNotes = [];
		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && daNote.noteData == data)
				dataNotes.push(daNote);
		}); // Collect notes that can be hit

		dataNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime)); // sort by the earliest note

		if (dataNotes.length != 0)
		{
			var coolNote = null;

			for (i in dataNotes)
				if (!i.isSustainNote)
				{
					coolNote = i;
					break;
				}

			if (coolNote == null) // Note is null, which means it's probably a sustain note. Update will handle this (HOPEFULLY???)
			{
				return;
			}

			if (dataNotes.length > 1) // stacked notes or really close ones
			{
				for (i in 0...dataNotes.length)
				{
					if (i == 0) // skip the first note
						continue;

					var note = dataNotes[i];

					if (!note.isSustainNote && (note.strumTime - coolNote.strumTime) < 2)
					{
						trace('found a stacked/really close note ' + (note.strumTime - coolNote.strumTime));
						// just fuckin remove it since it's a stacked note and shouldn't be there
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
				}
			}

			goodNoteHit(coolNote);
			var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
			ana.hit = true;
			ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
			ana.nearestNote = [coolNote.strumTime, coolNote.noteData, coolNote.sustainLength];
		}
		else if (!FlxG.save.data.ghost && songStarted)
		{
			noteMiss(data, null);
			ana.hit = false;
			ana.hitJudge = "shit";
			ana.nearestNote = [];
			health -= 0.10;
		}
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			#if sys
			if (!isStoryMode && isSM)
			{
				trace("Loading " + pathToSm + "/" + sm.header.MUSIC);
				var bytes = File.getBytes(pathToSm + "/" + sm.header.MUSIC);
				var sound = new Sound();
				sound.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);
				FlxG.sound.playMusic(sound);
			}
			else
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
			#else
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
			#end
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		if(sectionStart){
			FlxG.sound.music.time = sectionStartTime;
			Conductor.songPosition = sectionStartTime;
			vocals.time = sectionStartTime;
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if(!paused)
			resyncVocals();
		});

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x
				+ 4, songPosBG.y
				+ 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength
				- 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5), songPosBG.y, 0, SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch (curSong)
		{
			case 'Live Again' | 'Poi' : 
				allowedToHeadbang = true;
			default: 
				allowedToHeadbang = false;
		}

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	var debugNum:Int = 0;
	/*var secNum:Int = 0;
	var songNoteNum:Int = 0;
	var susNoteNum:Int = 0;*/

	public function generateSong(dataPath:String):Void
	{
		//FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		#if sys
		if (SONG.needsVoices && !isSM)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();
		#else
		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();
		#end

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) 
		{
			case 'dad-battle': 
				songLowercase = 'dadbattle';
			case 'philly-nice': 
				songLowercase = 'philly';
		}

		var songPath = 'assets/data/' + songLowercase + '/';
		
		#if sys
		if (isSM && !isStoryMode)
			songPath = pathToSm;
		#end

		for (file in sys.FileSystem.readDirectory(songPath))
		{
			var path = haxe.io.Path.join([songPath, file]);
			if (!sys.FileSystem.isDirectory(path))
			{
				if (path.endsWith('.offset'))
				{
					trace('Found offset file: ' + path);
					songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
					break;
				}
				else
				{
					trace('Offset file not found. Creating one @: ' + songPath);
					sys.io.File.saveContent(songPath + songOffset + '.offset', '');
				}
			}
		}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		
		for (section in noteData)
		{
			//secNum++;
			//trace("section " + secNum);

			if(sectionStart && daBeats < sectionStartPoint){
				daBeats++;
				continue;
			}
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				//songNoteNum++;
				//trace("songnotes " + songNoteNum);

				var daStrumTime:Float = Math.round(songNotes[0]) + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, false, songNotes[3]);

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				swagNote.sustainLength = songNotes[2];
				if(songNotes.length >= 4)
					{
						swagNote.noteType = songNotes[3];
					}
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				if (susLength > 0)
					swagNote.isParent = true;
				
				var type = 0;
				
				for (susNote in 0...Math.floor(susLength))
				{
					//susNoteNum++;
					//trace("susnotes "+ susNoteNum);

					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, false, songNotes[3]);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}

					sustainNote.parent = swagNote;
					swagNote.children.push(sustainNote);
					sustainNote.spotInLine = type;
					type++;
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			// defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';

			if (PlayStateChangeables.Optimize && player == 0)
				continue;

			if (SONG.noteStyle == null)
			{
				switch (storyWeek)
				{
					case 6:
						noteTypeCheck = 'pixel';
				}
			}
			else
			{
				noteTypeCheck = SONG.noteStyle;
			}

			switch (noteTypeCheck)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					for (j in 0...4)
					{
						babyArrow.animation.addByPrefix(dataColor[j], 'arrow' + dataSuffix[j]);	
					}

					var lowerDir:String = dataSuffix[i].toLowerCase();

					babyArrow.animation.addByPrefix('static', 'arrow' + dataSuffix[i]);
					babyArrow.animation.addByPrefix('pressed', lowerDir + ' press', 24, false);
					babyArrow.animation.addByPrefix('confirm', lowerDir + ' confirm', 24, false);

					babyArrow.x += Note.swagWidth * i;

					if(FlxG.save.data.antialiasing)
						{
							babyArrow.antialiasing = true;
						}
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			if(!(SONG.song == 'Stand By Me' || SONG.song == 'Radiant Heaven')) //hiding arrows and lua will make them appear later
				{
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 275;

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				spr.centerOffsets(); // CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") "
				+ Ratings.GenerateLetterRank(accuracy),
				"Acc: "
				+ HelperFunctions.truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText
					+ " "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") "
					+ Ratings.GenerateLetterRank(accuracy),
					"\nAcc: "
					+ HelperFunctions.truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC, true,
					songLength
					- Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (curSong.toLowerCase() == 'eidolic stained heart')
			{
				vignette.alpha = 1 - (health / 2);
			}
	
		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			}

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos', Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom', FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle', 'float');

			if (luaModchart.getVar("showOnlyStrums", 'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible", 'bool');
			var p2 = luaModchart.getVar("strumLine2Visible", 'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}
		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length - 1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
				iconP1.swapOldIcon();

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && !PlayStateChangeables.Optimize)
				{
					trainFrameTiming += elapsed;					

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore, songScoreDef, nps, maxNPS, accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		scoreTxt.x = (originalX - (lengthInPx / 2)) + 335;

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if (useVideo)
			{
				GlobalVideo.get().stop();
				remove(videoSprite);
				#if sys
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				#end
				removedVideo = true;
			}
			cannotDie = true;
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			sectionStart = false;
			if (debug)
				{
					FlxG.switchState(new ChartingState());
				}
			else
				{
					FlxG.switchState(new Tako());
				}
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.95)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.95)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > maxhealth)
			health = maxhealth;
		if (maxhealth >= 2.0)
			maxhealth = 2.0;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.SIX)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(SONG.player2));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			sectionStart = false;
			FlxG.switchState(new AnimationDebug(SONG.player1));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if (allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if (gf.animation.curAnim.name == 'danceLeft'
					|| gf.animation.curAnim.name == 'danceRight'
					|| gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Live Again':
						{
							// Where it starts || where it ends
							if(curBeat > 8 && curBeat < 144)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Poi':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 96 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				switch(curStage) //dad cam
				{
					case 'ES2':
						camFollow.setPosition(gf.getMidpoint().x - 150, gf.getMidpoint().y - 50);
					case 'eidolic':
						camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y);
					default:
						camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				}

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom' | 'mom-car':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai' | 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end

				switch(curStage) //boyfriend cam
				{
					case 'ES2':
						camFollow.setPosition(gf.getMidpoint().x + 150, gf.getMidpoint().y - 50);
					case 'eidolic':
						camFollow.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y - 100);
					default:
						camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);
				}

				if (curSong == 'Stand By Me')
					{
						camFollow.setPosition(boyfriend.getMidpoint().x - 330, boyfriend.getMidpoint().y);
					}

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("curBPM", Conductor.bpm);
		//FlxG.watch.addQuick("Closest Note", (unspawnNotes.length != 0 ? unspawnNotes[0].strumTime - Conductor.songPosition : "No note"));
		FlxG.watch.addQuick("Current HP", health);
		FlxG.watch.addQuick("Max HP", maxhealth);
		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'RIP')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Live Again')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (curSong == 'Stand By Me') //this is a good song so please listen to it
			{
				if (curStep == 1)
					{
						credGroup.visible = true;
						takoTweens.tween(credGroup, {y: -3450}, 228);
					}
				if (curStep == 1648)
					{
						if(!FlxG.save.data.inaHard)
							{
								textUnlock.alpha = 1;
							}
					}
					cannotDie = true;
			}

		if (health <= 0 && !cannotDie)
		{
			if (curStage == 'ES3' && hearts != 0) //fine ill make phantasm even easier
				{
					hearts -= 1;
					health = 1;
					maxhealth = 2;
					heartGroup.remove(heartGroup.getFirstAlive());
				}
			else
				{
					if (!usedTimeTravel) 
						{
							boyfriend.stunned = true;
			
							persistentUpdate = false;
							persistentDraw = false;
							paused = true;
			
							vocals.stop();
							FlxG.sound.music.stop();
			
							openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
							sectionStart = false;
			
							#if windows
							// Game Over doesn't get his own variable because it's only used here
							DiscordClient.changePresence("GAME OVER -- "
								+ SONG.song
								+ " ("
								+ storyDifficultyText
								+ ") "
								+ Ratings.GenerateLetterRank(accuracy),
								"\nAcc: "
								+ HelperFunctions.truncateFloat(accuracy, 2)
								+ "% | Score: "
								+ songScore
								+ " | Misses: "
								+ misses, iconRPC);
							#end
			
							// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
						}
						else
							health = 1;
				}
		}
		if (!inCutscene && FlxG.save.data.resetButton)
		{
			if (FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") "
					+ Ratings.GenerateLetterRank(accuracy),
					"\nAcc: "
					+ HelperFunctions.truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];

			notes.forEachAlive(function(daNote:Note)
			{
				// instead of doing stupid y > FlxG.height
				// we be men and actually calculate the time :)

				if (daNote.isParent && daNote.noteType == "sanity")
					{
						for (i in daNote.children)
							{
								i.noteType = 'sanity';
							}
					}
				
				if (daNote.isParent && daNote.noteType == "nightmare")
					{
						trace("bro sus nightmare notes are illegal here lol");
					}

				if (daNote.tooLate)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.modifiedByLua)
				{
					if (PlayStateChangeables.useDownscroll)
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
									2)) - daNote.noteYOff;
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
								+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
									2)) - daNote.noteYOff;
						if (daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height;
							else
								daNote.y += daNote.height / 2;

							// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
							if (!PlayStateChangeables.botPlay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
									&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
					else
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
									2)) + daNote.noteYOff;
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
									2)) + daNote.noteYOff;
						if (daNote.isSustainNote)
						{
							daNote.y -= daNote.height / 2;

							if (!PlayStateChangeables.botPlay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
									&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}
					
					// Accessing the animation name directly to play it
					var singData:Int = Std.int(Math.abs(daNote.noteData));
					dad.playAnim('sing' + dataSuffix[singData] + altAnim, true);

					switch(curSong.toLowerCase()) //sanity notes only work on these stages
					{
						case 'unravelling distortion' | 'radiant heaven' | 'our nonstop story' 
							| 'bordering final story' | 'inapurgation' | 'eldritch phantasm'
							| 'eidolic stained heart':
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
									{
										if (daNote.noteType == 'sanity')
											{
												switch(curSong.toLowerCase())
												{
													case 'inapurgation' | 'eidolic stained heart':
														maxhealth -= maxHPtoChange;
													case 'eldritch phantasm':
														maxhealth -= 0.006;
													default:
														maxhealth -= 0.012;
												}
											}
									}
							});
					}

					if (FlxG.save.data.cpuStrums)
					{
						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						});
					}

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
					#end

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.active = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (daNote.mustPress && !daNote.modifiedByLua)
				{
					daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
					if (daNote.sustainActive)
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
				}
				else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
				{
					daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
					if (daNote.sustainActive)
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
				}

				if (daNote.isSustainNote)
				{
					daNote.x += daNote.width / 2 + 20;
					if (PlayState.curStage.startsWith('school'))
						daNote.x -= 11;
				}

				// trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate
					&& PlayStateChangeables.useDownscroll)
					&& daNote.mustPress)
				{

					if (daNote.isParent && daNote.noteType == "sanity")
						{
							for (i in daNote.children)
								{
									i.noteType = 'sanity';
								}
						}

					if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							if (daNote.noteType == 'sanity'){
								trace("DICK");
								noteDoSomething(daNote);
							}
							daNote.kill();
							notes.remove(daNote, true);
						}
						else
						{
							if (loadRep && daNote.isSustainNote)
							{
								// im tired and lazy this sucks I know i'm dumb
								if (findByTime(daNote.strumTime) != null)
									totalNotesHit += 1;
								else
								{
									if (!daNote.isSustainNote)
										health -= 0.10;
									vocals.volume = 0;
									if (theFunne && !daNote.isSustainNote)
										noteMiss(daNote.noteData, daNote);
									if (daNote.isParent)
									{
										health -= 0.20; // give a health punishment for failing a LN
										trace("hold fell over at the start");
										for (i in daNote.children)
										{
												i.alpha = 0.3;
												i.sustainActive = false;
										}
									}
									else
									{
										if (!daNote.wasGoodHit
											&& daNote.isSustainNote
											&& daNote.sustainActive
											&& daNote.spotInLine != daNote.parent.children.length)
										{
											health -= 0.20; // give a health punishment for failing a LN
											trace("hold fell over at " + daNote.spotInLine);
											for (i in daNote.parent.children)
											{
												i.alpha = 0.3;
												i.sustainActive = false;
											}
											if (daNote.parent.wasGoodHit)
												misses++;
											updateAccuracy();
										}
									}
								}
							}
							else
							{
								if (!daNote.isSustainNote && daNote.noteType != "nightmare")
									{
										//trace("bitch");
										health -= 0.10;
										vocals.volume = 0;
									}
								if (theFunne && !daNote.isSustainNote && daNote.noteType != "nightmare")
									noteMiss(daNote.noteData, daNote);

								if (daNote.isParent)
								{
									//trace("fuck");
									health -= 0.20; // give a health punishment for failing a LN
									trace("hold fell over at the start");
									for (i in daNote.children)
									{
										i.alpha = 0.3;
										i.sustainActive = false;
										trace(i.alpha);
									}
								}
								else
								{
									if (!daNote.wasGoodHit
										&& daNote.isSustainNote
										&& daNote.sustainActive
										&& daNote.spotInLine != daNote.parent.children.length)
										{
										//trace(daNote.noteType);
										//health -= 0.20;
										trace("hold fell over at " + daNote.spotInLine);
										for (i in daNote.parent.children)
											{
												i.alpha = 0.3;
												i.sustainActive = false;
												trace(i.alpha);
											}
										if (daNote.parent.wasGoodHit)
											misses++;
										updateAccuracy();
										
									}
								}
							}
						}

						daNote.visible = false;
						daNote.kill();
						notes.remove(daNote, true);
					}
			});
		}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene && songStarted)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();

		if (FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future, credit: Shadow Mario#9396
			if (!usedTimeTravel && Conductor.songPosition + 10000 < FlxG.sound.music.length) 
			{
				usedTimeTravel = true;
				FlxG.sound.music.pause();
				vocals.pause();
				Conductor.songPosition += 10000;
				notes.forEachAlive(function(daNote:Note)
				{
					if(daNote.strumTime - 500 < Conductor.songPosition) {
						daNote.active = false;
						daNote.visible = false;

					
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				for (i in 0...unspawnNotes.length) {
					var daNote:Note = unspawnNotes[0];
					if(daNote.strumTime - 500 >= Conductor.songPosition) {
						break;
					}
					unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
				}

				FlxG.sound.music.time = Conductor.songPosition;
				FlxG.sound.music.play();

				vocals.time = Conductor.songPosition;
				vocals.play();
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						usedTimeTravel = false;
					});
			}
		}
		#end		
	}

	function endSong():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
		if (useVideo)
			{
				GlobalVideo.get().stop();
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				PlayState.instance.remove(PlayState.instance.videoSprite);
			}

		if (isStoryMode)
			campaignMisses = misses;

		if (!loadRep)
			rep.SaveReplay(saveNotes, saveJudge, replayAna);
		else
		{
			PlayStateChangeables.botPlay = false;
			PlayStateChangeables.scrollSpeed = 1;
			PlayStateChangeables.useDownscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast(Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore)
			{
				case 'Dad-Battle':
					songHighscore = 'Dadbattle';
				case 'Philly-Nice':
					songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
						sectionStart = false;
						transIn = FlxTransitionableState.defaultTransIn;
						transOut = FlxTransitionableState.defaultTransOut;

						fReturn = "story";
						if(PlayState.SONG.song == 'Bordering Final Story')
							{
								trace("you're going to credits instead");
								fReturn = "credits";
							}
							
						paused = true;
	
						FlxG.sound.music.stop();
						vocals.stop();
						if (usesEndDialogue) {
								trace(fReturn);
								endCutscene(doof2);
							} else {
								endReturn();
							}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					StoryMenuState.unlockNextWeek(storyWeek);
				}
				else
				{
					// adjusting the song name to be compatible
					var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
					switch (songFormat)
					{
						case 'Dad-Battle':
							songFormat = 'Dadbattle';
						case 'Philly-Nice':
							songFormat = 'Philly';
					}

					var poop:String = Highscore.formatSong(songFormat.toLowerCase(), storyDifficulty);

					trace('LOADING NEXT SONG');

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					fReturn = "play";
					endReturn();
				}
			}
			else
				{
				trace('WENT BACK TO FREEPLAY??');
				sectionStart = false;
				paused = true;

				FlxG.sound.music.stop();
				vocals.stop();

				if (FlxG.save.data.scoreScreen)
					{
						openSubState(new ResultsScreen());
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								inResults = true;
							});
					}
				else
					{
						switch(curSong)
						{
							case 'Inapurgation':
								trace('oh wow');
								FlxG.save.data.beatInapurgation = true;
							case 'Eldritch Phantasm':
								trace('wowowowowow');
								FlxG.save.data.beatEldritchPhantasm = true;
						}
						FlxG.switchState(new FreeplayState());
					}
			}
		}
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
		var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;
		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		coolText.y -= 350;
		coolText.cameras = [camHUD];
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Float = 350;

		//trace(totalNotesHit);
		
		if (FlxG.save.data.accuracyMod == 1)
			totalNotesHit += wife;

			var daRating = daNote.rating;

			switch (daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.06;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit -= 1;

				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.03;
					ss = false;
					bads++;
					noteDoSomething(daNote);
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
					
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health >= maxhealth)
						{
							health = maxhealth;
						}
					else
						{
						if (curSong.toLowerCase() == 'eidolic stained heart')
							{
								health += 0.01;
							}
						else
							{
								health += 0.02;
							}
						}
					noteDoSomething(daNote);
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health >= maxhealth)
						{
							health = maxhealth;
						}
					else
						if (curSong.toLowerCase() == 'eidolic stained heart')
							{
								health += 0.02;
							}
						else
							{
								health += 0.05;
							}
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
					noteDoSomething(daNote);
				
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
			var languageSet:String = '';
			if (FlxG.save.data.inaLanguage) {languageSet = 'jp/';}
			else {languageSet = 'en/';}

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + languageSet + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;

			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if (PlayStateChangeables.botPlay && !loadRep)
				msTiming = 0;

			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0, 0, 0, "0ms");
			timeShown = 0;
			switch (daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				// Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for (i in hits)
					total += i;

				offsetTest = HelperFunctions.truncateFloat(total / hits.length, 2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if (!PlayStateChangeables.botPlay || loadRep)
				add(currentTimingShown);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + languageSet + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if (!PlayStateChangeables.botPlay || loadRep)
				add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				if(FlxG.save.data.antialiasing)
					{
						rating.antialiasing = true;
					}
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				if(FlxG.save.data.antialiasing)
					{
						comboSpr.antialiasing = true;
					}
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];
			
			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					if(FlxG.save.data.antialiasing)
						{
							numScore.antialiasing = true;
						}
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
				if (curStage == 'ES2' || curSong == 'Stand By Me')
					{
						numScore.alpha = 0;
					}
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

	private function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
		#if windows
		if (luaModchart != null)
		{
			if (controls.LEFT_P)
			{
				luaModchart.executeState('keyPressed', ["left"]);
			};
			if (controls.DOWN_P)
			{
				luaModchart.executeState('keyPressed', ["down"]);
			};
			if (controls.UP_P)
			{
				luaModchart.executeState('keyPressed', ["up"]);
			};
			if (controls.RIGHT_P)
			{
				luaModchart.executeState('keyPressed', ["right"]);
			};
		};
		#end

		// Prevent player input if botplay is on
		if (PlayStateChangeables.botPlay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		}

		var anas:Array<Ana> = [null, null, null, null];

		for (i in 0...pressArray.length)
			if (pressArray[i])
				anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData] && daNote.sustainActive)
				{
					//trace(daNote.noteType);
					if (daNote.noteType == 'sanity') {
						//trace("DICK");
						noteDoSomething(daNote);
					}
					else
						{
							goodNoteHit(daNote);
						}

				}
			});
		}

		if ((KeyBinds.gamepad && !FlxG.keys.justPressed.ANY))
		{
			// PRESSES, check for note hits
			if (pressArray.contains(true) && generatedMusic)
			{
				boyfriend.holdTimer = 0;

				var possibleNotes:Array<Note> = []; // notes that can be hit
				var directionList:Array<Int> = []; // directions that can be hit
				var dumbNotes:Array<Note> = []; // notes to kill later
				var directionsAccounted:Array<Bool> = [false, false, false, false]; // we don't want to do judgments for more than one presses

				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
					{
						if (directionList.contains(daNote.noteData))
						{
							directionsAccounted[daNote.noteData] = true;
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
								{ // if it's the same note twice at < 10ms distance, just delete it
									// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
									dumbNotes.push(daNote);
									break;
								}
								else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
								{ // if daNote is earlier than existing note (coolNote), replace
									possibleNotes.remove(coolNote);
									possibleNotes.push(daNote);
									break;
								}
							}
						}
						else
						{
							directionsAccounted[daNote.noteData] = true;
							possibleNotes.push(daNote);
							directionList.push(daNote.noteData);
						}
					}
				});

				for (note in dumbNotes)
				{
					FlxG.log.add("killing dumb ass note at " + note.strumTime);
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}

				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				var hit = [false,false,false,false];

				if (perfectMode)
					goodNoteHit(possibleNotes[0]);
				else if (possibleNotes.length > 0)
				{
					if (!FlxG.save.data.ghost)
					{
						for (shit in 0...pressArray.length)
						{ // if a direction is hit that shouldn't be
							if (pressArray[shit] && !directionList.contains(shit))
								//trace("FUCK FUCK FUCK FUCK");
								noteMiss(shit, null);
						}
					}
					for (coolNote in possibleNotes)
					{
						if (pressArray[coolNote.noteData] && !hit[coolNote.noteData])
						{
							if (mashViolations != 0)
								mashViolations--;
							hit[coolNote.noteData] = true;
							scoreTxt.color = FlxColor.WHITE;
							var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
							anas[coolNote.noteData].hit = true;
							anas[coolNote.noteData].hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
							anas[coolNote.noteData].nearestNote = [coolNote.strumTime, coolNote.noteData, coolNote.sustainLength];
							goodNoteHit(coolNote);
						}
					}
				};
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && boyfriend.animation.curAnim.curFrame >= 10)
						boyfriend.playAnim('idle');
				}
				else if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
						if (pressArray[shit]) {
							trace("FUCK FUCK FUCK FUCK");
							noteMiss(shit, null);
						}

				}
			}

			if (!loadRep)
				for (i in anas)
					if (i != null)
						replayAna.anaArray.push(i); // put em all there
		}
		notes.forEachAlive(function(daNote:Note)
		{
			if (PlayStateChangeables.useDownscroll && daNote.y > strumLine.y || !PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
			{
				// Force good note hit regardless if it's too late to hit it or not as a fail safe
				if (PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress && daNote.noteType != 'nightmare' 
					|| PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress && daNote.noteType != 'nightmare' )
				{
					if(loadRep)
						{
							//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
							var n = findByTime(daNote.strumTime);
							trace(n);
							if(n != null)
							{
								playerStrums.forEach(function(spr:FlxSprite)
								{
									if (Math.abs(daNote.noteData) == spr.ID)
									{
										noteDoSomething(daNote);
										spr.animation.play('confirm', true);
									}
									if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
									{
										spr.centerOffsets();
										spr.offset.x -= 13;
										spr.offset.y -= 13;
									}
									else
										spr.centerOffsets();
								});
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}else {
							playerStrums.forEach(function(spr:FlxSprite)
								{
									if (Math.abs(daNote.noteData) == spr.ID)
									{
										noteDoSomething(daNote);
										spr.animation.play('confirm', true);
									}
									if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
									{
										spr.centerOffsets();
										spr.offset.x -= 13;
										spr.offset.y -= 13;
									}
									else
										spr.centerOffsets();
								});
							goodNoteHit(daNote);
							boyfriend.holdTimer = daNote.sustainLength;
						}
					}
				}
			});

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && boyfriend.animation.curAnim.curFrame >= 10)
				boyfriend.playAnim('idle');
		}

		if (!PlayStateChangeables.botPlay && !loadRep)
		{
			playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');

					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});		
		}
		else{
				playerStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.animation.finished)
						{
							spr.animation.play('static');
							spr.centerOffsets();
						}
					});
			}
		}

	public function findByTime(time:Float):Array<Dynamic>
	{
		for (i in rep.replay.songNotes)
		{
			// trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
			if (i[0] == time)
				return i;
		}
		return null;
	}

	public function findByTimeIndex(time:Float):Int
	{
		for (i in 0...rep.replay.songNotes.length)
		{
			// trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
			if (rep.replay.songNotes[i][0] == time)
				return i;
		}
		return -1;
	}

	public var fuckingVolume:Float = 1;
	public var useVideo = false;

	public static var webmHandler:WebmHandler;

	public var playingDathing = false;

	public var videoSprite:FlxSprite;

	public function focusOut()
	{
		if (paused)
			return;
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.pause();
			vocals.pause();
		}

		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	}

	public function focusIn()
	{
		// nada
	}

	public function backgroundVideo(source:String) // for background videos
	{
		#if cpp
		useVideo = true;

		FlxG.stage.window.onFocusOut.add(focusOut);
		FlxG.stage.window.onFocusIn.add(focusIn);

		var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
		WebmPlayer.SKIP_STEP_LIMIT = 90;
		var str1:String = "WEBM SHIT";
		webmHandler = new WebmHandler();
		webmHandler.source(ourSource);
		webmHandler.makePlayer();
		webmHandler.webm.name = str1;

		GlobalVideo.setWebm(webmHandler);

		GlobalVideo.get().source(source);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();

		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().restart();
		}
		else
		{
			GlobalVideo.get().play();
		}

		var data = webmHandler.webm.bitmapData;

		videoSprite = new FlxSprite(-470, -30).loadGraphic(data);

		videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));

		remove(gf);
		remove(boyfriend);
		remove(dad);
		add(videoSprite);
		add(gf);
		add(boyfriend);
		add(dad);

		trace('poggers');

		if (!songStarted)
			webmHandler.pause();
		else
			webmHandler.resume();
		#end
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned || daNote.noteType != 'normal')
		{
			if (daNote.noteType == 'sanity')
				{
					if (curStage == 'ES2' || curSong.toLowerCase() == 'eidolic stained heart')
						{
							trace('changing how sanity notes work');
							maxhealth -= maxHPtoChange;
						}
					else
						{
							maxhealth -= 0.012;
						}
				}
			//health -= 0.2;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			if (daNote != null)
			{
				if (!loadRep)
				{
					saveNotes.push([
						daNote.strumTime,
						0,
						direction,
						166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166
					]);
					saveJudge.push("miss");
				}
			}
			else if (!loadRep)
				{
					saveNotes.push([
						Conductor.songPosition,
						0,
						direction,
						166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166
					]);
					saveJudge.push("miss");
				}

			// var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			// var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			if (daNote != null)
			{
				if (!daNote.isSustainNote)
					songScore -= 10;
			}
			else
				songScore -= 10;
			
			if(FlxG.save.data.missSounds)
				{
					FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
					// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
					// FlxG.log.add('played imss note');
				}

			// Hole switch statement replaced with a single line :)
			boyfriend.playAnim('sing' + dataSuffix[direction] + 'miss', true);

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end

			updateAccuracy();
		}
	}

	/*function badNoteCheck()
			{
				// just double pasting this shit cuz fuk u
				// REDO THIS SYSTEM!
				var upP = controls.UP_P;
				var rightP = controls.RIGHT_P;
				var downP = controls.DOWN_P;
				var leftP = controls.LEFT_P;

				if (leftP)
					noteMiss(0);
				if (upP)
					noteMiss(2);
				if (rightP)
					noteMiss(3);
				if (downP)
					noteMiss(1);
				updateAccuracy();
			}
	 */

	function noteDoSomething(note:Note)
		{
			if(note.noteType == "sanity")
			{
				if (curStage == 'ES2')
					{
						if (maxhealth >= 2.0) {maxhealth = 2;}
						else {maxhealth += maxHPtoChange + 0.003;}
					}
				else
					{
						if (note.isSustainNote) {maxhealth += 0.01;}
						else {maxhealth += 0.05;}
						if (maxhealth >= 2.0) {maxhealth = 2;}
						//trace(maxhealth);	
					}
			}

			if(note.noteType == "nightmare")
			{
				trace('u ded');
				maxhealth = 0;
			}
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
		
	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = Math.max(0, totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			}*/
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false); */
			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{
				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

				if (loadRep)
				{
					noteDiff = findByTime(note.strumTime)[3];
					note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
				}
				else
					note.rating = Ratings.CalculateRating(noteDiff);

				if (note.rating == "miss")
					return;	

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						//trace(totalNotesHit);
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	
					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
					

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end

					if (!loadRep && note.mustPress)
						{
							var array = [note.strumTime, note.sustainLength, note.noteData, noteDiff];
							if (note.isSustainNote)
								array[1] = -1;
							saveNotes.push(array);
							saveJudge.push(note.rating);
						}
					
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(note.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
						});
				
						note.kill();
						notes.remove(note, true);
						note.destroy();
				
						updateAccuracy();
				}
			}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if (FlxG.save.data.distractions)
		{
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if (FlxG.save.data.distractions)
		{
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if (FlxG.save.data.distractions)
		{
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (FlxG.save.data.distractions)
		{
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
					camera.shake(0.002, 0.1, null, true, X);
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}
	}

	function trainReset():Void
	{
		if (FlxG.save.data.distractions)
		{
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	var stepOfLast = 0;

	var pause1:Bool = false;
	var pause2:Bool = false;
	var pause3:Bool = false;
	var pause4:Bool = false;
	var pause5:Bool = false;
	var pause6:Bool = false;
	
	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep', curStep);
			luaModchart.executeState('stepHit', [curStep]);
		}
		#end

		if (curSong == 'Radiant Heaven') 
			{
				switch(curStep)
				{
					case 928:
						FlxTween.tween(vignette, {alpha: 1}, 14, {ease: FlxEase.circOut});
					case 1088:
						FlxTween.tween(vignette, {alpha: 0}, 10, {ease: FlxEase.circOut});
				}
			}
		
		if (curSong == 'Our Nonstop Story')
			{
				switch(curStep)
				{
					case 1790:
						FlxTween.tween(olVoid, {alpha: 1}, 10, {ease:FlxEase.circOut});
					case 1872:
						FlxTween.tween(olVoidTentacles, {alpha: 1}, 10, {ease:FlxEase.circOut});
					case 2367:
						FlxTween.tween(olVoid, {alpha: 0}, 1, {ease:FlxEase.circOut});
						FlxTween.tween(olVoidTentacles, {alpha: 0}, 1, {ease:FlxEase.circOut});
				}
			}

		if (curSong == 'Bordering Final Story')
			{
				switch(curStep)
				{
					case 2688:
						FlxTween.tween(holoSign, {alpha: 1}, 0.5, {ease:FlxEase.circOut});
					case 2796:
						FlxTween.tween(holoSign, {alpha: 0}, 0.5, {ease:FlxEase.circOut});
					case 4780:
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
				}
			}

		if (curSong == 'Eldritch Phantasm')
			{
				switch(curStep)
				{
					case 5520:
						heartGroup.visible = false;
					case 5804:
						iconP2.changeIcon('inaKnightP2Ow');
						health = 1;
						maxhealth = 2;
					case 5808:
						heartGroup.visible = true;
					case 5936:
						FlxTween.tween(lastRemote, {alpha: 1}, 0.5, {ease:FlxEase.circOut});
					case 6048:
						FlxTween.tween(lastRemote, {alpha: 0}, 0.5, {ease:FlxEase.circOut});
					case 11056:
						iconP2.changeIcon('inapurgation');
					case 11408:
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
				}
			}

		if (curSong == 'Eidolic Stained Heart')
			{
				switch(curStep)
				{
					case 1: 
						trace("bye health");
						maxHPtoChange = 0.011;
				}
			}

		if (curSong == 'Inapurgation' && curStep != stepOfLast)
		{
			switch(curStep)
			{
				//208.91, 220.96, 235.81
				case 4:
					maxHPtoChange = 0.025;
				case 1158:
					doGremlin(40, 3);
				case 1414:
					doGremlin(40, 3);
				case 2054:
					doGremlin(40, 3);
				case 2694:
					doGremlin(40, 3);
				case 2950:
					doGremlin(40, 3);
				case 3718:
					doGremlin(40, 3);
				case 3974:
					doGremlin(40, 3);
				case 4196:
					maxHPtoChange = 0.012;
				case 4228:
					maxHPtoChange = 0.025;
				case 4486:
					doGremlin(40, 3);
				case 4742:
					doGremlin(40, 3);
				case 5062:
					doGremlin(40, 3);
				case 5254:
					doGremlin(20, 21);
			}
			stepOfLast = curStep;
		}

		if (curSong == 'Inapurgation') // tako signals
			{
				switch(curStep)
				{
					case 4: //in case replay is running, we put them back. idk if this works or not but oh well.
						takoSquad1   = false;
						takoSquad2   = false;
						//takoSquad3   = false;
						takoSquad4   = false;
						takoHPSquad1 = false;
						takoHPSquad2 = false;
					case 1158:
						takoSquad1   = true;
					case 2182:
						takoSquad2   = true;
						takoHPSquad1 = true;
					case 4198:
						//takoSquad3   = true;
						takoHPSquad2 = true;
					case 5252:
						//takoSquad3   = false;
						takoSquad4   = true;
				}
			}

		if (curSong == 'Inapurgation') //idk how timers work
			{
				new FlxTimer().start(10, function(tmr:FlxTimer) { //squad 1
					if (takoSquad1 && !pause1)
						{
							if (canPause && !paused)
								{
									//trace('tako squad 1 moving out');
									sendoutTako(1, 0);
									pause1 = true;
									tmr.reset(10);
									new FlxTimer().start(10, function(tmr:FlxTimer) {
										pause1 = false;
									});
								}
						}
				});

				new FlxTimer().start(10, function(tmr:FlxTimer) { //squad 2
					if (takoSquad2 && !pause2)
						{
							if (canPause && !paused)
								{
									//trace('tako squad 2 moving out');
									sendoutTako(2, 0);
									pause2 = true;
									tmr.reset(10);
									new FlxTimer().start(10, function(tmr:FlxTimer) {
										pause2 = false;
									});
								}
						}
				});

				/*new FlxTimer().start(5, function(tmr:FlxTimer) { //squad 3 -- TOO MANY TAKOS HERE
					if (takoSquad3 && !pause3)
						{
							if (canPause && !paused)
								{
									trace('tako squad 3 moving out');
									sendoutTako(0, 3);
									sendoutTako(1, 3);
									sendoutTako(1, 3);
									sendoutTako(2, 3);
									sendoutTako(2, 3);
									pause3 = true;
									tmr.reset(5);
									new FlxTimer().start(5, function(tmr:FlxTimer) {
										pause3 = false;
									});
								}
						}
				});*/

				new FlxTimer().start(10, function(tmr:FlxTimer) { //squad 4
					if (takoSquad4 && !pause4)
						{
							if (canPause && !paused)
								{
									//trace('tako squad 4 moving out');
									sendoutTako(1, 0);
									pause4 = true;
									tmr.reset(10);
									new FlxTimer().start(10, function(tmr:FlxTimer) {
										pause4 = false;
									});
								}
						}
				});

				new FlxTimer().start(10, function(tmr:FlxTimer) { //hp squad 1
					if (takoHPSquad1 && !pause5)
						{
							if (canPause && !paused)
								{
									//trace('tako hp squad 1 moving out');
									sendoutTako(0, 0);
									pause5 = true;
									tmr.reset(10);
									new FlxTimer().start(10, function(tmr:FlxTimer) {
										pause5 = false;
									});
								}
						}
				});

				/*new FlxTimer().start(5, function(tmr:FlxTimer) { // hp squad 2 -- TOO MANY TAKOS HERE
					if (takoHPSquad2 && !pause6)
						{
							if (canPause && !paused)
								{
									//trace('tako hp squad 2 moving out');
									sendoutTako(0, 0);
									pause6 = true;
									tmr.reset(5);
									new FlxTimer().start(5, function(tmr:FlxTimer) {
										pause6 = false;
									});
								}
						}
				});*/
			}
		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"Acc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			songLength
			- Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat', curBeat);
			luaModchart.executeState('beatHit', [curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf')
		{
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (curSong == 'Test' && dad.curCharacter == 'gf-aloe') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
				{
					Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
					FlxG.log.add('CHANGED BPM!');
				}
				// else
				// Conductor.changeBPM(SONG.bpm);
	
				// Dad doesnt interupt his own notes
				/*if ((SONG.notes[Math.floor(curStep / 16)].mustHitSection || !dad.animation.curAnim.name.startsWith("sing")) && dad.curCharacter != 'gf')
					if (curBeat % idleBeat == 0)
						dad.dance(idleToBeat);*/
			}
			// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
			wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MYTHBUSTER ZOOMS!
			if (curSong.toLowerCase() == 'mythbuster' && curBeat >= 112 && curBeat < 176 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}

			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}	

			// HARDCODING FOR POI ZOOMS!
			if (curSong.toLowerCase() == 'poi' && curBeat >= 127 && curBeat < 192 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}			

			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'gangimari' && curBeat >= 78 && curBeat < 145 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing") && curBeat % idleBeat == 0)
		{
			boyfriend.playAnim('idle');
		}

		if (!dad.animation.curAnim.name.startsWith("sing"))
		{
			dad.dance();
		}

		if (curBeat % 8 == 7 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 23 && curBeat < 87)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}	
		else if (curBeat == 90 && SONG.song == 'Tutorial')
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}	

		if (curSong == 'Live Again') // Hey and Cheer animations for Aloe and Nene
			{
				if (curBeat == 8){
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
					}
				if (curBeat == 16){
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
					}
				if (curBeat == 24){
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
					}
				if (curBeat == 32){
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
					}
				if (curBeat == 40){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 56){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 64){
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
					}
				if (curBeat == 72){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 88){
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
					}
				if (curBeat == 96){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 104){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 112){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 120){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 128){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 136){
						gf.playAnim('cheer', true);
					}
				if (curBeat == 144){
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
					}
			}

		if (dad.curCharacter == 'spooky' && SONG.song.toLowerCase() == 'sharkventure'){
			if (curBeat == 39){
					dad.playAnim('guraA', true);
				}
			if (curBeat == 55){
					dad.playAnim('ameHic', true);
				}
		}

		if (dad.curCharacter == 'spooky' && SONG.song.toLowerCase() == 'mythbuster'){
				if (curBeat == 216){
						dad.playAnim('ameHic', true);
					}
			}


		
		switch (curStage)
		{
			case 'school':
				if (FlxG.save.data.distractions)
				{
					bgGirls.dance();
				}

			case 'mall':
				if (FlxG.save.data.distractions)
				{
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if (FlxG.save.data.distractions)
				{
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if (FlxG.save.data.distractions)
				{
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
					}
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if (FlxG.save.data.distractions)
					{
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if (FlxG.save.data.distractions)
			{
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;

	public function endReturn() {
		switch(fReturn) {
			case "play":
				LoadingState.loadAndSwitchState(new PlayState());
			case "credits":
				trace('loading credits hopefully');

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				var songFormat = StringTools.replace("Stand By Me", " ", "-");
				var poop:String = Highscore.formatSong(songFormat.toLowerCase(), storyDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, "stand-by-me");
				FlxG.sound.music.stop();
				LoadingState.loadAndSwitchState(new PlayState());
			case "story":
				if (FlxG.save.data.scoreScreen)
					{
						openSubState(new ResultsScreen());
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								inResults = true;
							});
					}
				else
				{
					if(PlayState.SONG.song == 'Stand By Me')
						{
							trace('nice job bro');
							FlxG.save.data.inaHard = true;
						}
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					Conductor.changeBPM(102);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
					FlxG.switchState(new StoryMenuState());
				} 
			case "free":
				FlxG.switchState(new FreeplayState());
		}
	}
}
