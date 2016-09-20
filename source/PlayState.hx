package;

import entities.Rock;
import entities.BadGuy;
import entities.LazerCanon;
import entities.EnergyJauge;
import entities.Lazer;
import entities.LazerImpact;
import entities.Meteor;
import entities.MeteorExplosion;
import entities.RockShooter;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import openfl.display.BlendMode;

class PlayState extends FlxState
{		
	//Constants
	private static inline var SHOOT_DELAY:Float = 1; 		//Canon shoot each seconds
	private static inline var SPAWN_METEOR_DELAY:Float = 3; //Time before spawn of a meteor
	private static inline var SPAWN_BADGUY_DELAY:Float = 5; //Time before a spawn
	private static inline var ENERGY_UPDATE_DELAY:Float = 1;
		
	private static inline var MAX_METEORS:Int = 8;
	private static inline var MAX_BADGUYS:Int = 5;
	
	private static inline var ENERGY_GAIN:Float = 0.025;
	private static inline var ENERGY_LOSS:Float = -0.0888888888888889;
	
	private static inline var GAME_OVER_TIME:Float = 90; 	 // If we didn't succeded to protect the island, we lose after 120 seconds.
	private static inline var SCALE_WAVE_END:Float = 2;
	
	private var _gameEnded:Bool = false;
		
	//Scene	
	private var _sceneLayer1:FlxSprite;
	private var _sceneLayer2:FlxSprite;
	private var _sceneProtectDome:FlxSprite;
	private var _blueCrystal:FlxSprite;	
	private var _sceneWave:FlxSprite;
	
	private var _ui_win:FlxSprite;
	private var _ui_lose:FlxSprite;

	//Mirrors Objects
	private var _mirrorCenter:Line;

	//Canon
	private var _canon:LazerCanon;	
	private var _lazerReflect:Lazer;
	private var _lazerShoot:Lazer;
	private var _lazerImpact:LazerImpact;
	private var _shooterLeft:RockShooter;
	private var _shooterRight:RockShooter;
	
	//Timers
	private var _timeBeforeNextShoot:Float;
	private var _timeBeforeSpawnMeteor:Float;
	private var _timeBeforeLost:Float;
	private var _timeBeforeSpawnBadGuy:Float;
	private var _timeBeforeEnergyUpdate:Float;
	
	//GroupsEntity
	private var _meteorsExplode:FlxGroup;
	private var _meteors:FlxGroup;	
	private var _badGuys:FlxGroup;	
	private var _energyJauges:FlxGroup;
	
	//Sounds
	private var sndExplode:FlxSound;
	private var sndLaser:FlxSound;	
	
	//Hitboxs
	private var _hitboxWorlds:FlxGroup;	
	
	//The Order is important
	private function buildScene():Void
	{		
		_sceneLayer1 = new FlxSprite();
		_sceneLayer1.loadGraphic("assets/images/scene_layer1.png");	
		add(_sceneLayer1);	
		
		_sceneWave = new FlxSprite();
		_sceneWave.loadGraphic("assets/images/wave-spritesheet.png", true, 1280, 544 );
		_sceneWave.setPosition(0, 418 - _sceneWave.height / 2 );
		_sceneWave.animation.add("default", [0, 0, 1, 1, 2, 2, 3, 3], 10, true);
		_sceneWave.animation.play("default");
		add(_sceneWave);
		
		_sceneLayer2 = new FlxSprite();
		_sceneLayer2.loadGraphic("assets/images/scene_layer2.png");	
		add(_sceneLayer2);	
		
		_lazerShoot = new Lazer();
		add(_lazerShoot);
		_lazerReflect = new Lazer();
		add(_lazerReflect);			
		_lazerImpact = new LazerImpact();
		add(_lazerImpact);
		
		//add canon to the scene
		_canon = new LazerCanon(637, 290);		
		add(_canon);
		
		_blueCrystal = new FlxSprite(522,62);
		_blueCrystal.loadGraphic("assets/images/crystal-spritesheet.png", true, 240, 260);
		_blueCrystal.animation.add("default", [0,0,1,1,2,2,3,3,4,4,5,5,5,5,4,4,3,3,2,2,1,1,0,0,6,6,7,7,8,8,9,9,10,10,11,11,11,11,10,10,9,9,8,8,7,7,6,6],24,true);
		_blueCrystal.animation.play("default");
		add(_blueCrystal);
	}
	
