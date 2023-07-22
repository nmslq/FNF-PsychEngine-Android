package objects;

class SongDisplay extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var songName:FlxText;
	public var difficultText:FlxText;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		bg = new FlxSprite().makeGraphic(400, 100, FlxColor.WHITE);
		bg.alpha = 0.7;
		add(bg);

		songName = new FlxText(0, 0, 400, PlayState.SONG.song);
		songName.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(songName);

		difficultText = new FlxText(0, 60, 400, Difficulty.getString());
		difficultText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(difficultText);

		scrollFactor.set();
	}
}