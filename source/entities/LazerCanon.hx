package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import lime.math.Vector2;

/**
 * ...
 * @author yben
 */
class LazerCanon extends FlxSprite
{		
	private static inline var RAY_SIZE:Float = 1000;		
	private static inline var OFFSET_ANGLE:Float = 1.570797; //90 degree		
	private static inline var MIN_ANGLE:Float = -45;
	private static inline var MAX_ANGLE:Float = 45;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{		
		//Initialize sprite object
		super(X, Y);
			
		//Load canon assets
		loadGraphic("assets/images/canon.png");				
	}
	
	/* 
	 * Convert current angle degree to radians
	 */
	public function getAngleRad() : Float
	{
		return (this.angle * 0.0174533); //degree * 0,0174533 to convert in radian
	}
		
	/*
	 *	Get the Point at the end of the canon, relative to the current angle 
	 */
	public function getCanonSight() : FlxPoint
	{ 
		var angle:Float = getAngleRad() + OFFSET_ANGLE;		  
		var endX = RAY_SIZE * Math.cos(angle) + x + width / 2;
		var endY = RAY_SIZE * Math.sin(angle) + y + height / 2;	
		return new FlxPoint(endX, endY);
	}		
	
	/**
	 * Update canon angle according to mouse position
	 */
	override public function update(elapsed:Float):Void
	{	
		var mousePos:FlxPoint = FlxG.mouse.getScreenPosition();
		
		this.angle = Math.atan2(mousePos.y - FlxG.height / 2, mousePos.x - FlxG.width / 2) *  (180 / Math.PI) - 90;	
		//Clamp Angle
		angle = Math.min(angle, MAX_ANGLE);
		angle = Math.max(angle, MIN_ANGLE );
		super.update(elapsed);
	}
}