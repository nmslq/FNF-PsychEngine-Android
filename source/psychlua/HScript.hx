package psychlua;

import flixel.FlxBasic;
import objects.Character;
import psychlua.FunkinLua;
import psychlua.CustomSubstate;

#if (HSCRIPT_ALLOWED && SScript >= "3.0.0")
import tea.SScript;
class HScript extends SScript
{
	public static var properties(default, null):Map<String, Dynamic> = [
		'FlxG' => flixel.FlxG,
		'FlxSprite' => flixel.FlxSprite,
		'FlxCamera' => flixel.FlxCamera,
		'FlxTimer' => flixel.util.FlxTimer,
		'FlxTween' => flixel.tweens.FlxTween,
		'FlxEase' => flixel.tweens.FlxEase,
		'FlxColor' => CustomFlxColor.instance,
		'PlayState' => PlayState,
		'Paths' => Paths,
		'Conductor' => Conductor,
		'ClientPrefs' => ClientPrefs,
		'Character' => Character,
		'Alphabet' => Alphabet,
		'Note' => objects.Note,
		'CustomSubstate' => CustomSubstate,
		'Countdown' => backend.BaseStage.Countdown,
		#if (!flash && sys)
		'FlxRuntimeShader' => flixel.addons.display.FlxRuntimeShader,
		#end
		'ShaderFilter' => openfl.filters.ShaderFilter,
		'StringTools' => StringTools,
		'setVar' => function(name:String, value:Dynamic) PlayState.instance.variables.set(name, value),
		'getVar' => function(name:String) return PlayState.instance.variables.get(name),
		'removeVar' => function(name:String) return PlayState.instance.variables.remove(name),
		'debugPrint' => function(text:String, ?color:FlxColor = FlxColor.WHITE) PlayState.instance.addTextToDebug(text, color),
		'parentLua' => parentLua,
		'this' => this,
		'game' => PlayState.instance,
		'buildTarget' => FunkinLua.getBuildTarget(),
		'customSubstate' => CustomSubstate.instance,
		'customSubstateName' => CustomSubstate.name,
		'Function_Stop' => FunkinLua.Function_Stop,
		'Function_Continue' => FunkinLua.Function_Continue,
		'Function_StopLua' => FunkinLua.Function_StopLua,
		'Function_StopHScript' => FunkinLua.Function_StopHScript,
		'Function_StopAll' => FunkinLua.Function_StopAll,
		
		'add' => function(obj:FlxBasic) PlayState.instance.add(obj),
		'addBehindGF' => function(obj:FlxBasic) PlayState.instance.addBehindGF(obj),
		'addBehindDad' => function(obj:FlxBasic) PlayState.instance.addBehindDad(obj),
		'addBehindBF' => function(obj:FlxBasic) PlayState.instance.addBehindBF(obj),
		'insert' => function(pos:Int, obj:FlxBasic) PlayState.instance.insert(pos, obj),
		'remove' => function(obj:FlxBasic, splice:Bool = false) PlayState.instance.remove(obj, splice),
	];

	public var parentLua:FunkinLua;
	
	public static function initHaxeModule(parent:FunkinLua)
	{
		if(parent.hscript == null) {
			trace('initializing haxe interp for: ${parent.scriptName}');
			parent.hscript = new HScript(parent);
		}
	}

	public static function initHaxeModuleCode(parent:FunkinLua, code:String)
	{
		initHaxeModule(parent);
		if (parent.hscript != null)
			parent.hscript.doString(code);
	}

	public var origin:String;
	override public function new(?parent:FunkinLua, ?file:String)
	{
		if (file == null)
			file = '';

		super(file, false, false);
		parentLua = parent;
		if (parent != null)
			origin = parent.scriptName;
		if (scriptFile != null && scriptFile.length > 0)
			origin = scriptFile;
		preset();
		execute();
	}