	private function initGroups():Void
	{
		var _meteor:Meteor;
		_meteors = new FlxGroup(MAX_METEORS);
		for (i in 0...MAX_METEORS)			
		{			
			_meteor = new Meteor();	
			_meteor.exists = false;
			// Add it to the group
			_meteors.add(_meteor);			
		}
		add(_meteors);
		
		var _explode:MeteorExplosion;
		_meteorsExplode = new FlxGroup(MAX_METEORS);
		for (i in 0...MAX_METEORS)			
		{				
			_explode = new MeteorExplosion();		
			_explode.exists = false;
			// Add it to the group
			_meteorsExplode.add(_explode);			
		}	
		add(_meteorsExplode);	
		
		var _badGuy:BadGuy; 	
		_badGuys = new FlxGroup();
		for (i in 0...MAX_BADGUYS)			
		{				
			_badGuy = new BadGuy();		
			_badGuy.exists = false;
			
			// Add it to the group
			_badGuys.add(_badGuy);			
		}	
		add(_badGuys);		
	}
	
	private function initTimers():Void
	{
		_timeBeforeSpawnBadGuy = SPAWN_BADGUY_DELAY;
		_timeBeforeSpawnMeteor = SPAWN_METEOR_DELAY;	
		
		_timeBeforeNextShoot = SHOOT_DELAY;			
		_timeBeforeLost = GAME_OVER_TIME;		
		
		_timeBeforeEnergyUpdate = ENERGY_UPDATE_DELAY;
	}
	
	private function addEnergyJauge():Void
	{
		_energyJauges = new FlxGroup(2);
		_energyJauges.add(new EnergyJauge(500, 409));
		_energyJauges.add(new EnergyJauge(762, 409));
		add(_energyJauges);
	}
	
	private function addEnergy(value:Float):Void
	{
		cast(_energyJauges.members[0], EnergyJauge).addEnergy(value);
		cast(_energyJauges.members[1], EnergyJauge).addEnergy(value);
	}
	
	private function loadSounds():Void
	{
		sndExplode = FlxG.sound.load(AssetPaths.Explosion__ogg,0.3);
		sndLaser = FlxG.sound.load(AssetPaths.LaserShoot__ogg, 0.05);
				
		FlxG.sound.playMusic(AssetPaths.Danger__ogg, 0.8);
	}
	
	private function levelHitBox():Void
	{		
		var hitbox:FlxSprite;
		_hitboxWorlds = new FlxGroup(2);
		
		//1st floor
		hitbox = new FlxSprite( 400, 460);		
		hitbox.makeGraphic(480, 10, FlxColor.TRANSPARENT);
		_hitboxWorlds.add(hitbox);
		
		//2nd Floor
		hitbox = new FlxSprite( 190, 530);		
		hitbox.makeGraphic(900, 10, FlxColor.TRANSPARENT);
		_hitboxWorlds.add(hitbox);
		
		add(_hitboxWorlds);
	}
		
	override public function create():Void
	{			
		initTimers(); 
		
		loadSounds();
		
		buildScene();				
	
		levelHitBox();
		
		initGroups();
		
		addEnergyJauge();		
		
		//Set Mirror Position
		_mirrorCenter = new Line(new FlxPoint(484, 460), new FlxPoint(790, 460));						
		
		_shooterLeft = new RockShooter(408, 422,37,-40,-150,10,200); //37 is LEFT arrow
		add(_shooterLeft);					
		
		_shooterRight = new RockShooter(876, 422,39, 40,-150,-10,200); //37 is RIGHT arrow
		add(_shooterRight);		
		
		_sceneProtectDome = new FlxSprite();
		_sceneProtectDome.loadGraphic("assets/images/protection-dome.png");	
		_sceneProtectDome.blend = BlendMode.LIGHTEN;
		_sceneProtectDome.visible = false;
		add(_sceneProtectDome);	
			
		_ui_win = new FlxSprite();
		_ui_win.loadGraphic("assets/images/ui_won.png");
		_ui_win.visible = false;
		add(_ui_win);
		
		_ui_lose = new FlxSprite();
		_ui_lose.loadGraphic("assets/images/ui_game_over.png");
		_ui_lose.visible = false;			
		add(_ui_lose);

		super.create();
	}	

