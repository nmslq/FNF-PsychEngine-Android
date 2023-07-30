package backend;

import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.mappings.FlxGamepadMapping;
import flixel.input.keyboard.FlxKey;

#if android
import android.AndroidControls;
#end

class Controls
{
	//Keeping same use cases on stuff for it to be easier to understand/use
	//I'd have removed it but this makes it a lot less annoying to use in my opinion

	//You do NOT have to create these variables/getters for adding new keys,
	//but you will instead have to use:
	//   controls.justPressed("ui_up")   instead of   controls.UI_UP

	//Dumb but easily usable code, or Smart but complicated? Your choice.
	//Also idk how to use macros they're weird as fuck lol

	// Pressed buttons (directions)
	public var UI_UP_P(get, never):Bool;
	public var UI_DOWN_P(get, never):Bool;
	public var UI_LEFT_P(get, never):Bool;
	public var UI_RIGHT_P(get, never):Bool;
	public var NOTE_UP_P(get, never):Bool;
	public var NOTE_DOWN_P(get, never):Bool;
	public var NOTE_LEFT_P(get, never):Bool;
	public var NOTE_RIGHT_P(get, never):Bool;
	private function get_UI_UP_P() return justPressed('ui_up');
	private function get_UI_DOWN_P() return justPressed('ui_down');
	private function get_UI_LEFT_P() return justPressed('ui_left');
	private function get_UI_RIGHT_P() return justPressed('ui_right');
	private function get_NOTE_UP_P() return justPressed('note_up');
	private function get_NOTE_DOWN_P() return justPressed('note_down');
	private function get_NOTE_LEFT_P() return justPressed('note_left');
	private function get_NOTE_RIGHT_P() return justPressed('note_right');

	// Held buttons (directions)
	public var UI_UP(get, never):Bool;
	public var UI_DOWN(get, never):Bool;
	public var UI_LEFT(get, never):Bool;
	public var UI_RIGHT(get, never):Bool;
	public var NOTE_UP(get, never):Bool;
	public var NOTE_DOWN(get, never):Bool;
	public var NOTE_LEFT(get, never):Bool;
	public var NOTE_RIGHT(get, never):Bool;
	private function get_UI_UP() return pressed('ui_up');
	private function get_UI_DOWN() return pressed('ui_down');
	private function get_UI_LEFT() return pressed('ui_left');
	private function get_UI_RIGHT() return pressed('ui_right');
	private function get_NOTE_UP() return pressed('note_up');
	private function get_NOTE_DOWN() return pressed('note_down');
	private function get_NOTE_LEFT() return pressed('note_left');
	private function get_NOTE_RIGHT() return pressed('note_right');

	// Released buttons (directions)
	public var UI_UP_R(get, never):Bool;
	public var UI_DOWN_R(get, never):Bool;
	public var UI_LEFT_R(get, never):Bool;
	public var UI_RIGHT_R(get, never):Bool;
	public var NOTE_UP_R(get, never):Bool;
	public var NOTE_DOWN_R(get, never):Bool;
	public var NOTE_LEFT_R(get, never):Bool;
	public var NOTE_RIGHT_R(get, never):Bool;
	private function get_UI_UP_R() return justReleased('ui_up');
	private function get_UI_DOWN_R() return justReleased('ui_down');
	private function get_UI_LEFT_R() return justReleased('ui_left');
	private function get_UI_RIGHT_R() return justReleased('ui_right');
	private function get_NOTE_UP_R() return justReleased('note_up');
	private function get_NOTE_DOWN_R() return justReleased('note_down');
	private function get_NOTE_LEFT_R() return justReleased('note_left');
	private function get_NOTE_RIGHT_R() return justReleased('note_right');

	// Pressed buttons (others)
	public var ACCEPT(get, never):Bool;
	public var BACK(get, never):Bool;
	public var PAUSE(get, never):Bool;
	public var RESET(get, never):Bool;
	private function get_ACCEPT() return justPressed('accept');
	private function get_BACK() return justPressed('back');
	private function get_PAUSE() return justPressed('pause');
	private function get_RESET() return justPressed('reset');

	//Gamepad & Keyboard stuff
	public var keyboardBinds:Map<String, Array<FlxKey>>;
	public var gamepadBinds:Map<String, Array<FlxGamepadInputID>>;

	// code by beihu235
	#if android
	public static var checkKeys:Bool = true;
	#end

	public function justPressed(key:String)
	{
		var result:Bool = false;

		#if android
		if (checkKeys)
			result = checkJustPressed(key);
		#else
		if (FlxG.keys.anyJustPressed(keyboardBinds[key]))
		{
			result = true;
			controllerMode = false;
		}
		#end

		return result || _myGamepadJustPressed(gamepadBinds[key]) == true;
	}

	public function pressed(key:String)
	{
		var result:Bool = false;

		#if android
		if (checkKeys)
			checkPressed(key);
		#else
		if (FlxG.keys.anyPressed(keyboardBinds[key]))
		{
			result = true;
			controllerMode = false;
		}
		#end

		return result || _myGamepadPressed(gamepadBinds[key]) == true;
	}

