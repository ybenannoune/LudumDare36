package;
import flixel.math.FlxPoint;

/**
 * ...
 * @author yben
 */
class Line
{
	public var start:FlxPoint;
	public var end:FlxPoint;	

	public function new(_start:FlxPoint,_end:FlxPoint) 
	{
		start = _start;
		end = _end;
	}
	
	/**
	 * Get the lenght of the line
	 * @return the lenght of the Line
	 */
	public function getLength():Float
	{				
		var deltaY:Float = getDeltaY();
		var deltaX:Float = getDeltaX();
		return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
	}
	
	/**
	 * Return the Delta on X axis
	 * @return the difference between end & start on the X axis
	 */
	public function getDeltaX():Float
	{
		return end.x - start.x;
	}
	
	/**
	 * Return the Delta on Y axis
	 * @return the difference between end & start on the Y axis
	 */
	public function getDeltaY():Float
	{
		return end.y - start.y;
	}
	
	/**
	 * 
	 * @return angle of the line in degree
	 */
	public function getAngle():Float
	{
		return MathUtils.convertToDegree(Math.atan2(end.y - start.y, end.x - start.x));		
	}
	
}