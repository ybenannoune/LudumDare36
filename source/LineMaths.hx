package;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;

/**
 * ...
 * @author yben
 */
class LineMaths
{
	
	/** Return the point of intersection if lines segments intersect, otherwise null 
	 * 
	 * @ref : http://devmag.org.za/2009/04/17/basic-collision-detection-in-2d-part-2/
	 * @param	ps1 : Point Start Line 1
	 * @param	pe1 : Point End Line 1
	 * @param	ps2 : Point Start Line 2
	 * @param	pe2 : Point End Line 2
	 * @return  null if no intersection else the intersection point
	 */
	public static  function LineIntersectionPoint(ps1:FlxPoint , pe1:FlxPoint, ps2:FlxPoint, pe2:FlxPoint) : FlxPoint
	{		 			
		var denom:Float = ((pe2.y - ps2.y) * (pe1.x - ps1.x)) -
		((pe2.x - ps2.x) * (pe1.y - ps1.y));
	
		//lines are parallel?
		if (denom == 0)
			return null;
	
		/* The following lines are only necessary if we are checking line
		segments instead of infinite-length lines */	
		var ua:Float = (((pe2.x - ps2.x) * (ps1.y - ps2.y)) -
			((pe2.y - ps2.y) * (ps1.x - ps2.x))) / denom;		
		var ub:Float = (((pe1.x - ps1.x) * (ps1.y - ps2.y)) -
			((pe1.y - ps1.y) * (ps1.x - ps2.x))) / denom;	
			
		if( (ua < 0) || (ua > 1) || (ub < 0) || (ub > 1))
			 return null;
		 
		return new FlxPoint(ps1.x + (ua * (pe1.x -ps1.x)) , ps1.y + (ua * (pe1.y -ps1.y)));	
	}
	
	/**
	 * 
	 * @param	MirrorStart
	 * @param	MirrorEnd
	 * @param	RayEnd
	 * @param	IntersectPt
	 * @return
	 */
	public static function GetLineReflection(MirrorStart:FlxPoint , MirrorEnd:FlxPoint, RayEnd:FlxPoint, IntersectPt:FlxPoint) : FlxPoint
	{		
		var normalY:Float = MirrorEnd.x - MirrorStart.x;
		var normalX:Float = MirrorStart.y - MirrorEnd.y;
		
		var normalLength:Float = Math.sqrt(normalX * normalX + normalY * normalY);
		normalX = normalX / normalLength;
		normalY = normalY / normalLength;
		
		var rayX:Float  = RayEnd.x - IntersectPt.x;
		var rayY:Float  = RayEnd.y - IntersectPt.y;
		
		var dotProduct:Float = (rayX * normalX) + (rayY * normalY);
		var dotNormalX:Float = dotProduct * normalX;
		var dotNormalY:Float = dotProduct * normalY;
		
		return new FlxPoint(RayEnd.x - (dotNormalX * 2), RayEnd.y - (dotNormalY * 2));		
	}
	
	public static function intersectLineAndLine(ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float, dx:Float, dy:Float):Bool {
		var ta:Float = (cx - dx) * (ay - cy) + (cy - dy) * (cx - ax);
		var tb:Float = (cx - dx) * (by - cy) + (cy - dy) * (cx - bx);
		var tc:Float = (ax - bx) * (cy - ay) + (ay - by) * (ax - cx);
		var td:Float = (ax - bx) * (dy - ay) + (ay - by) * (ax - dx);

		return tc * td < 0 && ta * tb < 0;
	}
  
	public static function intersectLineAndRect(x1:Float, y1:Float, x2:Float, y2:Float, rect:FlxRect):Bool 
	{
		var left   = rect.left;
		var top    = rect.top;
		var right  = rect.right;
		var bottom = rect.bottom;

		if( intersectLineAndLine( left,  top,    right, top,    x1, y1, x2, y2 ) ) { return true; }
		if( intersectLineAndLine( right, top,    right, bottom, x1, y1, x2, y2 ) ) { return true; }
		if( intersectLineAndLine( right, bottom, left,  bottom, x1, y1, x2, y2 ) ) { return true; }
		if( intersectLineAndLine( left,  bottom, left,  top,    x1, y1, x2, y2 ) ) { return true; }

		return false;
	}
}