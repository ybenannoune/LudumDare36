package entities;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author yben
 */
class EnergyJauge extends FlxSprite
{
	private var _energy_bar:FlxSprite;	
	private var _energy:Float; // 0 -> 1   - 100 You Win!
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{				
		X -= 18;
		super(X,Y);
				
		_energy_bar = new FlxSprite(X, Y);
		
		//The Main Picture
		_energy_bar.loadGraphic("assets/images/energy_filling.png");		
		
		this.pixels = _energy_bar.pixels;		
		_energy = 0;
		updateVisual();
	}
		
	public function getEnergy():Float
	{
		return _energy;
	}
	
	public function addEnergy(value:Float)
	{		
		_energy = _energy + value;		
		
		//must be in [0,1] range
		if ( _energy < 0)
		{			
			_energy = 0;
		}
		else if ( _energy > 1)
		{			
			_energy = 1;
		}
	}
	
	// 0 -> 1 , percentage
	public function updateVisual():Void
	{	
		var eHeigth:Float = _energy_bar.height * (1 - _energy);
		var bar_bmp:BitmapData = new BitmapData(cast(_energy_bar.width,Int), cast(_energy_bar.height,Int), true, 0x00000000);	
		bar_bmp.copyPixels(_energy_bar.pixels, new Rectangle(0, eHeigth, cast(_energy_bar.width,Int), cast(_energy_bar.height,Int)), new Point(0,eHeigth), null, null, true);
		this.pixels = bar_bmp;	
	}	
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);		
	}
	
}