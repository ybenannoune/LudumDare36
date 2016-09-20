package entities;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import openfl.filters.GlowFilter;

/**
 * ...
 * @author yben
 */
class LazerImpact extends FlxSprite
{
	private static inline var ALPHA_VARIATION:Float = 0.09;
	private var _lifeTime:Float;
	private var _increaseAlpha:Bool;	
	
	public function new() 
	{
		super();
		this.exists = false; // don't display actually	
		
		loadGraphic("assets/images/laser-impact.png");		
	}
	
	public function drawImpact(point:FlxPoint, lifeTime:Float):Void
	{
		_lifeTime = lifeTime;		
		this.exists = true;
		this.x = point.x - width/2;
		this.y = point.y - height/2;			
	}
		
	override public function update(elapsed:Float):Void
	{		
		_lifeTime -= elapsed;
		if (_lifeTime < 0)
		{
			this.exists = false;
		}
		
		//Make Alpha Variable		
		if (_increaseAlpha)
		{
			this.alpha += ALPHA_VARIATION;
		}		
		else
		{
			this.alpha -= ALPHA_VARIATION;
		}
		
		if (this.alpha < 0.5)
		{			
			_increaseAlpha = true;		
		}
		if (this.alpha > 0.95)
		{
			_increaseAlpha = false;
		}
			
		super.update(elapsed);
	}
}