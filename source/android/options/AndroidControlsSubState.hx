package android.options;

import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

import flixel.util.FlxSave;

import android.flixel.FlxButton;
import android.flixel.FlxHitbox;
import android.flixel.FlxVirtualPad;
import flixel.input.touch.FlxTouch;

import openfl.utils.Assets;

class AndroidControlsSubState extends FlxSubState
{
	private final controlsItems:Array<String> = ['Pad-Right', 'Pad-Left', 'Pad-Custom', 'Hitbox', 'Keyboard'];

	private var virtualPad:FlxVirtualPad;
	private var hitbox:FlxHitbox;

	private var upPosition:FlxText;
	private var downPosition:FlxText;
	private var leftPosition:FlxText;
	private var rightPosition:FlxText;
	private var grpControls:FlxText;
	private var funitext:FlxText;

	private var leftArrow:FlxSprite;
	private var rightArrow:FlxSprite;

	private var curSelected:Int = 0;
	private var buttonBinded:Bool = false;

	private var bindButton:FlxButton;
	private var resetButton:FlxButton;

	override function create()
	{
		for (i in 0...controlsItems.length)
			if (controlsItems[i] == AndroidControls.mode)
				curSelected = i;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFF7DD47D;
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.screenCenter();
		add(bg);
		
		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		var exitButton:FlxButton = new FlxButton(FlxG.width - 200, 50, 'Exit', function()
		{
			AndroidControls.mode = controlsItems[Math.floor(curSelected)];

			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
				AndroidControls.customVirtualPad = virtualPad;

			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		});
		exitButton.setGraphicSize(Std.int(exitButton.width) * 3);
		exitButton.label.setFormat(Assets.getFont('assets/fonts/vcr.ttf').fontName, 21, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		exitButton.color = FlxColor.LIME;
		add(exitButton);

		resetButton = new FlxButton(exitButton.x, exitButton.y + 100, 'Reset', function()
		{
			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom' && resetButton.visible) // being sure about something
			{
				AndroidControls.customVirtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
				reloadAndroidControls('Pad-Custom');
			}
		});
		resetButton.setGraphicSize(Std.int(resetButton.width) * 3);
		resetButton.label.setFormat(Assets.getFont('assets/fonts/vcr.ttf').fontName, 21, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		resetButton.color = FlxColor.RED;
		resetButton.visible = false;
		add(resetButton);

		funitext = createText(0, 'No Android Controls!');
		funitext.screenCenter();
		funitext.visible = false;
		add(funitext);

		grpControls = createText(100, '');
		grpControls.screenCenter(X);
		add(grpControls);

		leftArrow = createArrow(grpControls.x - 60, 'arrow left');
		add(leftArrow);

		rightArrow = createArrow(grpControls.x + grpControls.width + 10, 'arrow right');
		add(rightArrow);

		rightPosition = createPosition(24);
		add(rightPosition);

		leftPosition = createPosition(44);
		add(leftPosition);

		downPosition = createPosition(64);
		add(downPosition);

		upPosition = createPosition(84);
		add(upPosition);

		changeSelection();

		super.create();
	}

	function createPosition(y:Int):FlxText
	{
		var position:FlxText = new FlxText(10, FlxG.height - y, 0, '', 16);
		position.setFormat(Assets.getFont('assets/fonts/vcr.ttf').fontName, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		position.borderSize = 3;
		position.borderQuality = 1;
		add(position);
		return position;
	}

	function createArrow(x:Float, anim:String):FlxSprite
	{
		var arrow:FlxSprite = new FlxSprite(x, grpControls.y - 25);
		arrow.frames = Paths.getSparrowAtlas('android/menu/arrows');
		arrow.animation.addByPrefix('idle', anim);
		arrow.animation.play('idle');
		add(arrow);
		return arrow;
	}

	function createText(y:Int, txt:String)
	{
		var text:FlxText = new FlxText(0, y, 0, txt, 32);
		text.setFormat(Assets.getFont('assets/fonts/vcr.ttf').fontName, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		text.borderSize = 3;
		text.borderQuality = 1;
		add(text);
		return text;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (touch in FlxG.touches.list)
		{
			if (touch.overlaps(leftArrow) && touch.justPressed)
				changeSelection(-1);
			else if (touch.overlaps(rightArrow) && touch.justPressed)
				changeSelection(1);

			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
			{
				if (buttonBinded)
				{
					if (touch.justReleased)
					{
						bindButton = null;
						buttonBinded = false;
					}
					else 
						moveButton(touch, bindButton);
				}
				else
				{
					if (virtualPad.buttonUp.justPressed)
						moveButton(touch, virtualPad.buttonUp);
					else if (virtualPad.buttonDown.justPressed)
						moveButton(touch, virtualPad.buttonDown);
					else if (virtualPad.buttonRight.justPressed)
						moveButton(touch, virtualPad.buttonRight);
					else if (virtualPad.buttonLeft.justPressed)
						moveButton(touch, virtualPad.buttonLeft);
				}
			}
		}

		if (virtualPad != null && controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
		{
			if (virtualPad.buttonUp != null)
				upPosition.text = 'Button Up X:' + virtualPad.buttonUp.x + ' Y:' + virtualPad.buttonUp.y;

			if (virtualPad.buttonDown != null)
				downPosition.text = 'Button Down X:' + virtualPad.buttonDown.x + ' Y:' + virtualPad.buttonDown.y;

			if (virtualPad.buttonLeft != null)
				leftPosition.text = 'Button Left X:' + virtualPad.buttonLeft.x + ' Y:' + virtualPad.buttonLeft.y;

			if (virtualPad.buttonRight != null)
				rightPosition.text = 'Button Right X:' + virtualPad.buttonRight.x + ' Y:' + virtualPad.buttonRight.y;
		}
	}

	private function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = controlsItems.length - 1;
		else if (curSelected >= controlsItems.length)
			curSelected = 0;

		grpControls.text = controlsItems[Math.floor(curSelected)];
		grpControls.screenCenter(X);

		leftArrow.x = grpControls.x - 60;
		rightArrow.x = grpControls.x + grpControls.width + 10;

		var daChoice:String = controlsItems[Math.floor(curSelected)];

		reloadAndroidControls(daChoice);

		funitext.visible = daChoice == 'Keyboard';
		resetButton.visible = daChoice == 'Pad-Custom';
		upPosition.visible = daChoice == 'Pad-Custom';
		downPosition.visible = daChoice == 'Pad-Custom';
		leftPosition.visible = daChoice == 'Pad-Custom';
		rightPosition.visible = daChoice == 'Pad-Custom';
	}

	private function moveButton(touch:FlxTouch, button:FlxButton):Void
	{
		bindButton = button;
		bindButton.x = touch.x - Std.int(bindButton.width / 2);
		bindButton.y = touch.y - Std.int(bindButton.height / 2);

		if (!buttonBinded)
			buttonBinded = true;
	}

	private function reloadAndroidControls(daChoice:String):Void
	{
		removeControls();

		switch (daChoice)
		{
			case 'Pad-Right':
				virtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
				add(virtualPad);
			case 'Pad-Left':
				virtualPad = new FlxVirtualPad(LEFT_FULL, NONE);
				add(virtualPad);
			case 'Pad-Custom':
				virtualPad = AndroidControls.customVirtualPad;
				add(virtualPad);
			case 'Hitbox':
				hitbox = new FlxHitbox(4, Std.int(FlxG.width / 4), FlxG.height, [0xFF00FF, 0x00FFFF, 0x00FF00, 0xFF0000]);
				add(hitbox);
			default:
		}

		if (virtualPad != null)
			virtualPad.visible = (daChoice != 'Hitbox' && daChoice != 'Keyboard');

		if (hitbox != null)
			hitbox.visible = (daChoice == 'Hitbox');
	}

	private function removeControls():Void
	{
		if (virtualPad != null)
			remove(virtualPad);

		if (hitbox != null)
			remove(hitbox);
	}
}