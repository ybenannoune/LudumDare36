package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author yben
 */
class MeteorExplosion extends FlxSprite
{

	public function new() 
	{
		super();
		
		loadGraphic("assets/images/spritesheet-explosion-meteor.png", true, 196, 154);
		
		animation.add("default", [0, 0, 1, 1, 2, 2, 3, 3], 30, false);		
	}
	
	override public function update(elapsed:Float):Void
	{		
		if (animation.finished)
			this.kill();
			
		super.update(elapsed);
	}
}