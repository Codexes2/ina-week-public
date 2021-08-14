package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Portrait extends FlxSprite
{

    private var refx:Float;
    private var refy:Float;

    private var resize = 0.35;

    private var characters:Array<String> = ["bf", "gf", "bgFades", "ina", "noChar"];

    var posTween:FlxTween;
    var alphaTween:FlxTween;
	
    public function new(_x:Float, _y:Float, _character:String){

        super(_x, _y);

        defineCharacter(_character);
        setGraphicSize(Std.int(width * resize));
        updateHitbox();
        scrollFactor.set();
        antialiasing = true;

        refx = x;
        refy = y + height;

        playFrame();
        posTween = FlxTween.tween(this, {x: x}, 0.1);
        alphaTween = FlxTween.tween(this, {alpha: alpha}, 0.1);
        hide();

    }

    function defineCharacter(_character){

        _character = characters.contains(_character) ? _character : "aloe";

        frames = Paths.getSparrowAtlas("portrait/" + _character, "dialogue");

        switch(_character){

            case "noChar":
                addAnim("default", "noChar instance 1");
            case "bf":
                addAnim("default", "bfConfident");
                addAnim("fear", "bfAfraidIdle");
                addAnim("scared", "bfScaredIdle");
                animation.play("default");
                resize = 0.9;
            case "gf":
                addAnim("default", "GF Dancing Beat");
                addAnim("happy", "GF Cheer");
                addAnim("fear", "GF FEAR");
                addAnim("sad", "gf sad");
                animation.play("default");
                resize = 0.9;
            case "ina":
                addAnim("default", "Ina_Neutral.png");
                addAnim("defeatedSad", "Ina_Defeated_Sad.png");
                addAnim("defeatedSerious", "Ina_Defeated_Serious.png");
                addAnim("defeatedSmile", "Ina_Defeated_Smile.png");
                addAnim("happy", "Ina_Happy.png");
                addAnim("insane", "Ina_Insane.png");
                addAnim("smile", "Ina_Smile.png");
                addAnim("winkFrown", "Ina_Wink_Frown.png");
                addAnim("winkSmile", "Ina_Wink_Smile.png");
                animation.play("default");
                resize = 0.7;
            case "bgFades":
                addAnim("default", "darkness");
                addAnim("cimage1", "cimage1.png");
                addAnim("cimage2", "cimage2.png");
                addAnim("cimage3", "cimage3.png");
                addAnim("cimage4", "cimage4.png");
                addAnim("stage1", "stage1.png");
                addAnim("stage2", "stage2.png");
                addAnim("stage3", "stage3.png");
                addAnim("darkness", "darkness.png");
                addAnim("light", "light.png");
                animation.play("default");
                resize = 1.0;

        }

    }
    
    function addAnim(anim:String, prefix:String){
        animation.addByPrefix(anim,prefix, 0, false);
    }    

    public function playFrame(?_frame:String = ""){

        visible = true;

        animation.play(_frame);
        flipX = false;
        updateHitbox();

        x = refx;
        y = refy - height;

    }

    public function hide(){

        alphaTween.cancel();
        posTween.cancel();
        alpha = 1;
        visible = false;

    }

    public function effectFadeOut(?time:Float = 1){

        alphaTween.cancel();
        alpha = 1;
        alphaTween = FlxTween.tween(this, {alpha: 0}, time);

    }

    public function effectFadeIn(?time:Float = 1){

        alphaTween.cancel();
        alpha = 0;
        alphaTween = FlxTween.tween(this, {alpha: 1}, time);

    }

    public function effectExitStageLeft(?time:Float = 1){

        posTween.cancel();
        posTween = FlxTween.tween(this, {x: 0 - width}, time, {ease: FlxEase.circIn});

    }

    public function effectExitStageRight(?time:Float = 1){

        posTween.cancel();
        posTween = FlxTween.tween(this, {x: FlxG.width}, time, {ease: FlxEase.circIn});

    }

    public function effectFlipRight(){

        x = FlxG.width - refx - width;
        y = refy - height;

    }

    public function effectFlipDirection(){
        
        flipX = true;

    }

    public function effectEnterStageLeft(?time:Float = 1){
        
        posTween.cancel();
        var finalX = x;
        x = 0 - width;
        posTween = FlxTween.tween(this, {x: finalX}, time, {ease: FlxEase.circOut});

    }

    public function effectEnterStageRight(?time:Float = 1){
        
        posTween.cancel();
        var finalX = x;
        x = FlxG.width;
        posTween = FlxTween.tween(this, {x: finalX}, time, {ease: FlxEase.circOut});
    }

    public function effectToRight(?time:Float = 1){
        
        posTween.cancel();
        var finalX = FlxG.width - refx - width;
        x = refx;
        y = refy - height;
        posTween = FlxTween.tween(this, {x: finalX}, time, {ease: FlxEase.quintOut});
    }

    public function effectToLeft(?time:Float = 1){
        
        posTween.cancel();
        var finalX = refx;
        x = FlxG.width - refx - width;
        y = refy - height;
        posTween = FlxTween.tween(this, {x: finalX}, time, {ease: FlxEase.quintOut});
    }

   
}
