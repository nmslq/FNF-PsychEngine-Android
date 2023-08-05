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
	public static var checkStates:Bool = true;
	public static var controlsType:Int = -1; // -1 = null, 0 = Hitbox, 1 = Vpad
	#end

	public function justPressed(key:String)
	{
		var result:Bool = false;

		#if android
		var virtualPad = MusicBeatState.virtualPad;
		if (checkKeys)
		{
			if (checkStates)
		    {
				if (key == 'accept')
					result = (virtualPad.buttonA.justPressed == true);
				if (key == 'back')
					result = (virtualPad.buttonB.justPressed == true);
				if (key == 'ui_up')
					result = (virtualPad.buttonUp.justPressed == true);
				if (key == 'ui_down')
					result = (virtualPad.buttonDown.justPressed == true);
				if (key == 'ui_left')
					result = (virtualPad.buttonLeft.justPressed == true);
				if (key == 'ui_right')
					result = (virtualPad.buttonRight.justPressed == true);
		    }		
		    else
		    {
    		    if (key == 'accept')
					result = (MusicBeatSubstate.virtualPad.buttonA.justPressed == true);
				if (key == 'back')
					result = (MusicBeatSubstate.virtualPad.buttonB.justPressed == true);
				if (key == 'ui_up')
					result = (MusicBeatSubstate.virtualPad.buttonUp.justPressed == true);
				if (key == 'ui_down')
					result = (MusicBeatSubstate.virtualPad.buttonDown.justPressed == true);
				if (key == 'ui_left')
					result = (MusicBeatSubstate.virtualPad.buttonLeft.justPressed == true);
				if (key == 'ui_right')
					result = (MusicBeatSubstate.virtualPad.buttonRight.justPressed == true);
		    }
		}

		if (controlsType == 0)
		{
			if (key == 'note_left')
				result = (MusicBeatState.androidControls.hitbox.hints[0].justPressed == true);
			if (key == 'note_down')
				result = (MusicBeatState.androidControls.hitbox.hints[1].justPressed == true);
			if (key == 'note_up')
				result = (MusicBeatState.androidControls.hitbox.hints[2].justPressed == true);
			if (key == 'note_right')
				result = (MusicBeatState.androidControls.hitbox.hints[3].justPressed == true);
		}
		else if (controlsType == 1)
		{
			if (key == 'note_up')
				result = (MusicBeatState.androidControls.virtualPad.buttonUp.justPressed == true);
			if (key == 'note_down')
				result = (MusicBeatState.androidControls.virtualPad.buttonDown.justPressed == true);
			if (key == 'note_left')
				result = (MusicBeatState.androidControls.virtualPad.buttonLeft.justPressed == true);
			if (key == 'note_right')
				result = (MusicBeatState.androidControls.virtualPad.buttonRight.justPressed == true);
		}

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
		var virtualPad = MusicBeatState.virtualPad;
		if (checkKeys)
		{
			if (checkStates)
		    {
				if (key == 'ui_up')
					result = (virtualPad.buttonUp.pressed == true);
				if (key == 'ui_down')
					result = (virtualPad.buttonDown.pressed == true);
				if (key == 'ui_left')
					result = (virtualPad.buttonLeft.pressed == true);
				if (key == 'ui_right')
					result = (virtualPad.buttonRight.pressed == true);
		    }		
		    else
		    {
				if (key == 'ui_up')
					result = (MusicBeatSubstate.virtualPad.buttonUp.pressed == true);
				if (key == 'ui_down')
					result = (MusicBeatSubstate.virtualPad.buttonDown.pressed == true);
				if (key == 'ui_left')
					result = (MusicBeatSubstate.virtualPad.buttonLeft.pressed == true);
				if (key == 'ui_right')
					result = (MusicBeatSubstate.virtualPad.buttonRight.pressed == true);
		    }
		}

		if (controlsType == 0)
		{
			if (key == 'note_left')
				result = (MusicBeatState.androidControls.hitbox.hints[0].pressed == true);
			if (key == 'note_down')
				result = (MusicBeatState.androidControls.hitbox.hints[1].pressed == true);
			if (key == 'note_up')
				result = (MusicBeatState.androidControls.hitbox.hints[2].pressed == true);
			if (key == 'note_right')
				result = (MusicBeatState.androidControls.hitbox.hints[3].pressed == true);
		}
		else if (controlsType == 1)
		{
			if (key == 'note_up')
				result = (MusicBeatState.androidControls.virtualPad.buttonUp.pressed == true);
			if (key == 'note_down')
				result = (MusicBeatState.androidControls.virtualPad.buttonDown.pressed == true);
			if (key == 'note_left')
				result = (MusicBeatState.androidControls.virtualPad.buttonLeft.pressed == true);
			if (key == 'note_right')
				result = (MusicBeatState.androidControls.virtualPad.buttonRight.pressed == true);
		}

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
		var virtualPad = MusicBeatState.virtualPad;
		if (checkKeys)
		{
			if (checkStates)
		    {
				if (key == 'ui_up')
					result = (virtualPad.buttonUp.justReleased == true);
				if (key == 'ui_down')
					result = (virtualPad.buttonDown.justReleased == true);
				if (key == 'ui_left')
					result = (virtualPad.buttonLeft.justReleased == true);
				if (key == 'ui_right')
					result = (virtualPad.buttonRight.justReleased == true);
		    }		
		    else
		    {
				if (key == 'ui_up')
					result = (MusicBeatSubstate.virtualPad.buttonUp.justReleased == true);
				if (key == 'ui_down')
					result = (MusicBeatSubstate.virtualPad.buttonDown.justReleased == true);
				if (key == 'ui_left')
					result = (MusicBeatSubstate.virtualPad.buttonLeft.justReleased == true);
				if (key == 'ui_right')
					result = (MusicBeatSubstate.virtualPad.buttonRight.justReleased == true);
		    }
		}

		if (controlsType == 0)
		{
			if (key == 'note_left')
				result = (MusicBeatState.androidControls.hitbox.hints[0].justReleased == true);
			if (key == 'note_down')
				result = (MusicBeatState.androidControls.hitbox.hints[1].justReleased == true);
			if (key == 'note_up')
				result = (MusicBeatState.androidControls.hitbox.hints[2].justReleased == true);
			if (key == 'note_right')
				result = (MusicBeatState.androidControls.hitbox.hints[3].justReleased == true);
		}
		else if (controlsType == 1)
		{
			if (key == 'note_up')
				result = (MusicBeatState.androidControls.virtualPad.buttonUp.justReleased == true);
			if (key == 'note_down')
				result = (MusicBeatState.androidControls.virtualPad.buttonDown.justReleased == true);
			if (key == 'note_left')
				result = (MusicBeatState.androidControls.virtualPad.buttonLeft.justReleased == true);
			if (key == 'note_right')
				result = (MusicBeatState.androidControls.virtualPad.buttonRight.justReleased == true);
		}

		if(result) controllerMode = true;
		#end
		
		if (FlxG.keys.anyJustReleased(keyboardBinds[key]))
		{
			result = true;
			controllerMode = false;
		}

		return result || _myGamepadJustReleased(gamepadBinds[key]) == true;
	}

	public var controllerMode:Bool = #if android true #else false #end;
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
				controlsType = 0;
			case 'Pad-Left' | 'Pad-Custom' | 'Pad-Right':
				controlsType = 1;
			case 'Keyboard':
				controlsType = -1;
		}
	}
	#end
}