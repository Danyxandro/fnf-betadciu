package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box2:FlxSprite = new FlxSprite();
	private var dialogueCount:Int = 1;
	private var defaultBubble:Bool = false;
	private var sound:flixel.system.FlxSound = new flixel.system.FlxSound();
	private var face = new FlxSprite();
	var portraitExtra:FlxSprite = new FlxSprite();
	var portraitGF:FlxSprite = new FlxSprite();
	private var originalColor:FlxColor;
	private var dropColor:FlxColor;
	private var colors = [FlxColor.fromRGB(232, 61, 126),FlxColor.fromRGB(157, 48, 90),FlxColor.fromInt(0xFF3F2021),FlxColor.fromInt(0x47b0c1FF)];
	private var background:FlxSpriteGroup = new FlxSpriteGroup();
	private var splitBack:String = "";
	private var BGid:Int = -1;
	private var hint:FlxText;
	private var r = new EReg("[^0-9]", "i");

	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite = new FlxSprite();
	var portraitRight:FlxSprite = new FlxSprite();

	var handSelect:FlxSprite = new FlxSprite();
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		FlxG.sound.list.add(sound);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'imposible-posible':
				FlxG.sound.playMusic(Paths.inst('Eggnog'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'moldy-drops' | 'six-ft-under':
				FlxG.sound.playMusic(Paths.music('loop'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'growth' | 'exploration' | 'control':
				FlxG.sound.playMusic(Paths.music('translucent'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'ugh' | 'guns' | 'stress':
				FlxG.sound.playMusic(Paths.music('tankmanLoop'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'impetus':
				FlxG.sound.playMusic(Paths.music('discovery loop'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'sadds':
				FlxG.sound.playMusic(Paths.music('defeated'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'csikos-post':
				FlxG.sound.playMusic(Paths.music('prelude'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'anger':
				FlxG.sound.playMusic(Paths.music('cardiogram'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'strange-comfort':
				FlxG.sound.playMusic(Paths.music('control loop'),0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		add(background);

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		if(sys.FileSystem.exists("assets/data/" + PlayState.SONG.song.toLowerCase() + "/backgrounds.json")){
			var bgJson:Array<Dynamic> = cast Json.parse( sys.io.File.getContent( "assets/data/" + PlayState.SONG.song.toLowerCase() + "/backgrounds.json" ).trim() ).bg;
			trace(bgJson);
			for (ar in bgJson){
				var bg:FlxSprite = new FlxSprite();
				bg = new FlxSprite(ar[1], ar[2]).loadGraphic(openfl.display.BitmapData.fromFile("assets/shared/images/dialogueBG/" + ar[0] + ".png"));
				bg.scrollFactor.set();
				bg.antialiasing = true;
				bg.scale.set(ar[3], ar[3]);
				bg.visible = false;
				background.add(bg);
			}
		}

		hint = new FlxText(0, FlxG.height - 45, 0, 'PRESS "SPACE" TO SKIP', 16);
		hint.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		hint.scrollFactor.set();
		hint.borderSize = 4;
		hint.borderQuality = 2;
		hint.screenCenter(X);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
			background.alpha += (1 / 5) * 0.7; //lo agregue yo
			if (background.alpha > 1)
				background.alpha = 1;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				face = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
			case 'imposible-posible' | 'moldy-drops' | 'six-ft-under':
				{
					hasDialog = true;
				}
			case 'growth' | 'exploration' | 'control':
				hasDialog = true;
			case 'ugh' | 'guns' | 'stress':
				hasDialog = true;
			case 'impetus' | 'sadds' | 'csikos-post' | 'anger' | 'strange-comfort':
				hasDialog = true;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		switch (PlayState.SONG.song.toLowerCase()) //Esto del switch lo agrege yo
		{
			case 'senpai' | 'roses' | 'thorns':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

				if(PlayState.SONG.song.toLowerCase() == 'thorns'){
					add(face);
				}

				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
				box.animation.play('normalOpen');
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.updateHitbox();
				add(box);

				box.screenCenter(X);
				portraitLeft.screenCenter(X);
			case 'imposible-posible' | 'moldy-drops' | 'six-ft-under':
			{
				portraitLeft = new FlxSprite(80, 175);
				portraitLeft.frames = Paths.getSparrowAtlas('referencezip/beatPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(590, 175); //590,175
				portraitRight.frames = Paths.getSparrowAtlas('referencezip/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.animation.addByPrefix('scared', 'Boyfriend scared', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.4));
				portraitRight.antialiasing = true;
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

				portraitGF = new FlxSprite(780, 175);
				portraitGF.frames = Paths.getSparrowAtlas('referencezip/gfPortrait2');
				portraitGF.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitGF.animation.addByPrefix('scared', 'GF scared', 24, false);				
				//portraitExtra.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitGF.updateHitbox();
				portraitGF.scrollFactor.set();
				portraitGF.antialiasing = true;
				add(portraitGF);
				portraitGF.visible = false;

				box = new FlxSprite(-20, 390);
				box.frames = Paths.getSparrowAtlas('referencezip/Bubble');
				box.animation.addByPrefix('normalOpen','Bubble',24, false);
				box.animation.addByIndices('normal','Bubble',[5],"",24);
				box.antialiasing = true;
				box.animation.play('normalOpen');
				box.scale.set(0.9,0.8);
				add(box);
				box.screenCenter(X);
			}
			case 'growth' | 'exploration' | 'control':
			{
				portraitLeft = new FlxSprite(700, 175);
				portraitLeft.frames = Paths.getSparrowAtlas('referencezip/beatPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.flipX = true;
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitExtra = new FlxSprite(80, 175);
				portraitExtra.frames = Paths.getSparrowAtlas('keen/KeenPortrait');
				portraitExtra.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitExtra.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitExtra.updateHitbox();
				portraitExtra.scrollFactor.set();
				portraitExtra.antialiasing = true;
				add(portraitExtra);
				portraitExtra.visible = false;

				colors[2] = FlxColor.fromRGB(208, 149, 53);
				colors[3] = FlxColor.fromRGB(144, 103, 37);

				portraitGF = new FlxSprite(780, 175);
				portraitGF.frames = Paths.getSparrowAtlas('referencezip/gfPortrait2');
				portraitGF.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitGF.animation.addByPrefix('scared', 'GF scared', 24, false);				
				//portraitExtra.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitGF.updateHitbox();
				portraitGF.scrollFactor.set();
				portraitGF.antialiasing = true;
				add(portraitGF);
				portraitGF.visible = false;

				portraitRight = new FlxSprite(780, 175);
				portraitRight.frames = Paths.getSparrowAtlas('keen/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.animation.addByPrefix('scared', 'Boyfriend scared', 24, false);
				portraitRight.antialiasing = true;
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

				box2 = new FlxSprite(-20, 320);
				box2.frames = Paths.getSparrowAtlas('keen/Bubble');
				box2.animation.addByPrefix('normalOpen','Bubble',24, false);
				box2.animation.addByIndices('normal','Bubble',[3],"",24);
				box2.antialiasing = true;
				box2.animation.play('normalOpen');
				box2.scale.set(1.2,0.7);
				add(box2);
				box2.screenCenter(X);
				box2.visible = false;

				box = new FlxSprite(-20, 390);
				box.frames = Paths.getSparrowAtlas('referencezip/Bubble');
				box.animation.addByPrefix('normalOpen','Bubble',24, false);
				box.animation.addByIndices('normal','Bubble',[5],"",24);
				box.antialiasing = true;
				box.animation.play('normalOpen');
				box.scale.set(0.9,0.8);
				add(box);
				box.screenCenter(X);
				
			}
			case 'ugh' | 'guns' | 'stress':
			{
				defaultBubble = true;
				portraitLeft = new FlxSprite(60, 215);
				portraitLeft.frames = Paths.getSparrowAtlas('tankman/portraits/tankmanPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.scale.set(1.2,1.2);
				portraitLeft.antialiasing = true;
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(590, 175);
				portraitRight.frames = Paths.getSparrowAtlas('tankman/portraits/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.4));
				portraitRight.antialiasing = true;
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

				if(PlayState.SONG.song.toLowerCase() == 'stress'){
					portraitGF = new FlxSprite(820, 175);
					portraitGF.frames = Paths.getSparrowAtlas('tankman/portraits/gfPortrait2');
					portraitGF.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
					portraitGF.scrollFactor.set();
					portraitGF.antialiasing = true;
					add(portraitGF);
					portraitGF.visible = false;

					portraitRight = new FlxSprite(780, 175);
					portraitRight.frames = Paths.getSparrowAtlas('tankman/portraits/bfPortrait2');
					portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
					portraitRight.antialiasing = true;
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set();
					add(portraitRight);
					portraitRight.visible = false;

					portraitExtra = new FlxSprite(830, 165);
					portraitExtra.frames = Paths.getSparrowAtlas('tankman/portraits/picoPortrait');
					portraitExtra.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
					//portraitExtra.setGraphicSize(Std.int(portraitLeft.width * 0.4));
					portraitExtra.updateHitbox();
					portraitExtra.scrollFactor.set();
					portraitExtra.antialiasing = true;
					add(portraitExtra);
					portraitExtra.visible = false;

					box2 = new FlxSprite(-20, 315);
					box2.frames = Paths.getSparrowAtlas('speech_bubble_talking');
					box2.animation.addByPrefix('normalOpen','speech bubble loud open',24, false);
					box2.animation.addByPrefix('normal','AHH speech bubble0',24,true);
					box2.setGraphicSize(Std.int(portraitLeft.width * 4));
					box2.antialiasing = true;
					box2.animation.play('normal');
					add(box2);
					box2.visible = false;
					box2.screenCenter(X);
				}

				colors[2] = FlxColor.fromRGB(208, 149, 53);
				colors[3] = FlxColor.fromRGB(144, 103, 37);

				box = new FlxSprite(-20, 390);
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen','Speech Bubble Normal Open',24, false);
				box.animation.addByPrefix('normal','speech bubble normal0',24,true);
				box.antialiasing = true;
				box.animation.play('normalOpen');
				box.flipX = true;
				add(box);
				box.screenCenter(X);
			}
			case 'impetus' | 'sadds' | 'csikos-post' | 'anger':{
				portraitLeft = new FlxSprite(120,105);
				portraitLeft.frames = Paths.getSparrowAtlas('OJ/OJportrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.animation.addByPrefix('anger', 'Anger', 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitExtra = new FlxSprite(800, 155);
				portraitExtra.frames = Paths.getSparrowAtlas('keen/KeenPortrait');
				portraitExtra.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitExtra.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitExtra.updateHitbox();
				portraitExtra.scrollFactor.set();
				portraitExtra.antialiasing = true;
				portraitExtra.flipX = true;
				add(portraitExtra);
				portraitExtra.visible = false;

				colors[2] = FlxColor.fromRGB(208, 149, 53);
				colors[3] = FlxColor.fromRGB(144, 103, 37);

				portraitGF = new FlxSprite(780, 175);
				portraitGF.frames = Paths.getSparrowAtlas('referencezip/gfPortrait2');
				portraitGF.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitGF.animation.addByPrefix('scared', 'GF scared', 24, false);				
				//portraitExtra.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitGF.updateHitbox();
				portraitGF.scrollFactor.set();
				portraitGF.antialiasing = true;
				add(portraitGF);
				portraitGF.visible = false;

				portraitRight = new FlxSprite(780, 175);
				portraitRight.frames = Paths.getSparrowAtlas('OJ/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.animation.addByPrefix('scared', 'Boyfriend scared', 24, false);
				portraitRight.animation.addByPrefix('beat', 'bfPortrait beat', 24, false);
				portraitRight.antialiasing = true;
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

				box2 = new FlxSprite(-20, 320);
				box2.frames = Paths.getSparrowAtlas('keen/Bubble');
				box2.animation.addByPrefix('normalOpen','Bubble',24, false);
				box2.animation.addByIndices('normal','Bubble',[3],"",24);
				box2.antialiasing = true;
				box2.animation.play('normalOpen');
				box2.scale.set(1.2,0.7);
				add(box2);
				box2.screenCenter(X);
				box2.visible = false;

				box = new FlxSprite(-20, 390);
				box.frames = Paths.getSparrowAtlas('referencezip/Bubble');
				box.animation.addByPrefix('normalOpen','Bubble',24, false);
				box.animation.addByIndices('normal','Bubble',[5],"",24);
				box.antialiasing = true;
				box.animation.play('normalOpen');
				box.scale.set(0.9,0.8);
				add(box);
				box.screenCenter(X);

				colors[2] = FlxColor.fromRGB(208, 149, 53);
				colors[3] = FlxColor.fromRGB(144, 103, 37);
				colors[5] = FlxColor.fromRGB(104, 105, 108);
				colors[4] = FlxColor.BLACK;
			}
			case 'strange-comfort':{
				portraitLeft = new FlxSprite(80, 175);
				portraitLeft.frames = Paths.getSparrowAtlas('referencezip/beatPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				add(portraitLeft);
				portraitLeft.visible = false;
				
				portraitRight = new FlxSprite(590, 175);
				portraitRight.frames = Paths.getSparrowAtlas('referencezip/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.animation.addByPrefix('scared', 'Boyfriend scared', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.4));
				portraitRight.antialiasing = true;
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

				portraitGF = new FlxSprite(780, 175);
				portraitGF.frames = Paths.getSparrowAtlas('referencezip/gfPortrait2');
				portraitGF.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitGF.animation.addByPrefix('scared', 'GF scared', 24, false);				
				//portraitExtra.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitGF.updateHitbox();
				portraitGF.scrollFactor.set();
				portraitGF.antialiasing = true;
				add(portraitGF);
				portraitGF.visible = false;

				portraitExtra = new FlxSprite(800, 155);
				portraitExtra.frames = Paths.getSparrowAtlas('keen/KeenPortrait');
				portraitExtra.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitExtra.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				portraitExtra.updateHitbox();
				portraitExtra.scrollFactor.set();
				portraitExtra.antialiasing = true;
				portraitExtra.flipX = true;
				add(portraitExtra);
				portraitExtra.visible = false;

				box = new FlxSprite(-20, 390);
				box.frames = Paths.getSparrowAtlas('referencezip/Bubble');
				box.animation.addByPrefix('normalOpen','Bubble',24, false);
				box.animation.addByIndices('normal','Bubble',[5],"",24);
				box.antialiasing = true;
				box.animation.play('normalOpen');
				box.scale.set(0.9,0.8);
				add(box);
				box.screenCenter(X);

				box2 = new FlxSprite(-20, 320);
				box2.frames = Paths.getSparrowAtlas('keen/Bubble');
				box2.animation.addByPrefix('normalOpen','Bubble',24, false);
				box2.animation.addByIndices('normal','Bubble',[3],"",24);
				box2.antialiasing = true;
				box2.animation.play('normalOpen');
				box2.scale.set(1.2,0.7);
				add(box2);
				box2.screenCenter(X);
				box2.visible = false;
			}
		}

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.scale.set(6,6);
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		switch(PlayState.SONG.song.toLowerCase()){
			case 'senpai' | 'roses':
				colors[4] = 0xFF3F2021;
				colors[5] = 0xFFD89494;
			case 'imposible-posible' | 'moldy-drops' | 'six-ft-under' | 'growth' | 'exploration' | 'control' | 'strange-comfort':{
				dropText.color = FlxColor.fromRGB(76, 143, 163);
				swagDialogue.color = FlxColor.fromRGB(126, 215, 242);
				colors[4] = FlxColor.fromRGB(126, 215, 242);
				colors[5] = FlxColor.fromRGB(76, 143, 163);
			}
			case 'ugh' | 'guns' | 'stress':{
				dropText.color = FlxColor.fromRGB(76, 143, 163);
				swagDialogue.color = FlxColor.fromRGB(126, 215, 242);
				colors[5] = FlxColor.fromRGB(104, 105, 108);
				colors[4] = FlxColor.BLACK;
			}
			case 'impetus' | 'sadds' | 'csikos-post' | 'anger':
				dropText.color = FlxColor.fromRGB(76, 143, 163);
				swagDialogue.color = FlxColor.fromRGB(126, 215, 242);
		}
		originalColor = swagDialogue.color;
		dropColor = dropText.color;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		add(hint);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			flixel.tweens.FlxTween.tween(hint, {alpha: 0}, 3, {ease: flixel.tweens.FlxEase.circIn});
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if ((dialogueList[1] == null && dialogueList[0] != null) || FlxG.keys.justPressed.SPACE)
			{
				if (!isEnding)
				{
					isEnding = true;

					switch (PlayState.SONG.song.toLowerCase())
					{
						//case 'sempai' | 'thorns' | 'imposible-posible' | 'moldy-drops' | 'six-ft-under' | 'growth' | 'exploration' | 'control' | 'guns'|'ugh'|'stress':
						case 'roses':{
						
						}
						default:
							FlxG.sound.music.fadeOut(2.2, 0);
							sound.fadeOut(2.2, 0);
					}

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						background.alpha -= 1 / 5 * 0.7; //lo agregue yo
						portraitLeft.visible = false;
						portraitRight.visible = false;
						portraitExtra.visible = false;
						portraitGF.visible = false;
						PlayState.instance.dialogueBG.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						PlayState.instance.dialogueBG.visible = false;
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue(?flagSound:Bool = true):Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);
		//var flagSound:Bool = true;
		// swagDialogue.text = ;
		if(flagSound){
			swagDialogue.sounds[0].volume = 1;
		}else{
			swagDialogue.sounds[0].volume = 0;
		}

		switch (curCharacter)
		{
			case 'playSound':
				playSound(dialogueList[0]);
			case 'pauseMusic':
				FlxG.sound.music.pause();
				dialogueList.remove(dialogueList[0]);
				startDialogue(false);
			case 'resumeMusic':
				FlxG.sound.music.play();
				dialogueList.remove(dialogueList[0]);
				startDialogue(false);
			case 'music':
				playSound(dialogueList[0],true);
			case 'noSound':
				dialogueList.remove(dialogueList[0]);
				startDialogue(false);
		}
		swagDialogue.resetText(dialogueList[0]);

		switch(splitBack){
			case 'none':
			background.visible = false;
			bgFade.visible = true;
			case 'hide':
			PlayState.instance.dialogueBG.visible = false;
			bgFade.visible = true;
			case 'noSound':
				swagDialogue.sounds[0].volume = 0;
				flagSound = false;
		}
		if(!r.match(splitBack)){
			if(background.members.length > 0 && splitBack.length > 0){
				var id = Std.parseInt(splitBack) -1;
				if(BGid != -1){
					background.members[BGid].visible = false;
				}
				if(id >= 0 && id < background.members.length){
					bgFade.visible = false;
					background.members[id].visible = true;
					background.visible = true;
					BGid = id;
				}
			}
		}

		if(curCharacter == 'skip'){
			dialogueList.remove(dialogueList[0]);
			startDialogue(false);
		}
		if(!swagDialogue.visible){
			swagDialogue.visible = true;
			dropText.visible = true;
		}

		swagDialogue.start(0.04, true);
		swagDialogue.color = originalColor;
		dropText.color = dropColor;

		if(defaultBubble){
			box.flipX = false;
		}

		portraitRight.visible = false;
		portraitExtra.visible = false;
		portraitLeft.visible = false;
		portraitGF.visible = false;

		switch (curCharacter)
		{
			case 'dad' | 'dad2':
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					if(curCharacter == "dad2")
						portraitLeft.animation.play('anger');
					else
						portraitLeft.animation.play('enter');
					box.visible = true;
					if(box2 != null)
						box2.visible = false;
					if(defaultBubble){
						box.flipX = true;
					}
					swagDialogue.color = colors[4];
					dropText.color = colors[5];
				}
			case 'bf' | 'bf2' | 'bf3' | 'bf0':
				if (!portraitRight.visible)
				{
					if(curCharacter != 'bf0')
						portraitRight.visible = true;
					switch(curCharacter){
						case 'bf2':
							portraitRight.animation.play('scared');
						case 'bf3':
							portraitRight.animation.play('beat');
						default:
							portraitRight.animation.play('enter');
					}
					box.visible = true;
					if(box2 != null)
						box2.visible = false;
					
				}
			case 'extra'|'extra0':
				if (!portraitExtra.visible){
					if(curCharacter == "extra"){
						portraitExtra.visible = true;
						portraitExtra.animation.play('enter');
					}
					if(box2 != null){
						box2.visible = true;
						box.visible = false;
					}
				}
				swagDialogue.color = colors[2];
				dropText.color = colors[3];
			case 'gf'|'gf2':
				if (!portraitGF.visible)
				{
					portraitGF.visible = true;
					if(curCharacter == "gf2"){
						portraitGF.animation.play('scared');
					}else{
						portraitGF.animation.play('enter');
					}
					box.visible = true;
					if(box2 != null)
						box2.visible = false;
				}
				swagDialogue.color = colors[0];
				dropText.color = colors[1];
			case 'none':
				swagDialogue.sounds[0].volume = 0;
				swagDialogue.visible = false;
				box2.visible = false;
				box.visible = false;
				dropText.visible = false;
			default:
				box.visible = true;
				if(box2 != null)
					box2.visible = false;
				if(defaultBubble){
					box.flipX = true;
				}
				swagDialogue.color = colors[4];
				dropText.color = colors[5];
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		if(splitName[1].split("/").length > 1){
			splitBack = splitName[1].split("/")[1];
			curCharacter = splitName[1].split("/")[0];
		}
		else
			curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
		trace(curCharacter + "|" + splitBack + " legth: " + splitBack.length);
	}

	function playSound(path:String, ?asMusic:Bool = false):Void{
		if(asMusic){
			FlxG.sound.music.fadeOut(1, 0, function(flxTween:flixel.tweens.FlxTween){
				FlxG.sound.playMusic(openfl.media.Sound.fromFile("assets/shared/music/" + path + ".ogg"), 0, true);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			});
		}else{
			sound.loadEmbedded(openfl.media.Sound.fromFile("assets/shared/sounds/" + path + ".ogg"));
			sound.play(true);
		}
		dialogueList.remove(dialogueList[0]);
		startDialogue(false);
	}

	public function hideBlueBG():Void{
		bgFade.visible = false;
	}
}