	private function hitRockBadGuy(badGuy:FlxObject, rock:FlxObject):Void
	{
		if (cast(rock, Rock).isExploded() == false)		
			badGuy.kill();	
	}		
	
	override public function update(elapsed:Float):Void
    {
		if (_gameEnded == false)
		{
			checkTimers(elapsed);		
		
			FlxG.overlap(_badGuys, _shooterLeft.projectiles, hitRockBadGuy);
			FlxG.overlap(_badGuys, _shooterRight.projectiles, hitRockBadGuy);				
				
			checkRockWithGround(new Line( new FlxPoint(105, 720), new FlxPoint(440, 470)), _shooterLeft.projectiles);
			checkRockWithGround( new Line( new FlxPoint(1174, 720), new FlxPoint(846, 470)),_shooterRight.projectiles);
			
			checkMeteorCollideWithLevel();
			
			if (cast(_energyJauges.members[0], EnergyJauge).getEnergy() == 1)
				win();			
		}	

        super.update(elapsed);
    }	

	private function doLazerShoot()
	{				
		var canonCenter:FlxPoint = _canon.getMidpoint();
		var canonSight:FlxPoint = _canon.getCanonSight();
		var canonShootLine:Line = new Line(canonCenter, canonSight);
		
		var intersectMirror:FlxPoint = LineMaths.LineIntersectionPoint(_mirrorCenter.start, _mirrorCenter.end, canonCenter, canonSight);
		if ( intersectMirror != null)
		{
			var reflectionPoint:FlxPoint = LineMaths.GetLineReflection(_mirrorCenter.start, _mirrorCenter.end, canonSight, intersectMirror);		
			checkLaserHitMeteor(new Line(intersectMirror, reflectionPoint));
			checkLaserHitMeteor(new Line(canonCenter, intersectMirror));
			drawLazer(new Line(canonCenter, intersectMirror), new Line(intersectMirror, reflectionPoint));
		}
		else
		{
			drawLazer(canonShootLine,null);
		}							
		sndLaser.play();
	}
	

	public function drawLazer(first:Line, reflect:Line)
	{
		if (first != null)
		{			
			_lazerShoot.drawLazer(first, 0.25);
		}			
		if (reflect != null)
		{			
			_lazerImpact.drawImpact(reflect.start,0.25);
			_lazerReflect.drawLazer(reflect, 0.25);
		}
	}	
		
	////////////////////////////////////
	// TESTS BEHAVIOR
	////////////////////////////////////	
	
	private function checkRockWithGround(ground:Line, groupRock:FlxGroup)
	{
		for (i in 0...groupRock.length)			
		{					
			var rock:Rock = cast(groupRock.members[i],Rock);
			if (rock.isExploded())
				continue;
			
			if (LineMaths.intersectLineAndRect(ground.start.x, ground.start.y, ground.end.x, ground.end.y, rock.getHitbox()))
			{
				rock.explode();
			}
		}
	}
	
	private function checkMeteorCollideWithLevel():Void
	{
		//Meteors Checks
		for (i in 0...MAX_METEORS)			
		{	
			var m:entities.Meteor = cast(_meteors.members[i],entities.Meteor);
			if (m.alive == false)
				continue;
				
			var hitbox:FlxRect = m.getMeteorHitbox();
			
			for (j in 0...2)			
			{						
				if (hitbox.overlaps(cast(_hitboxWorlds.members[j],FlxSprite).getHitbox()))
				{			
					sndExplode.play(true);
					spawnMeteorExplosion(hitbox.x, hitbox.y);
					FlxG.camera.shake(0.0018, 0.25);
					m.kill();
					//remove energy / hit
					addEnergy(ENERGY_LOSS);
				}
			}			
		}			
	}
	
