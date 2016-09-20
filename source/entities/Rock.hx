package entities; 


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author yben
 */
class Rock extends FlxSprite
{
	private var _exploded:Bool;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
				
		loadGraphic("assets/images/rock.png", true, 74, 74);
				
		this.animation.add("default", [0], 30, false);
		this.animation.add("explode", [0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4], 30, false);
		this.animation.play("default");
		
		_exploded = false;
		
		//modify hitbox
		width = 22;
		height = 32;
		centerOffsets();
	}
	
	public function isExploded():Bool
	{
		return _exploded;
	}

	override public function reset(X:Float, Y:Float):Void
	{	
		_exploded = false;
		this.animation.play("default");
		super.reset(X, Y);
	}
	
	public function explode()
	{
		this.animation.play("explode");
		this.velocity.x = 0;
		this.velocity.y = 0;
		this.acceleration.x = 0;
		this.acceleration.y = 0;
		_exploded = true;
	}
	
	private function hasFinishExplodeAnimation():Bool
	{
		return (this.animation.name == "explode" && this.animation.finished);
	}
		
	override public function update(elapsed:Float):Void
	{
		if (this.x < 0 || this.x > FlxG.width || this.y > FlxG.height ||  hasFinishExplodeAnimation() )
			this.kill();		
			
		super.update(elapsed);
	}
	
}