	public function justReleased(key:String)
	{
		var result:Bool = false;

		#if android
		if (checkKeys)
			checkJustReleased(key);
		#else
		if (FlxG.keys.anyJustReleased(keyboardBinds[key]))
		{
			result = true;
			controllerMode = false;
		}
		#end

		return result || _myGamepadJustReleased(gamepadBinds[key]) == true;
	}

	public var controllerMode:Bool = false;
	private function _myGamepadJustPressed(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyJustPressed(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadPressed(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyPressed(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadJustReleased(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyJustReleased(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}

	// IGNORE THESE
	public static var instance:Controls;
	public function new()
	{
		keyboardBinds = ClientPrefs.keyBinds;
		gamepadBinds = ClientPrefs.gamepadBinds;
	}

	function checkJustPressed(key:String):Bool
	{
		var result:Bool = false;
		if (key == 'accept')
			result = (MusicBeatState.androidControls.virtualPad.buttonA.justPressed == true);
		if (key == 'back')
			result = (MusicBeatState.androidControls.virtualPad.buttonB.justPressed == true);
		if (key == 'ui_up')
			result = (MusicBeatState.androidControls.virtualPad.buttonUp.justPressed == true);
		if (key == 'ui_down')
			result = (MusicBeatState.androidControls.virtualPad.buttonDown.justPressed == true);
		if (key == 'ui_left')
			result = (MusicBeatState.androidControls.virtualPad.buttonLeft.justPressed == true);
		if (key == 'ui_right')
			result = (MusicBeatState.androidControls.virtualPad.buttonRight.justPressed == true);
		if (key == 'note_left')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[0].justPressed == true) : (MusicBeatState.androidControls.virtualPad.buttonLeft.justPressed == true);
		if (key == 'note_down')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[1].justPressed == true) : (MusicBeatState.androidControls.virtualPad.buttonDown.justPressed == true);
		if (key == 'note_up')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[2].justPressed == true) : (MusicBeatState.androidControls.virtualPad.buttonUp.justPressed == true);
		if (key == 'note_right')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[3].justPressed == true) : (MusicBeatState.androidControls.virtualPad.buttonRight.justPressed == true);

		if(result) controllerMode = true;
		return result;
	}

	function checkPressed(key:String):Bool
	{
		var result:Bool = false;
		if (key == 'accept')
			result = (MusicBeatState.androidControls.virtualPad.buttonA.pressed == true);
		if (key == 'back')
			result = (MusicBeatState.androidControls.virtualPad.buttonB.pressed == true);
		if (key == 'ui_up')
			result = (MusicBeatState.androidControls.virtualPad.buttonUp.pressed == true);
		if (key == 'ui_down')
			result = (MusicBeatState.androidControls.virtualPad.buttonDown.pressed == true);
		if (key == 'ui_left')
			result = (MusicBeatState.androidControls.virtualPad.buttonLeft.pressed == true);
		if (key == 'ui_right')
			result = (MusicBeatState.androidControls.virtualPad.buttonRight.pressed == true);
		if (key == 'note_left')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[0].pressed == true) : (MusicBeatState.androidControls.virtualPad.buttonLeft.pressed == true);
		if (key == 'note_down')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[1].pressed == true) : (MusicBeatState.androidControls.virtualPad.buttonDown.pressed == true);
		if (key == 'note_up')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[2].pressed == true) : (MusicBeatState.androidControls.virtualPad.buttonUp.pressed == true);
		if (key == 'note_right')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[3].pressed == true) : (MusicBeatState.androidControls.virtualPad.buttonRight.pressed == true);

		if(result) controllerMode = true;
		return result;
	}

	function checkJustReleased(key:String):Bool
	{
		var result:Bool = false;
		if (key == 'accept')
			result = (MusicBeatState.androidControls.virtualPad.buttonA.justReleased == true);
		if (key == 'back')
			result = (MusicBeatState.androidControls.virtualPad.buttonB.justReleased == true);
		if (key == 'ui_up')
			result = (MusicBeatState.androidControls.virtualPad.buttonUp.justReleased == true);
		if (key == 'ui_down')
			result = (MusicBeatState.androidControls.virtualPad.buttonDown.justReleased == true);
		if (key == 'ui_left')
			result = (MusicBeatState.androidControls.virtualPad.buttonLeft.justReleased == true);
		if (key == 'ui_right')
			result = (MusicBeatState.androidControls.virtualPad.buttonRight.justReleased == true);
		if (key == 'note_left')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[0].justReleased == true) : (MusicBeatState.androidControls.virtualPad.buttonLeft.justReleased == true);
		if (key == 'note_down')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[1].justReleased == true) : (MusicBeatState.androidControls.virtualPad.buttonDown.justReleased == true);
		if (key == 'note_up')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[2].justReleased == true) : (MusicBeatState.androidControls.virtualPad.buttonUp.justReleased == true);
		if (key == 'note_right')
			result = AndroidControls.mode == 'Hitbox' ? (MusicBeatState.androidControls.hitbox.hints[3].justReleased == true) : (MusicBeatState.androidControls.virtualPad.buttonRight.justReleased == true);

		if(result) controllerMode = true;
		return result;
	}
}