	private function checkTimers(elapsedTime:Float)
	{		
		var percentageTimeLeft:Float = ((_timeBeforeLost / GAME_OVER_TIME));
			
		_timeBeforeLost -= elapsedTime;
		 if (_timeBeforeLost < 0)
        {							
			gameOver();
        }		
		_sceneWave.scale.y =  (1-percentageTimeLeft) * SCALE_WAVE_END;
				
		_timeBeforeSpawnBadGuy -= elapsedTime;
		if ( _timeBeforeSpawnBadGuy < 0)
		{
			_timeBeforeSpawnBadGuy = SPAWN_BADGUY_DELAY;
			spawnBadGuy(FlxG.random.bool(50));
		}
				
		//Do we have to fire a laser?
		_timeBeforeNextShoot -= elapsedTime;
        if (_timeBeforeNextShoot < 0)
        {							
			doLazerShoot();
			_timeBeforeNextShoot = SHOOT_DELAY;		
		
		} 			
		
		_timeBeforeEnergyUpdate -= elapsedTime;
		if (_timeBeforeEnergyUpdate < 0)
		{
			//BasGuys Attack Checks
			for (i in 0...MAX_BADGUYS)			
			{	
				var m:BadGuy = cast(_badGuys.members[i],BadGuy);
				if (m.alive == false || m.animation.name != "attack")
					continue;	
						
				addEnergy(ENERGY_LOSS);
			}						
			
			addEnergy(ENERGY_GAIN);
			cast(_energyJauges.members[0], EnergyJauge).updateVisual();
			cast(_energyJauges.members[1], EnergyJauge).updateVisual();	
			_timeBeforeEnergyUpdate = ENERGY_UPDATE_DELAY;
		}
		
		//Do we have to spawn a meteor?
		_timeBeforeSpawnMeteor -= elapsedTime;
		if (_timeBeforeSpawnMeteor < 0)
        {			
			var spanwnX:Float = FlxG.random.int(100, 1180);		
			var destPoint:FlxPoint = new FlxPoint(  FlxG.random.int(500, 900), 680);
			spawnMeteor(spanwnX,destPoint);
			_timeBeforeSpawnMeteor = SPAWN_METEOR_DELAY;
        } 				
		
	}
		
	private function checkLaserHitMeteor(laser:Line)
	{
		//Meteors Checks
		for (i in 0...MAX_METEORS)			
		{	
			var m:entities.Meteor = cast(_meteors.members[i],entities.Meteor);
			if (m.alive == false)
				continue;
				
			var rectMeteor:FlxRect = m.getMeteorHitbox();
			if (LineMaths.intersectLineAndRect(laser.start.x, laser.start.y, laser.end.x, laser.end.y, rectMeteor))
			{
				sndExplode.play(true);
				spawnMeteorExplosion(rectMeteor.x + rectMeteor.width/2, rectMeteor.y + rectMeteor.height/2);
				m.kill();			
			}							
		}						
	}
	
	////////////////////////////////////
		
	
	
	////////////////////////////////////
	// Win/Lose BEHAVIOR
	////////////////////////////////////
	
	private function win()
	{
		_sceneProtectDome.visible = true;
		_ui_win.visible = true;
		_gameEnded = true;
	}
	
	private function gameOver()
	{
		_ui_lose.visible = true;
		_gameEnded = true;
	}
	
	////////////////////////////////////
	// SPAWN BEHAVIOR
	////////////////////////////////////
	
	private function spawnBadGuy(leftSide:Bool):Void
	{
		var obj:FlxBasic = _badGuys.recycle();
		if ( obj != null)
		{
			var badGuy:BadGuy = cast(obj, BadGuy);
			badGuy.reset(0,0); //Simply Reset			
			if (leftSide)
			{
				badGuy.InitLinePath( new Line( new FlxPoint(91, 719), new FlxPoint(406, 476)));	
			}
			else
			{
				badGuy.InitLinePath( new Line( new FlxPoint(1195, 719), new FlxPoint(874, 476)));
			}
		}				
	}
	
	private function spawnMeteorExplosion(x:Float, y:Float)
	{
		var explode:MeteorExplosion = cast( _meteorsExplode.recycle(), MeteorExplosion);
		explode.reset(x - explode.width/2, y - explode.height/2 - 15);
		explode.animation.play("default", true);	
	}
		
	private function spawnMeteor(x:Float,point:FlxPoint)
	{			
		var meteor:Meteor = cast( _meteors.recycle(), Meteor);
			meteor.reset(x + meteor.width / 2, -meteor.height);		
			meteor.setDestination(point);
	}	
	//////////////////////////////
}
