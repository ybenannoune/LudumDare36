package;
import flixel.math.FlxPoint;

/**
 * ...
 * @author yben
 */
class MathUtils
{

	/*
	 * Convert Degree to Radian	 
	 * 
	 */ 
	public static function convertToRadian(angle:Float):Float
	{
		return angle * (Math.PI / 180);	
	}
	
	/*
	 * Convert Radian to Degree	 
	 * 
	 */ 
	public static function convertToDegree(angle:Float):Float
	{
		return angle * (180 / Math.PI );
	}
	
	/*
	 * Return angle in Degree
	 */	
	public static function getAngle(pt1:FlxPoint, pt2:FlxPoint):Float
	{
		return convertToDegree(Math.atan2(pt2.y - pt1.y, pt2.x - pt1.x));				
	}
	
	/*
	 * Rotate a point around center, angle is in Degree
	 * 
	 */ 
	public static function rotatePoint(center:FlxPoint, angle:Float, point:FlxPoint):FlxPoint
	{		
		var angleRad:Float = convertToRadian(angle);
		
		var deltaX:Float = point.x - center.x;
		var deltaY:Float = point.y - center.y;		
		
		var ret:FlxPoint = new FlxPoint();
		ret.x = (Math.cos(angleRad) * deltaX  -  Math.sin(angleRad) * deltaY) + center.x;
		ret.y = (Math.cos(angleRad) * deltaY  +  Math.sin(angleRad) * deltaX) + center.y;	
		return ret;
	}
	
}