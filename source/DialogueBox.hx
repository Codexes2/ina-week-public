package;

import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.media.Sound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	static inline final GF_DEFAULT = 'gf default';

	var box:FlxSprite;
	var skipText:FlxText;
	var curCharacter:String = '';

	var curAnim:String = '';
	var prevChar:String = '';

	var effectQue:Array<String> = [""];
	var effectParamQue:Array<String> = [""];

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???/
	var swagDialogue:FlxTypeText;
	var dropText:FlxText;
	var cutsceneDialogue:FlxTypeText;
	//Cutscene shit, HAS TO LOAD ON EVERY STAGE IDIOT
	var cutsceneImage:FlxSprite;
	var sound:FlxSound;

	public var finishThing:Void->Void;

	var portraitBF:Portrait;
	var portraitGF:Portrait;
	var portraitINA:Portrait;
	var portraitNOCHAR:Portrait;
	var portraitBGFADES:Portrait;

	//var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var blackBG:FlxSprite;
	var brightLight:FlxSprite;

	var canAdvance = false;

	public var language:Bool = false;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
					canAdvance = true;
			});



		blackBG = new FlxSprite(-256, -256).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		add(blackBG);
	
		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		cutsceneImage = new FlxSprite(0, 0);
		cutsceneImage.visible = false;
		add(cutsceneImage);	

		//if (PlayState.SONG.song.toLowerCase() == 'tutorial')
		//bgFade.visible = false;

		FlxTween.tween(bgFade, {alpha: 0.7}, 1, {ease: FlxEase.circOut});

		box = new FlxSprite(-20, 45);
		//REPOSITIONING, NEW ANIMATIONS AND MUSIC SHIT IDIOTS
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.y += 345;
				box.x += 60;
				box.flipX = true;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		//portrait positions are HERE

		portraitBF = new Portrait(100, 155, "bf");
		add(portraitBF);

		portraitGF = new Portrait (170, 140, "gf");
		add(portraitGF);

		portraitINA = new Portrait(15, 85, "ina");
		add(portraitINA);

		portraitNOCHAR = new Portrait(0, 9999, "bf");
		add(portraitNOCHAR);

		portraitBGFADES = new Portrait(0, 0, "bgFades");
		add(portraitBGFADES);

		switch PlayState.SONG.song.toLowerCase(){
			default:
				box.animation.play('normalOpen');
				box.setGraphicSize(Std.int(box.width * 0.9));
				box.updateHitbox();
				add(box);
		}
	
		box.screenCenter(X);


		/*handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect); */

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		switch(FlxG.save.data.inaLanguage)
		{
			case 'ENGLISH':              language = false;
			case 'JAPANESE' | 'SPANISH': language = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);
		skipText = new FlxText(5, 695, 640, "Press SPACE to skip the dialogue.\n", 40);
		skipText.scrollFactor.set(0, 0);
		skipText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		skipText.borderSize = 2;
		skipText.borderQuality = 1;
		add(skipText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		if (language)
			{
				swagDialogue.size = 40;
				swagDialogue.font = Paths.font("rhp.ttf");
			}
		else
			{
				swagDialogue.font = 'Pixel Arial 11 Bold';
			}
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.finishSounds = true;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		cutsceneDialogue = new FlxTypeText (240, 600, Std.int(FlxG.width * 0.6), "", 36);
		if (language)
			{
				cutsceneDialogue.size = 40;
				cutsceneDialogue.font = Paths.font("rhp.ttf");
			}
		else
			{
				cutsceneDialogue.font = 'Bubblegum Sans';
			}
		cutsceneDialogue.color = 0xffffff;
		cutsceneDialogue.borderStyle = OUTLINE;
		cutsceneDialogue.borderSize = 2.0;
		add(cutsceneDialogue);

		brightLight = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
		brightLight.alpha = 0.0;
		add(brightLight);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{	
		if (!language)
			{
				dropText.text = swagDialogue.text;
				cutsceneDialogue.text = swagDialogue.text;
			}

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(FlxG.keys.justPressed.SPACE && !isEnding){

			isEnding = true;
			endDialogue();

		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true && canAdvance && !isEnding)
		{
			remove(dialogue);
			canAdvance = false;

			new FlxTimer().start(0.15, function(tmr:FlxTimer)
			{
				canAdvance = true;
			});

			FlxG.sound.play(Paths.sound('clickText'), 0.5);

			if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						endDialogue();
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
				}
			}
	
			super.update(elapsed);
		}
	
		var isEnding:Bool = false;
	
		function endDialogue(){
	
			if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
				FlxG.sound.music.fadeOut(2.2, 0);

				hideAll();
				if (this.sound != null) this.sound.stop();
					FlxTween.tween(box, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
					FlxTween.tween(bgFade, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
					FlxTween.tween(cutsceneImage, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
					FlxTween.tween(swagDialogue, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
					FlxTween.tween(cutsceneDialogue, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
					FlxTween.tween(blackBG, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
					FlxTween.tween(dropText, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
					if (PlayState.isRadience) {
						FlxTween.tween(brightLight, {alpha: 1}, 0.6, {ease: FlxEase.circOut});
					}
					FlxTween.tween(skipText, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
					FlxG.sound.music.fadeOut(1.2, 0);

					
					new FlxTimer().start(1.2, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
							FlxG.sound.music.stop();
						});
				
					}
				
					
	function startDialogue():Void
	{

		var setDialogue = false;
		var skipDialogue = false;
		cleanDialog();
		hideAll();

		box.visible = true;
		box.flipX = true;
		swagDialogue.visible = true;
		dropText.visible = true;
		cutsceneDialogue.visible = false;

		switch (curCharacter)
		{
			case "bf":
				portraitBF.playFrame(curAnim);
				changeSound('boyfriendText',0.6);
			case "gf":
				portraitGF.playFrame(curAnim);
				changeSound('gfText',0.6);
			case "ina":
				portraitINA.playFrame(curAnim);
				changeSound('inaText',0.9);
			case "noChar":
				box.visible = false;
				swagDialogue.visible = false;
				dropText.visible = false;
				cutsceneDialogue.visible = true;
				portraitNOCHAR.playFrame("default");
				switch(curAnim)
				{
					case 'bf':
						changeSound('gfText',0.6);
					case 'gf':
						changeSound('gfText',0.6);
					case 'ina':
						changeSound('inaText',1.0);
					case 'inaKnight':
						changeSound('inaKnightText',0.9);
					default:
						changeSound('gfText',0.0);
				}

			case "bgFades":
				box.visible = false;
				swagDialogue.visible = false;
				dropText.visible = false;
				cutsceneDialogue.visible = false;
				portraitBGFADES.playFrame(curAnim);
				new FlxTimer().start(1, function(tmr:FlxTimer) 
					{
						trace('gtfo bg fade');
						dialogueList.remove(dialogueList[0]);
						startDialogue();
					});

			case "effect":
				switch(curAnim){
					case "hidden":
						swagDialogue.visible = false;
						dropText.visible = false;
						box.visible = false;
						setDialogue = true;
						swagDialogue.resetText("");
					default:
						effectQue.push(curAnim);
						effectParamQue.push(dialogueList[0]);
						skipDialogue = true;
				}
			case "bg":
				skipDialogue = true;
				switch(curAnim){
					case "hide":
						cutsceneImage.visible = false;
					default:
						cutsceneImage.visible = true;
						cutsceneImage.loadGraphic(BitmapData.fromFile("assets/dialogue/images/bg/" + curAnim + ".png"));
						if (curAnim == 'darkness' && PlayState.SONG.song.toLowerCase() != "bordering final story")
							{
								new FlxTimer().start(3, function(tmr:FlxTimer) 
									{
										trace('gtfo dark bg');
										dialogueList.remove(dialogueList[0]);
										startDialogue();
									});
							}
				}
			case "sound":
				skipDialogue = true;
				if (this.sound != null) this.sound.stop();
				sound = new FlxSound().loadEmbedded(Sound.fromFile("assets/dialogue/sounds/" + curAnim + ".ogg"));
				sound.play();
			case "music":
				skipDialogue = true;
				switch(curAnim){
					case "stop":
						FlxG.sound.music.stop();
					case "fadeIn":
						FlxG.sound.music.fadeIn(1.5, 0, Std.parseFloat(dialogueList[0]));
					case "fadeOut":
						FlxG.sound.music.fadeOut(1.5, 0);
					default:
						FlxG.sound.playMusic(Sound.fromFile("assets/dialogue/music/" + curAnim + ".ogg"), Std.parseFloat(dialogueList[0]));
				}
			
			default:
				trace("default dialogue event");
				portraitBF.playFrame();
		}

		prevChar = curCharacter;

		if(!skipDialogue){
			if(!setDialogue){
				swagDialogue.resetText(dialogueList[0]);
				cutsceneDialogue.resetText(dialogueList[0]);
			}

			swagDialogue.start(0.04, true);
			cutsceneDialogue.start(0.04, true);
			runEffectsQue();
		}
		else{

			dialogueList.remove(dialogueList[0]);
			startDialogue();
		
		}

	}
			
	function cleanDialog():Void
	{
		while(dialogueList[0] == ""){
			dialogueList.remove(dialogueList[0]);
		}

		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curAnim = splitName[2];
	
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length  + 3).trim();
		
		
	}

	function runEffectsQue(){
	
		for(i in 0...effectQue.length){

			switch(effectQue[i]){

				case "fadeOut":
					effectFadeOut(Std.parseFloat(effectParamQue[i]));
				case "fadeIn":
					effectFadeIn(Std.parseFloat(effectParamQue[i]));
				case "exitStageLeft":
					effectExitStageLeft(Std.parseFloat(effectParamQue[i]));
				case "exitStageRight":
					effectExitStageRight(Std.parseFloat(effectParamQue[i]));
				case "enterStageLeft":
					effectEnterStageLeft(Std.parseFloat(effectParamQue[i]));
				case "enterStageRight":
					effectEnterStageRight(Std.parseFloat(effectParamQue[i]));
				case "rightSide":
					effectFlipRight();
				case "flip":
					effectFlipDirection();
				case "toLeft":
					effectToLeft();
				case "toRight":
					effectToRight();
				//case "shake":
					//effectShake(Std.parseFloat(effectParamQue[i]));
				default:

			}

		}

		effectQue = [""];
		effectParamQue = [""];

	}

	function changeSound(sound:String, volume:Float){
	swagDialogue.sounds = [FlxG.sound.load(Paths.sound(sound, 'dialogue'), volume)];
	
	}

	function portraitArray(){

		var portraitArray = [portraitBF,portraitGF,portraitINA, portraitBGFADES];
		return portraitArray;

	}
	

	function hideAll():Void{
		
		for(i in 0...portraitArray().length){
		portraitArray()[i].hide();
		}
	}

	function effectFadeOut(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFadeOut(time);
		}
	}

	function effectFadeIn(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFadeIn(time);
		}
	}

	function effectExitStageLeft(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectExitStageLeft(time);
			}
	}

	function effectExitStageRight(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectExitStageRight(time);
			}
	}

	function effectFlipRight(){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectFlipRight();
			}
			box.flipX = false;
		
	}
	
	function effectFlipDirection(){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectFlipDirection();
			}
		
	}

	function effectEnterStageLeft(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectEnterStageLeft(time);
			}
		
	}

	function effectEnterStageRight(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectEnterStageRight(time);
			}
	
	}

	function effectToRight(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectToRight(time);
			}
		
		box.flipX = false;
	}

	function effectToLeft(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectToLeft(time);
			}
		
	}	
}
