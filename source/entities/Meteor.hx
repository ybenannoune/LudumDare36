package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;

/**
 * ...
 * @author yben
 */
class Meteor extends FlxSprite
{
	private static inline var CENTER_OFFSET_Y = 80; //Distance between the full sprite and the center of the meteor
	private static inline var WIDTH:Int = 60;
	private static inline var HEIGHT:Int = 50;
	private static inline var SPEED:Int = 100;
	
	private var offsetHitbox:FlxPoint;
	
	public function new() 
	{
		super();
						
		loadGraphic("assets/images/spritesheet-meteor.png", true,114,202);		
		animation.add("default", [0,0,1,1,2,2], 30, true);
		animation.play("default");		
		
		offsetHitbox = new FlxPoint(0, 80);
	}
			
	/*
	 * Rotate the picture, and calc the offset for the hitbox according to the angle
	 */	
	private function applyRotation(angle:Float):Void
	{
		this.angle = angle;
		var angleRad:Float = MathUtils.convertToRadian(angle);	
		//calc the center of the meteor not the full image
		offsetHitbox = MathUtils.rotatePoint(new FlxPoint(0,0),angle, new FlxPoint(1,CENTER_OFFSET_Y));			
	}
	
	public function setDestination(point:FlxPoint):Void
	{		
		var angle:Float = MathUtils.getAngle( this.getPosition(), point);
		applyRotation(angle - 90);//-90 for fix			
		
		var angleRad:Float = MathUtils.convertToRadian(angle);
		this.velocity.x = SPEED *  Math.cos(angleRad);
		this.velocity.y = SPEED *  Math.sin(angleRad);	
	}
	
	override public function update(elapsed:Float):Void
	{
		//if out of window kill
		if (y > FlxG.height)
		{			
			this.kill();
		}
			
		super.update(elapsed);
	}
	
	/*
	 *Fixed function to return the hitbox of the meteor not the full image, with rotation. 
	 */
	public function getMeteorHitbox():FlxRect
	{		
		var flPoint:FlxPoint = getMidpoint();	
		return new FlxRect(flPoint.x + offsetHitbox.x - WIDTH/2 ,flPoint.y + offsetHitbox.y - HEIGHT/2,WIDTH,HEIGHT);
	}
}