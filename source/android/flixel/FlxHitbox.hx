package android.flixel;

import android.flixel.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import openfl.utils.Assets;

/**
 * A hitbox.
 * It's easy to customize the layout.
 *
 * @author: Saw (M.A. Jigsaw)
 */
class FlxHitbox extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);

	public var hintLeft:FlxSprite = new FlxSprite(0, 0);
	public var hintDown:FlxSprite = new FlxSprite(0, 0);
	public var hintUp:FlxSprite = new FlxSprite(0, 0);
	public var hintRight:FlxSprite = new FlxSprite(0, 0);

	/**
	 * Create a hitbox.
	 */
	public function new()
	{
		super();

		scrollFactor.set();

		add(buttonLeft = createHint(0, 0, 'left', 0xFFFF00FF));
		add(buttonDown = createHint(FlxG.width / 4, 0, 'down', 0xFF00FFFF));
		add(buttonUp = createHint(FlxG.width / 2, 0, 'up', 0xFF00FF00));
		add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), 0, 'right', 0xFFFF0000));

		add(add(hintLeft = createHitboxHint(0, 0, 'left_hint', 0xFFFF00FF)));
		add(add(hintDown = createHitboxHint(FlxG.width / 4, 0, 'down_hint', 0xFF00FFFF)));
		add(add(hintUp = createHitboxHint(FlxG.width / 2, 0, 'up_hint', 0xFF00FF00)));
		add(add(hintRight = createHitboxHint((FlxG.width / 2) + (FlxG.width / 4), 0, 'right_hint', 0xFFFF0000)));
	}

	override function destroy()
	{
		super.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;

		hintLeft = null;
		hintDown = null;
		hintUp = null;
		hintRight = null;
	}

	private function createHint(X:Float, Y:Float, Graphic:String, ?Color:Int = 0xFFFFFF):FlxButton
	{
		var hintTween:FlxTween;
		var hint:FlxButton = new FlxButton(X, Y);
		hint.loadGraphic(FlxGraphic.fromFrame(FlxAtlasFrames.fromSparrow(Assets.getBitmapData('assets/android/hitbox.png'),
			Assets.getText('assets/android/hitbox.xml'))
			.getByName(Graphic)));
		hint.setGraphicSize(Std.int(FlxG.width / 4), FlxG.height);
		hint.updateHitbox();
		hint.scrollFactor.set();
		hint.color = Color;
		hint.alpha = 0.00001;
		hint.onDown.callback = function()
		{
			if (hintTween != null)
				hintTween.cancel();

			hintTween = FlxTween.num(hint.alpha, 0.6, 0.06, {ease: FlxEase.circInOut}, function(value:Float)
			{
				hint.alpha = value;
			});
		}
		hint.onUp.callback = function()
		{
			if (hintTween != null)
				hintTween.cancel();

			hintTween = FlxTween.num(hint.alpha, 0.00001, 0.15, {ease: FlxEase.circInOut}, function(value:Float)
			{
				hint.alpha = value;
			});
		}
		hint.onOut.callback = function()
		{
			if (hintTween != null)
				hintTween.cancel();

			hintTween = FlxTween.num(hint.alpha, 0.00001, 0.2, {ease: FlxEase.circInOut}, function(value:Float)
			{
				hint.alpha = value;
			});
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}

	public function createHitboxHint(x:Float = 0, y:Float = 0, frames:String, ?color:Int):FlxSprite
	{
		var hintS:FlxSprite = new FlxSprite(x, y);
		hintS.loadGraphic(FlxGraphic.fromFrame(Paths.getSparrowAtlas('android/hitbox').getByName(frames)));
		hintS.alpha = 0.75;
		hintS.antialiasing = ClientPrefs.globalAntialiasing;
		hintS.color = color;
		return hintS;
	}
}