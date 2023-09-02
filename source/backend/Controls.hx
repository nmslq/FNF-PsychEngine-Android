package backend;

import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.mappings.FlxGamepadMapping;
import flixel.input.keyboard.FlxKey;

#if android
import android.flixel.FlxVirtualPad;
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
	public static var checkStates:Bool = true;
	public static var controlsMode:Int = -1; // -1 = null, 0 = Hitbox, 1 = Vpad
	#end

	public function justPressed(key:String)
	{
		var result:Bool = false;

		#if android
		if (checkKeys)
			result = checkJustPressed(key, getVirtualPad(), getNoteControls());

		if(result) controllerMode = true;
		#end
		
		if (FlxG.keys.anyJustPressed(keyboardBinds[key]))
		{
			result = true;
			controllerMode = false;
		}

		return result || _myGamepadJustPressed(gamepadBinds[key]) == true;
	}

	public function pressed(key:String)
	{
		var result:Bool = false;

		#if android
		if (checkKeys)
			result = checkPressed(key, getVirtualPad(), getNoteControls());

		if(result) controllerMode = true;
		#end
		
		if (FlxG.keys.anyPressed(keyboardBinds[key]))
		{
			result = true;
			controllerMode = false;
		}

		return result || _myGamepadPressed(gamepadBinds[key]) == true;
	}

	public function justReleased(key:String)
	{
		var result:Bool = false;

		#if android
		if (checkKeys)
			result = checkJustReleased(key, getVirtualPad(), getNoteControls());

		if(result) controllerMode = true;
		#end
		
		if (FlxG.keys.anyJustReleased(keyboardBinds[key]))
		{
			result = true;
			controllerMode = false;
		}

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

	#if android
	public static function getKeys()
	{
		switch (AndroidControls.mode)
		{
			case 'Hitbox':
				controlsMode = 0;
			case 'Pad-Left' | 'Pad-Custom' | 'Pad-Right':
				controlsMode = 1;
			case 'Keyboard':
				controlsMode = -1;
		}
	}

	function getVirtualPad():FlxVirtualPad
		return checkStates ? MusicBeatState.virtualPad : MusicBeatSubstate.virtualPad;
	
	function getNoteControls():AndroidControls
		return MusicBeatState.androidControls;

	function checkJustPressed(key:String, vpad:FlxVirtualPad, anc:AndroidControls):Bool
	{
		var result:Bool = switch (key)
		{
			case 'accept': vpad.buttonA.justPressed;
			case 'back': vpad.buttonB.justPressed;
			case 'ui_up': vpad.buttonUp.justPressed;
			case 'ui_down': vpad.buttonDown.justPressed;
			case 'ui_left': vpad.buttonLeft.justPressed;
			case 'ui_right': vpad.buttonRight.justPressed;
			case 'note_left': controlsMode == 0 ? anc.hitbox.hints[0].justPressed : anc.virtualPad.buttonLeft.justPressed;
			case 'note_down': controlsMode == 0 ? anc.hitbox.hints[1].justPressed : anc.virtualPad.buttonDown.justPressed;
			case 'note_up': controlsMode == 0 ? anc.hitbox.hints[2].justPressed : anc.virtualPad.buttonUp.justPressed;
			case 'note_right': controlsMode == 0 ? anc.hitbox.hints[3].justPressed : anc.virtualPad.buttonRight.justPressed;
			default: false;
		}
		if (key.startsWith('note') && controlsMode == -1)
			result = false;

		return result;
	}

	function checkPressed(key:String, vpad:FlxVirtualPad, anc:AndroidControls):Bool
	{
		var result:Bool = switch (key)
		{
			case 'accept': vpad.buttonA.pressed;
			case 'back': vpad.buttonB.pressed;
			case 'ui_up': vpad.buttonUp.pressed;
			case 'ui_down': vpad.buttonDown.pressed;
			case 'ui_left': vpad.buttonLeft.pressed;
			case 'ui_right': vpad.buttonRight.pressed;
			case 'note_left': controlsMode == 0 ? anc.hitbox.hints[0].pressed : anc.virtualPad.buttonLeft.pressed;
			case 'note_down': controlsMode == 0 ? anc.hitbox.hints[1].pressed : anc.virtualPad.buttonDown.pressed;
			case 'note_up': controlsMode == 0 ? anc.hitbox.hints[2].pressed : anc.virtualPad.buttonUp.pressed;
			case 'note_right': controlsMode == 0 ? anc.hitbox.hints[3].pressed : anc.virtualPad.buttonRight.pressed;
			default: false;
		}
		if (key.startsWith('note') && controlsMode == -1)
			result = false;

		return result;
	}

	function checkJustReleased(key:String, vpad:FlxVirtualPad, anc:AndroidControls):Bool
	{
		var result:Bool = switch (key)
		{
			case 'accept': vpad.buttonA.justReleased;
			case 'back': vpad.buttonB.justReleased;
			case 'ui_up': vpad.buttonUp.justReleased;
			case 'ui_down': vpad.buttonDown.justReleased;
			case 'ui_left': vpad.buttonLeft.justReleased;
			case 'ui_right': vpad.buttonRight.justReleased;
			case 'note_left': controlsMode == 0 ? anc.hitbox.hints[0].justReleased : anc.virtualPad.buttonLeft.justReleased;
			case 'note_down': controlsMode == 0 ? anc.hitbox.hints[1].justReleased : anc.virtualPad.buttonDown.justReleased;
			case 'note_up': controlsMode == 0 ? anc.hitbox.hints[2].justReleased : anc.virtualPad.buttonUp.justReleased;
			case 'note_right': controlsMode == 0 ? anc.hitbox.hints[3].justReleased : anc.virtualPad.buttonRight.justReleased;
			default: false;
		}
		if (key.startsWith('note') && controlsMode == -1)
			result = false;

		return result;
	}
	#end
}