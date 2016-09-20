package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{	
	override public function create():Void
	{					
		var background:FlxSprite = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/title-screen.png");
		add(background);
		
		super.create();
	}

	private function playGame():Void
	{
		 FlxG.switchState(new PlayState());
	}
 
	override public function update(elapsed:Float):Void
	{			
		if ( FlxG.keys.anyPressed([ENTER, SPACE]))
		{			
			playGame();
		}
		
		super.update(elapsed);
	}
}

