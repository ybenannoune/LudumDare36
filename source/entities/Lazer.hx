package entities;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import openfl.filters.GlowFilter;

/**
 * ...
 * @author yben
 */
class Lazer extends FlxSprite
{
	private static inline var ALPHA_VARIATION:Float = 0.09;
	private var _lifeTime:Float;
	private var _increaseAlpha:Bool;	
	
	public function new() 
	{
		super();
		this.exists = false; // don't display actually	
		
		loadGraphic("assets/images/laser-pattern.png");		
	}
	
	public function drawLazer(line:Line, lifeTime:Float):Void
	{
		_lifeTime = lifeTime;
		
		this.exists = true;
		this.x = line.start.x;
		this.y = line.start.y;		
		
		this.angle = MathUtils.getAngle(line.start, line.end) + 90;
		this.scale.y = line.getLength() / graphic.bitmap.height;
		
		//Fixing scaling
		this.x += line.getDeltaX() / 2 - width/2;
		this.y += line.getDeltaY() / 2;		
	}
	
	override public function update(elapsed:Float):Void
	{		
		_lifeTime -= elapsed;
		if (_lifeTime < 0)
		{
			this.exists = false;
		}
		
		//Alpha Variable		
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