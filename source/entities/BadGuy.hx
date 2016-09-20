package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author yben
 */
class BadGuy extends FlxSprite
{
	private static inline var SPEED:Int = 30;
	
	var _path:Line;
	var _timeToTravel:Float;

	public function new() 
	{
		super();
		loadGraphic("assets/images/spritesheet-badguy.png", true, 58, 46);
		this.animation.add("walk", [0,0,1,1,1,1,0,0,2,2,2,2], 30, true);
		this.animation.add("attack", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 4, 4, 4], 30, true);	
		
		//Modify Hitbox
		width = 41;
		height = 35;
		centerOffsets();
	}
	
	public function InitLinePath(path:Line)
	{
		_path = path;
		
		this.animation.play("walk");
		
		this.x = path.start.x - width/2;
		this.y = path.start.y - height / 2;
		
		//Update Facing
		if ( path.getDeltaX() < 0)
		{
			this.flipX = true; //if moving from right to left, then scale -1 to rotate the picture			
		}
		else
		{
			this.flipX = false; //if moving from right to left, then scale -1 to rotate the picture
		}
		
		//angle of the line
		var angleRad:Float = MathUtils.convertToRadian(path.getAngle());
		
		//Velocity adapted to the angle, the badguy will walk along the line
		this.velocity.x = SPEED *  Math.cos(angleRad);
		this.velocity.y = SPEED *  Math.sin(angleRad);		
		
		//The estimed time to travel this line
		_timeToTravel = Math.max( path.getDeltaX() / velocity.x, path.getDeltaY() / velocity.y);
	}
	
	override public function update(elapsed:Float):Void
	{		
		if (_timeToTravel < 0.1 )
		{			
			this.velocity.x = 0;
			this.velocity.y = 0;	
			
			//When the movement is finish, start attacking
			this.animation.play("attack");		
			_timeToTravel = 0;
		}
		else if( _timeToTravel > 0)
		{
			_timeToTravel -= elapsed;
		}
		
		super.update(elapsed);
	}
	
}