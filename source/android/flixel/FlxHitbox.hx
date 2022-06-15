package android.flixel;

import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import android.flixel.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;

// Mofifications by saw (m.a. jigsaw)
class FlxHitbox extends FlxSpriteGroup 
{
	public var hitbox:FlxSpriteGroup;

	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	public var buttonLeftHint:FlxSprite;
	public var buttonDownHint:FlxSprite;
	public var buttonUpHint:FlxSprite;
	public var buttonRightHint:FlxSprite;

	public function new()
	{
		super();

		hitbox = new FlxSpriteGroup();

		buttonLeft = new FlxButton(0, 0);
		buttonDown = new FlxButton(0, 0);
		buttonUp = new FlxButton(0, 0);
		buttonRight = new FlxButton(0, 0);

		buttonLeftHint = new FlxSprite(0, 0);
		buttonDownHint = new FlxSprite(0, 0);
		buttonUpHint = new FlxSprite(0, 0);
		buttonRightHint = new FlxSprite(0, 0);

		hitbox.add(add(buttonLeft = createHitbox(0, 0, 'left', 0xFFFF00FF)));
		hitbox.add(add(buttonDown = createHitbox(320, 0, 'down', 0xFF00FFFF)));
		hitbox.add(add(buttonUp = createHitbox(640, 0, 'up', 0xFF00FF00)));
		hitbox.add(add(buttonRight = createHitbox(960, 0, 'right', 0xFFFF0000)));

		hitbox.add(add(buttonLeftHint = createHitboxHint(0, 0, 'left_hint', 0xFFFF00FF)));
		hitbox.add(add(buttonDownHint = createHitboxHint(320, 0, 'down_hint', 0xFF00FFFF)));
		hitbox.add(add(buttonUpHint = createHitboxHint(640, 0, 'up_hint', 0xFF00FF00)));
		hitbox.add(add(buttonRightHint = createHitboxHint(960, 0, 'right_hint', 0xFFFF0000)));
	}

	public function createHitbox(x:Float = 0, y:Float = 0, frames:String, ?color:Int):FlxButton
	{
		var button:FlxButton = new FlxButton(x, y);
		button.loadGraphic(FlxGraphic.fromFrame(getFrames().getByName(frames)));
		button.alpha = 0.00001;
		button.antialiasing = ClientPrefs.globalAntialiasing;
		if (color != null)
			button.color = color;
		button.onDown.callback = function() {FlxTween.num(0.00001, 0.75, 0.075, {ease:FlxEase.circInOut}, function(alpha:Float) {button.alpha = alpha;});}
		button.onUp.callback = function() {FlxTween.num(0.75, 0.00001, 0.1, {ease:FlxEase.circInOut}, function(alpha:Float) {button.alpha = alpha;});}
		button.onOut.callback = function() {FlxTween.num(button.alpha, 0.00001, 0.2, {ease:FlxEase.circInOut}, function(alpha:Float) {button.alpha = alpha;});}
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}

	public function createHitboxHint(x:Float = 0, y:Float = 0, frames:String, ?color:Int):FlxSprite
	{
		var hint:FlxSprite = new FlxSprite(x, y);
		hint.loadGraphic(FlxGraphic.fromFrame(getFrames().getByName(frames)));
		hint.alpha = 0.75;
		if (color != null)
			hint.color = color;
		return hint;
	}

	public function getFrames():FlxAtlasFrames
	{
		return Paths.getSparrowAtlas('android/hitbox');
	}

	override function destroy()
	{
		super.destroy();

		hitbox = FlxDestroyUtil.destroy(hitbox);
		hitbox = null;

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;

		buttonLeftHint = null;
		buttonDownHint = null;
		buttonUpHint = null;
		buttonRightHint = null;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		buttonLeftHint.y = buttonLeft.y;
		buttonDownHint.y = buttonDown.y;
		buttonUpHint.y = buttonUp.y;
		buttonRightHint.y = buttonRight.y;
	}
}