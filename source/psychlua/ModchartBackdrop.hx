package psychlua;

import flixel.addons.display.FlxBackdrop;

class ModchartBackdrop extends FlxBackdrop
{
	public var wasAdded:Bool = false;
	//public var isInFront:Bool = false;

	public function new(?x:Float = 0, ?y:Float = 0, ?repeatX:Bool = true, ?repeatY:Bool = true)
	{
		super(null, 1, 1, repeatX, repeatY);
		this.x = x;
		this.y = y;
		antialiasing = ClientPrefs.data.antialiasing;
		lowestCamZoom = PlayState.instance.defaultCamZoom;
	}
}