	override function preset()
	{
		super.preset();

		// Some very commonly used classes
		for (key => value in properties)
			set(key, value);

		// For adding your own callbacks

		// not very tested but should work
		set('createGlobalCallback', function(name:String, func:Dynamic)
		{
			#if LUA_ALLOWED
			for (script in PlayState.instance.luaArray)
				if(script != null && script.lua != null && !script.closed)
					Lua_helper.add_callback(script.lua, name, func);
			#end
			FunkinLua.customFunctions.set(name, func);
		});

		// tested
		set('createCallback', function(name:String, func:Dynamic, ?funk:FunkinLua = null)
		{
			if(funk == null) funk = parentLua;
			
			if(parentLua != null) funk.addLocalCallback(name, func);
			else FunkinLua.luaTrace('createCallback ($name): 3rd argument is null', false, false, FlxColor.RED);
		});

		set('addHaxeLibrary', function(libName:String, ?libPackage:String = '') {
			var str:String = '';
			if(libPackage.length > 0)
				str = libPackage + '.' + libName;

			set(libName, resolveClassOrEnum(str + libName));
		});
	}

	function resolveClassOrEnum(name:String):Dynamic {
		var c:Dynamic = Type.resolveClass(name);
		if (c == null)
			c = Type.resolveEnum(name);
		return c;
	}

	// its like deprecated, it doing the same as executeFunction
	public function executeCode(?funcToRun:String, ?funcArgs:Array<Dynamic>):SCall {
		return executeFunction(funcToRun, funcArgs);
	}

	public function executeFunction(?funcToRun:String, ?funcArgs:Array<Dynamic>):SCall {
		var callValue:SCall = call(funcToRun, funcArgs);
		if (!callValue.succeeded) {
			var e = callValue.exceptions[0];
			if (e != null)
				FunkinLua.luaTrace('ERROR (${callValue.calledFunction}) - $e', false, false, FlxColor.RED);
		}
		return callValue;
	}

	public static function implement(funk:FunkinLua)
	{
		#if LUA_ALLOWED
		funk.addLocalCallback("runHaxeCode", function(codeToRun:String, ?varsToBring:Any, ?funcToRun:String, ?funcArgs:Array<Dynamic>):Dynamic {
			var retVal:SCall = null;
			initHaxeModule(funk);

			if(varsToBring != null) {
				if (varsToBring is Array) {
					for (vars in cast(varsToBring, Array<Dynamic>)) if (vars is String) {
						funk.hscript.doString('function bmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXA() { return $vars; this.unset("bmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXA"); }');
						var obj = funk.hscript.call('bmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXA').returnValue;
						var fields = (obj is Class) ? Type.getClassFields(obj) : Reflect.fields(obj);
						for (key in fields)
							funk.hscript.set(key, Reflect.field(obj, key));
					}
				}
				else
					for (key in Reflect.fields(varsToBring))
						funk.hscript.set(key, Reflect.field(varsToBring, key));
			}
			funk.hscript.doString(codeToRun);

			if (funcToRun != null) {
				retVal = funk.hscript.executeFunction(funcToRun, funcArgs);
				if (retVal.returnValue != null)
					return retVal.returnValue;
			}
			return funk.hscript.returnValue;
		});
		funk.addLocalCallback("runHaxeFunction", function(funcToRun:String, ?funcArgs:Array<Dynamic>):Dynamic {
			initHaxeModule(funk);
			return funk.hscript.executeFunction(funcToRun, funcArgs).returnValue;
		});
		// This function is unnecessary because import already exists in SScript as a native feature
		funk.addLocalCallback("addHaxeLibrary", function(?libName:String = '', ?libPackage:String = '') {
			var str:String = '';
			if(libPackage.length > 0)
				str = libPackage + '.' + libName;

			initHaxeModule(funk);
			funk.hscript.set(libName, funk.hscript.resolveClassOrEnum(str + libName));
		});
		#end
	}

	override public function destroy()
	{
		origin = null;
		parentLua = null;

		super.destroy();
	}
}
#end