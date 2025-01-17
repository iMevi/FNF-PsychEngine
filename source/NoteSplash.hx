package;

import flixel.FlxG;
import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;

	var sc:Array<Float> = [1.3, 1.2, 1.1, 1, 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.3];

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		loadAnims(skin);
		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setupNoteSplash(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		setGraphicSize(Std.int(width * sc[PlayState.mania]));

		alpha = 0.6;

		if(texture == null) {
			texture = 'noteSplashes';
			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) texture = PlayState.SONG.splashSkin;
		}

		if(textureLoaded != texture) {
			loadAnims(texture);
		}
		colorSwap.hue = hueColor;
		colorSwap.saturation = satColor;
		colorSwap.brightness = brtColor;

		var offsets:Array<Int> = [10, 10];
		var mania:Int = PlayState.mania;
		if(Note.offsets.exists(mania)){
			var oA = Note.offsets.get(mania);
			offsets = [oA[0], oA[1]];
		}

		offset.set(offsets[0], offsets[1]);

		var animNum:Int = FlxG.random.int(1, 2);
		var animIndex:Int = Math.floor(Note.keysShit.get(PlayState.mania).get('pixelAnimIndex')[note] % (Note.xmlMax + 1));
		var animToPlay:String = 'note' + animIndex + '-' + animNum;
		animation.play(animToPlay, true);
		if(animation.curAnim != null)animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String) {
		frames = Paths.getSparrowAtlas(skin);
		for (i in 1...3) {
			for (j in 0...Note.gfxLetter.length) {
				var splashLetter:String = Note.gfxLetter[j];
				animation.addByPrefix('note$j-' + i, 'note splash $splashLetter ' + i, 24, false);
			}

			//animation.addByPrefix('note9-' + i, 'note splash E ' + i, 24, false);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim != null)if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}
