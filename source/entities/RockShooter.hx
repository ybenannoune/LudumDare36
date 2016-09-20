package entities;

import entities.Rock;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.FlxInput;

/**
 * ...
 * @author yben
 */
class RockShooter extends FlxGroup
{
	private static inline var MAX_BULLETS:Int = 2;
	private static inline var MAX_CHARGE:Int = 5;
	private var _portal:FlxSprite;
	private var _firePoint:FlxPoint;
	private var _key:Int;
	private var _charge:Float;
	private var _impulseX:Float;
	private var _impulseY:Float;
	private var _accelX:Float;
	private var _accelY:Float;
	public var projectiles:FlxGroup;
		
	public function new(x:Int, y:Int, keyId:Int, impulseX:Float, impulseY:Float, accelX:Float, accelY: Float) 
	{		
		super();			
		
		_key = keyId;
		_impulseX = impulseX;
		_impulseY = impulseY;
		_accelX = accelX;
		_accelY = accelY;
		_firePoint = new FlxPoint(x, y);
		
		_portal = new FlxSprite();
		_portal.loadGraphic("assets/images/portal_spawn_rocks.png");
		_portal.setPosition(x - _portal.width / 2, y - _portal.height / 2);	
		_portal.scale.x = 0;
		_portal.scale.y = 0;
		if (_impulseX > 0)
			_portal.flipX = true;
		add(_portal);
		
		projectiles = new FlxGroup();
		var projectile:Rock;		
		// Create bullets for the player to recycle
		for (i in 0...MAX_BULLETS)			
		{
			// Instantiate a new sprite offscreen
			projectile = new Rock( -100, -100);		
			projectile.exists = false;
			projectile.maxVelocity.y = 1000;
			projectile.maxVelocity.x = 1000;	
			projectile.acceleration.x = accelX;
			projectile.acceleration.y = accelY;
			
			// Add it to the group of player bullets
			projectiles.add(projectile);			
		}			
		add(projectiles);
		_charge = 0;		
	}	

	override public function update(elapsed:Float):Void
	{					
		//JustPressed init charge
		if (FlxG.keys.checkStatus(_key, 2))
		{			
			_charge = 0;	
		}
		//IsPressed Inc Charge
		if (FlxG.keys.checkStatus(_key, 1))
		{
			if (_charge < MAX_CHARGE)
				_charge += 0.05;					
		}
		else
		{		
			if ( _charge > 0)
			{				
				_charge -= 0.05;				
			}			
		}		
	
		_portal.scale.x = (_charge) / MAX_CHARGE;
		_portal.scale.y = (_charge) / MAX_CHARGE;
			
		//IsRelease throw rock
		if (FlxG.keys.checkStatus(_key, -1))
		{			
			var projec:FlxBasic = projectiles.recycle();
			if ( projec != null)
			{
				var projectile:Rock = cast(projec, Rock);
				projectile.reset(_firePoint.x, _firePoint.y);				
				projectile.velocity.x = _charge * _impulseX;
				projectile.velocity.y = _impulseY;	
				projectile.acceleration.x = _accelX;
				projectile.acceleration.y = _accelY;	
			}		
		}		
		
		super.update(elapsed);
	}
	
}