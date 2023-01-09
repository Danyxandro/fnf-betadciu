package;

import webm.WebmPlayer;
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import Replay.Ana;
import Replay.Analysis;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	public var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public var originalX:Float;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	public var cam3:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	public var botPlayState:FlxText;
	// Replay shit
	//private var saveNotes:Array<Dynamic> = [];
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	private var executeModchart = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }

	//Variables que puse yo
	public var bg2:FlxSprite = new FlxSprite();
	private var bump:Bool = true;
	private var flag:Bool = true;
	private var animIcon1:String = "";
	private var animIcon2:String = "";
	public var animatedIcons:Map<String,HealthIcon> = new Map<String,HealthIcon>();
	private var animatedIconList:Array<String> = ["daidem"];
	public var layerIcons:FlxTypedGroup<HealthIcon> = new FlxTypedGroup<HealthIcon>();
	private var fase = 0;
	private var floats:Array<Float> = [0,0,0,1,0,0];
	private var picoJson:Array<SwagSection> = [{sectionNotes: [], lengthInSteps: 16, mustHitSection: false, changeBPM: false, bpm: 120, altAnim: false, typeOfSection: 0}];
	public var dificultad:Int = 1;
	public var layerChars:FlxTypedGroup<Character> = new FlxTypedGroup<Character>();
	public var layerBFs:FlxTypedGroup<Boyfriend> = new FlxTypedGroup<Boyfriend>();
	public var layerGF:FlxTypedGroup<Character> = new FlxTypedGroup<Character>();
	public var dadID:Int = 0;
	public var bfID:Int = 0;
	public var ghostTapping:Bool;
	public var style1:String = "normal";
	public var style2:String = "normal";
	public var layerBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public var trailDad:FlxTrail;
	public var dialogueBG:FlxSprite = new FlxSprite();

	public var dialogueFinal:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	private var doof2:DialogueEnd;
	public var mustHitSection:Bool = true;
	private var charCam:Array<Int> = [0,0,0,0];
	public var camFactor:Float = 35;
	private var posiciones:Array<Float> = [0,0];
	private var moveCam:Bool = false;
	public var goldAnim:Array<String> = ['singHey','singHey'];
	public var healthValues:Map<String,Dynamic> = [
		/*"shit" => -0.2,
		"bad" => -0.06,
		"good" => 0.04,
		"sick" => 0.1,
		"miss" => -0.25,
		"missPressed" => -0.075,
		"missLN" => -0.08,
		"type1" => -2,
		"type2" => -0.2,
		"type3" => -0.3,
		"type4" => 0.14,
		"type4miss" => -0.3,
		"type5miss" => -1*/
	]; //Original values. Valor original del miss es de -.075
	public var health2:Map<String,Dynamic> = new Map<String,Dynamic>();
	private var barColors:Array<FlxColor> = [0xFFFF0000, 0xFF66FF33];
	public var colorsMap:Map<String,FlxColor> = [];
	private var musica:FlxSoundAsset;
	public static var stateSwitch = {state:"freeplay",id:0,allowChanging:true,usedBotplay:false}; //codigo importante aqui XDDDD

	override public function create()
	{
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		repPresses = 0;
		repReleases = 0;


		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		stateSwitch.usedBotplay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;
		PlayStateChangeables.singCam = FlxG.save.data.singCam;
		ghostTapping = FlxG.save.data.ghost;
		if(stateSwitch.allowChanging)
			PlayStateChangeables.allowCharChange = FlxG.save.data.enableCharchange;
		else
			PlayStateChangeables.allowCharChange = false;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		
		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		var map:Map<String,Dynamic> = FlxG.save.data.healthValues;
		var map2:Map<String,Dynamic>;
		var map3:Map<String,Dynamic>;
		for (key in map.keys()){
			if(key != "missPressed"){
				healthValues.set(key,new Map<String,Dynamic>());
				map2 = map.get(key);
				for(key2 in map2.keys()){
					map3 = map2.get(key2);
					if(key2 != "damage"){
						var aux:Map<String,Dynamic> = [
							for(key3 in map3.keys())
								key3 => map3[key3]
						];
						healthValues[key].set(key2,aux);
					}else{
						healthValues[key].set(key2,map[key].get("damage"));
					}
				}
			}else{
				healthValues.set(key,map.get("missPressed"));
			}
			//healthValues.set(key,map.get(key).copy());
		}
		setHealthValues(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		//Esto lo puse yo
		dificultad = storyDifficulty;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		cam3 = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		cam3.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(cam3);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'imposible-posible':
				dialogue = CoolUtil.coolTextFile(Paths.txt('imposible-posible/text1'));
			case 'moldy-drops':
				dialogue = CoolUtil.coolTextFile(Paths.txt('moldy-drops/text2'));
			case 'six-ft-under':
				dialogue = CoolUtil.coolTextFile(Paths.txt('six-ft-under/text3'));
				dialogueFinal = CoolUtil.coolTextFile(Paths.txt('six-ft-under/test'));
				if(!FlxG.save.data.unlocks[0]){
					var append:Array<String> = CoolUtil.coolTextFile(Paths.txt('six-ft-under/append'));
					for(line in append){
						dialogueFinal.push(line);
					}
				}
			case 'growth' | 'exploration':
				dialogue = CoolUtil.coolTextFile(Paths.txt(songLowercase + '/dialogueText'));
			case 'control':
				dialogue = CoolUtil.coolTextFile(Paths.txt(songLowercase + '/dialogueText'));
				dialogueFinal = CoolUtil.coolTextFile(Paths.txt('control/dialogueEnd'));
				if(!FlxG.save.data.unlocks[1]){
					var append:Array<String> = CoolUtil.coolTextFile(Paths.txt('six-ft-under/append'));
					for(line in append){
						dialogueFinal.push(line);
					}
				}
			case 'ugh' | 'guns' | 'stress':
				dialogue = CoolUtil.coolTextFile(Paths.txt(songLowercase + '/dialogueText'));
			case 'impetus' | 'sadds' | 'csikos-post' | 'anger':
				dialogue = CoolUtil.coolTextFile(Paths.txt(songLowercase + '/dialogue'));
			case 'strange-comfort':
				dialogue = CoolUtil.coolTextFile(Paths.txt(songLowercase + '/dialogueText'));
				dialogueFinal = CoolUtil.coolTextFile(Paths.txt(songLowercase + '/dialogueEnd'));
				if(!FlxG.save.data.unlocks[2]){
					var append:Array<String> = CoolUtil.coolTextFile(Paths.txt('strange-comfort/append'));
					for(line in append){
						dialogueFinal.push(line);
					}
				}
		}

		//defaults if no stage was found in chart
		var stageCheck:String = 'stage';
		
		if (SONG.stage == null) {
			switch(storyWeek)
			{
				case 2: stageCheck = 'halloween';
				case 3: stageCheck = 'philly';
				case 4: stageCheck = 'limo';
				case 5: if (songLowercase == 'winter-horrorland') {stageCheck = 'mallEvil';} else {stageCheck = 'mall';}
				case 6: if (songLowercase == 'thorns') {stageCheck = 'schoolEvil';} else {stageCheck = 'school';}
				case 7: stageCheck = 'newgrounds';
				case 8: if(songLowercase == 'six-ft-under') {stageCheck = 'referencezip_neon';} else {stageCheck = 'referencezip';}
				case 9: if(songLowercase == 'control') {stageCheck = 'cliff-night';} else {stageCheck = 'cliff';}
				//i should check if its stage (but this is when none is found in chart anyway)
			}
		} else {stageCheck = SONG.stage;}

		if (!PlayStateChangeables.Optimize)
		{
		switch(stageCheck)
		{
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}
			case 'school':
			{
					curStage = 'school';

					camFactor = 0;

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					camFactor = 0;

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'referencezip':
			{
					defaultCamZoom = 0.9;
					curStage = 'referencezip';
					var bg:FlxSprite = new FlxSprite(-500, -175).loadGraphic(Paths.image('referencezip/twilight'));
					bg.setGraphicSize(Std.int(bg.width * 0.9));
					bg.updateHitbox();
					bg.antialiasing = true;
					bg.scrollFactor.set(0, 0);
					//bg.active = false;
					add(bg);

					var stageMid:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('referencezip/landscape'));
					stageMid.setGraphicSize(Std.int(stageMid.width * 0.9));
					stageMid.updateHitbox();
					stageMid.antialiasing = true;
					stageMid.scrollFactor.set(0.7, 0.7);
					//stageMid.active = false;
					add(stageMid);

					var stageFront:FlxSprite = new FlxSprite(-500, 550);
					stageFront.frames = Paths.getSparrowAtlas('referencezip/floor');
					stageFront.animation.addByPrefix('idle', 'Suelo instancia 1', 24, true);
					stageFront.animation.play('idle');
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.scale.set(1,1);
					stageFront.antialiasing = true;
					add(stageFront);
			}
			case 'referencezip_neon':
			{
				defaultCamZoom = 0.9;
					curStage = 'referencezip_neon';
					SONG.gfVersion = 'gf-neon';
					var bg:FlxSprite = new FlxSprite(-600, -130).loadGraphic(Paths.image('referencezip/night'));
					bg.setGraphicSize(Std.int(bg.width * 0.9));
					bg.updateHitbox();
					bg.antialiasing = true;
					bg.scrollFactor.set(0, 0);
					//bg.active = false;
					add(bg);

					var stageMid:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('referencezip/landscapedark'));
					stageMid.setGraphicSize(Std.int(stageMid.width * 0.9));
					stageMid.updateHitbox();
					stageMid.antialiasing = true;
					stageMid.scrollFactor.set(0.7, 0.7);
					//stageMid.active = false;
					add(stageMid);

					var stageFront:FlxSprite = new FlxSprite(-500, 550);
					stageFront.frames = Paths.getSparrowAtlas('referencezip/SueloNegro');
					stageFront.animation.addByPrefix('idle', 'SueloNegro', 24, true);
					stageFront.animation.play('idle');
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.scale.set(1,1);
					add(stageFront);
			}
			case 'cliff':
			{
				defaultCamZoom = 0.9;
				curStage = 'cliff';
					var bg:FlxSprite = new FlxSprite(-100, -130).loadGraphic(Paths.image('keen/Sky'));
					bg.setGraphicSize(Std.int(bg.width * 0.7));
					bg.updateHitbox();
					bg.antialiasing = true;
					bg.scrollFactor.set(0, 0);
					//bg.active = false;
					add(bg);

					bg2 = new FlxSprite(-100, -130).loadGraphic(Paths.image('keen/black'));
					bg2.setGraphicSize(Std.int(bg2.width * 0.7));
					bg2.updateHitbox();
					bg2.antialiasing = false;
					bg2.scrollFactor.set(0, 0);
					bg2.visible = false;
					//bg.active = false;

					var stageMid:FlxSprite = new FlxSprite(-250, -105).loadGraphic(Paths.image('keen/Spikes'));
					stageMid.setGraphicSize(Std.int(stageMid.width * 0.7));
					stageMid.updateHitbox();
					stageMid.antialiasing = true;
					stageMid.scrollFactor.set(0.5, 0.5);
					//stageMid.active = false;
					add(stageMid);

					var stageMid2:FlxSprite = new FlxSprite(-250, -250).loadGraphic(Paths.image('keen/Spikes2'));
					stageMid2.setGraphicSize(Std.int(stageMid2.width * 0.9));
					stageMid2.updateHitbox();
					stageMid2.antialiasing = true;
					stageMid2.scrollFactor.set(0.7, 0.7);
					//stageMid.active = false;
					add(stageMid2);

					add(bg2);

					var ant:FlxSprite = new FlxSprite(60, 290).loadGraphic(Paths.image('keen/antena'));
					ant.setGraphicSize(Std.int(ant.width * 0.9));
					ant.updateHitbox();
					ant.antialiasing = true;
					ant.scrollFactor.set(0.8, 0.8);
					//stageMid.active = false;
					add(ant);

					var stageFront:FlxSprite = new FlxSprite(-150, 650).loadGraphic(Paths.image('keen/cliff'));
					stageFront.setGraphicSize(Std.int(stageMid.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(1,1);
					add(stageFront);

					var beat:Character = new Character(600,430, "beat", true);
					beat.setGraphicSize(Std.int(beat.width * 0.8) );
					add(beat);
					/*var stageBeat:FlxSprite = new FlxSprite(580, -90);
					stageBeat.frames = Paths.getSparrowAtlas('keen/Beat');
					stageBeat.animation.addByPrefix('idle', 'Beat instancia 1', 24, true);
					stageBeat.animation.play('idle');
					stageBeat.scrollFactor.set(1,1);
					stageBeat.scale.set(0.8,0.8);
					stageBeat.antialiasing = true;
					add(stageBeat);*/

			}
			case 'cliff-night':
			{
				defaultCamZoom = 0.75;
				curStage = 'cliff-night';
					var bg:FlxSprite = new FlxSprite(-250, -130).loadGraphic(Paths.image('keen/outerspace'));
					bg.setGraphicSize(Std.int(bg.width * 0.7));
					bg.updateHitbox();
					bg.antialiasing = true;
					bg.scrollFactor.set(0, 0);
					//bg.active = false;
					add(bg);

					var stageMid:FlxSprite = new FlxSprite(-360, -205).loadGraphic(Paths.image('keen/SpikeNight2'));
					stageMid.setGraphicSize(Std.int(stageMid.width * 0.85));
					stageMid.updateHitbox();
					stageMid.antialiasing = true;
					stageMid.scrollFactor.set(0.5, 0.5);
					//stageMid.active = false;
					add(stageMid);

					var stageMid2:FlxSprite = new FlxSprite(-400, -250).loadGraphic(Paths.image('keen/SpikeNight'));
					stageMid2.setGraphicSize(Std.int(stageMid2.width * 0.9));
					stageMid2.updateHitbox();
					stageMid2.antialiasing = true;
					stageMid2.scrollFactor.set(0.7, 0.7);
					//stageMid.active = false;
					add(stageMid2);

					bg2 = new FlxSprite(-270, -230).loadGraphic(Paths.image('keen/black'));
					bg2.setGraphicSize(Std.int(bg2.width * 1.1));
					bg2.updateHitbox();
					bg2.antialiasing = false;
					bg2.scrollFactor.set(0, 0);
					bg2.visible = false;
					add(bg2);

					var ant:FlxSprite = new FlxSprite(-90, 290).loadGraphic(Paths.image('keen/antenaN'));
					ant.setGraphicSize(Std.int(ant.width * 0.9));
					ant.updateHitbox();
					ant.antialiasing = true;
					ant.scrollFactor.set(0.8, 0.8);
					add(ant);

					var stageFront:FlxSprite = new FlxSprite(350, 650).loadGraphic(Paths.image('keen/cliffN'));
					stageFront.setGraphicSize(Std.int(stageMid.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(1,1);
					add(stageFront);

					var beat:Character = new Character(700,430, "beat", true);
					beat.setGraphicSize(Std.int(beat.width * 0.8) );
					add(beat);

					/*var stageBeat:FlxSprite = new FlxSprite(780, -90);
					stageBeat.frames = Paths.getSparrowAtlas('keen/Beat');
					stageBeat.animation.addByPrefix('idle', 'Beat instancia 1', 24, true);
					stageBeat.animation.play('idle');
					stageBeat.scrollFactor.set(1,1);
					stageBeat.scale.set(0.8,0.8);
					stageBeat.antialiasing = true;
					add(stageBeat);*/
			}
			case 'newgrounds':
			{
				defaultCamZoom = 0.9;
				curStage = 'newgrounds';
				if(songLowercase == 'stress'){
					//picoJson = cast Json.parse( Assets.getText( Paths.json('stress/pico-speaker') ).trim() ).song.notes;
					curStage = 'newgrounds2';
					//SONG.gfVersion = 'pico-speaker';
				}
				floats = [FlxG.random.float(-90, 45), FlxG.random.float(7, 9), 400, 1, 0, 0];
				var johns;
				var tower;
				//var losers;
				trace(" : )");
				var bg = new FlxSprite(-400, -400).loadGraphic(Paths.image('tankman/tankSky'));
				bg.scrollFactor.set();
				bg.antialiasing = true;
				add(bg);

				var clouds = new FlxSprite(FlxG.random.int(-700, -100), FlxG.random.int(-20, 20)).loadGraphic(Paths.image('tankman/tankClouds'));

				clouds.antialiasing = true;
				clouds.scrollFactor.set(0.1, 0.1);
				clouds.velocity.x = FlxG.random.float(5,15);
				add(clouds);
				var mountains = new FlxSprite(-300, -20).loadGraphic(Paths.image('tankman/tankMountains'));
				mountains.antialiasing = true;
				mountains.setGraphicSize(Std.int(mountains.width * 1.2));
				mountains.updateHitbox();
				mountains.scrollFactor.set(0.2, 0.2);
				add(mountains);
				var building = new FlxSprite(-275).loadGraphic(Paths.image('tankman/tankBuildings'));
				building.setGraphicSize(Std.int(building.width * 1.4));
				building.antialiasing = true;
				building.updateHitbox();
				building.scrollFactor.set(0.3, 0.3);
				add(building);
				var ruins = new FlxSprite(-275).loadGraphic(Paths.image('tankman/tankRuins'));
				ruins.scrollFactor.set(0.35, 0.35);
				ruins.setGraphicSize(Std.int(1.4 * ruins.width));
				ruins.updateHitbox();
				ruins.antialiasing = true;
				add(ruins);
				var smokeLeft = new FlxSprite(-200 , -100);
				smokeLeft.frames = Paths.getSparrowAtlas('tankman/smokeLeft');
				smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft', 24, true);
				smokeLeft.animation.play('idle', true);
				smokeLeft.scrollFactor.set(0.4, 0.4);
				smokeLeft.antialiasing = true;
				add(smokeLeft);


				trace(":weary:");
				var smokeRight = new FlxSprite(1100, -100);
				smokeRight.frames = Paths.getSparrowAtlas('tankman/smokeRight');
				smokeRight.animation.addByPrefix('idle', 'SmokeRight', 24, true);
				smokeRight.animation.play('idle', true);
				smokeRight.scrollFactor.set(0.4, 0.4);
				smokeRight.antialiasing = true;
				add(smokeRight);
				trace(":hueh:");
				tower = new FlxSprite(100, 50);
				trace("WAH tower");
				tower.frames = Paths.getSparrowAtlas('tankman/tankWatchtower');
				trace("RED ALERT: ioajfha");
				tower.animation.addByPrefix('idle', 'watchtower gradient color', 24, true);
				tower.animation.play('idle', true);
				trace("eugh");
				tower.scrollFactor.set(0.5, 0.5);
				tower.updateHitbox();
				tower.antialiasing = true;
				add(tower);
				trace(":pensive:");
				//bg2 is Steve, el tanquee rotando
				bg2 = new FlxSprite(300, 300);
				bg2.frames = Paths.getSparrowAtlas('tankman/tankRolling');
				bg2.animation.addByPrefix('idle', "BG tank w lighting", 24, true);
				bg2.animation.play('idle', true);
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.5, 0.5);
				add(bg2);

				// note to gamers, type classes don't work
				trace("before johnathan");
				johns = new flixel.group.FlxGroup();
				add(johns);
				var ground = new FlxSprite(-420, -150).loadGraphic(Paths.image('tankman/tankGround'));
				ground.setGraphicSize(Std.int(1.15 * ground.width));
				ground.updateHitbox();
				ground.antialiasing = true;
				add(ground);
				
			}
			case 'none'|'custom':
			{
				curStage = stageCheck.toLowerCase();
			}
			case 'portal'|"portal2"|'portal1'|'portal3':
			{
				defaultCamZoom = 0.55;
				curStage = stageCheck;
				var antena:FlxSprite;
				var antena2:FlxSprite;
				var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("keen/outerspace"));
				bg.scrollFactor.set(0,0);
				bg.scale.set(2,2);
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.x = -550;
				bg.y = -520;
				add(bg);

				bg = new FlxSprite().loadGraphic(Paths.image("keen/SpikeNight2"));
				bg.scrollFactor.set(0.5,0.5);
				bg.scale.set(1.65,1.65);
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.x = -1000;
				bg.y = -1100;
				add(bg);

				var piso:FlxSprite = new FlxSprite().loadGraphic(Paths.image("OJ/floor"));
				piso.scrollFactor.set(1,1);
				piso.scale.set(1.8,1.8);
				piso.updateHitbox();
				piso.antialiasing = true;
				piso.x = -800;
				piso.y = 150;
				add(piso);

				switch(stageCheck){
					case 'portal1':
						var node:FlxSprite = new FlxSprite().loadGraphic(Paths.image("OJ/antena1.5"));
						node.scrollFactor.set(1,1);
						node.scale.set(0.4,0.4);
						node.updateHitbox();
						node.antialiasing = true;
						node.x = 1000;
						node.y = -600;
						add(node);
					default:
						var node:FlxSprite = new FlxSprite().loadGraphic(Paths.image("OJ/antena"));
						node.scrollFactor.set(1,1);
						node.scale.set(0.4,0.4);
						node.updateHitbox();
						node.antialiasing = true;
						node.x = 1000;
						node.y = -600;
						add(node);
					case 'portal3':
						var node:FlxSprite = new FlxSprite().loadGraphic(Paths.image("OJ/antena1b"));
						node.scrollFactor.set(1,1);
						node.scale.set(0.4,0.4);
						node.updateHitbox();
						node.antialiasing = true;
						node.x = 1000;
						node.y = -600;
						add(node);
				}

				if(stageCheck == "portal" || stageCheck == "portal1"){
					antena = new FlxSprite().loadGraphic(Paths.image("OJ/antena2"));
					antena.scrollFactor.set(1,1);
					antena.scale.set(0.5,0.5);
					antena.updateHitbox();
					antena.antialiasing = true;
					antena.x = -700;
					antena.y = -1450;
					add(antena);

					antena2 = new FlxSprite().loadGraphic(Paths.image("OJ/antena2"));
					antena2.scrollFactor.set(1,1);
					antena2.scale.set(0.5,0.5);
					antena2.updateHitbox();
					antena2.antialiasing = true;
					antena2.flipX = true;
					antena2.x = 300;
					antena2.y = -1450;
					add(antena2);
				}

				if(stageCheck == "portal2" || stageCheck == "portal3"){
					var portal = new FlxSprite().loadGraphic(Paths.image("OJ/portal"));
					portal.frames = Paths.getSparrowAtlas("OJ/portal");
					portal.animation.addByPrefix('idle', "portal idle0", 20, true);
					portal.animation.play('idle', true);
					portal.scrollFactor.set(0.6,0.85);
					portal.scale.set(2.5,2.5);
					portal.updateHitbox();
					portal.x = -400;
					portal.y = -800;
					add(portal);

					antena = new FlxSprite();
					antena.frames = Paths.getSparrowAtlas("OJ/beam");
					antena.animation.addByPrefix('idle', "beam instancia 0", 24, true);
					antena.animation.play('idle', true);
					antena.scrollFactor.set(1,1);
					antena.scale.set(1.7,1.7);
					antena.updateHitbox();
					antena.antialiasing = true;
					antena.x = -700;
					antena.y = -1550;
					add(antena);

					antena2 = new FlxSprite();
					antena2.frames = Paths.getSparrowAtlas("OJ/beam");
					antena2.animation.addByPrefix('idle', "beam instancia 0", 24, true);
					antena2.animation.play('idle', true);
					antena2.scrollFactor.set(1,1);
					antena2.scale.set(1.7,1.7);
					antena2.updateHitbox();
					antena2.antialiasing = true;
					antena2.flipX = true;
					antena2.x = 200;
					antena2.y = -1550;
					add(antena2);
				}

				upperBoppers = new FlxSprite();
				if(stageCheck != "portal3"){
					upperBoppers.frames = Paths.getSparrowAtlas("OJ/YunSallyKinu");
					upperBoppers.animation.addByPrefix("bop","YunSallyKinu0",24,false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(1,1);
					upperBoppers.scale.set(1.65,1.65);
					upperBoppers.updateHitbox();
					upperBoppers.x = -750;
					upperBoppers.y = -450;
					upperBoppers.animation.play("bop");
					add(upperBoppers);
				}

				if(stageCheck == 'portal1'){
					var letrero:FlxSprite = new FlxSprite();
					letrero.frames = Paths.getSparrowAtlas("OJ/letrero");
					letrero.animation.addByPrefix("bop","Letrero instancia 1",24,true);
					letrero.antialiasing = true;
					letrero.scrollFactor.set(1,1);
					//letrero.scale.set(1,1.65);
					letrero.updateHitbox();
					letrero.x = 550;
					letrero.y = 330;
					letrero.animation.play("bop");
					add(letrero);
				}

					/*for(ar in datos){
						if(ar[5]==false){
							var sprite:FlxSprite = new FlxSprite();
							sprite.frames = Paths.getSparrowAtlas(ar[0]);
							sprite.animation.addByPrefix('idle', ar[6], ar[7], true);
							sprite.animation.play('idle', true);
							sprite.antialiasing = true;
							sprite.scrollFactor.set(ar[4],ar[4]);
							sprite.scale.set(ar[3],ar[3]);
							sprite.updateHitbox();
							sprite.x = ar[1];
							sprite.y = ar[2];
							add(sprite);
						}
					}*/

			}
			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
			case '8th-layer':
			{	
				var datos = cast Json.parse( Assets.getText( Paths.json('stageCoords') ).trim() );
				var cosas:Array<Dynamic> = datos.bgs;
				curStage = '8th-layer';
				defaultCamZoom = 0.8;
				var whiteBox:FlxSprite = new FlxSprite(-200,-300).makeGraphic(FlxG.width+200, FlxG.height+600, FlxColor.WHITE);
				whiteBox.scale.set(1.5,1.5);
				whiteBox.scrollFactor.set(0,0);
				add(whiteBox);

				upperBoppers = new FlxSprite();
				upperBoppers.frames = Paths.getSparrowAtlas("OJ/watchers");
				upperBoppers.animation.addByPrefix("bop","crowd bump0",24,false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.5,0.9);
				upperBoppers.scale.set(0.9,0.9);
				upperBoppers.updateHitbox();
				upperBoppers.x = -200;
				upperBoppers.y = -500;
				upperBoppers.animation.play("bop");
				add(upperBoppers);

				var floor:FlxSprite = new FlxSprite();
				floor.frames = Paths.getSparrowAtlas("OJ/floorGlitch");
				floor.animation.addByPrefix('idle',"floorGlitch0", 24, true);
				floor.animation.play('idle', true);
				floor.antialiasing = true;
				floor.scrollFactor.set(1,1);
				floor.scale.set(1.9,1.9);
				floor.updateHitbox();
				floor.x = -300;
				floor.y = 170;
				add(floor);

				var sprite:FlxSprite = new FlxSprite();
				sprite.frames = Paths.getSparrowAtlas("OJ/static");
				sprite.animation.addByPrefix('idle',"static", 24, true);
				sprite.animation.play('idle', true);
				sprite.antialiasing = true;
				sprite.scrollFactor.set(0,0);
				sprite.scale.set(3.42,3.42);
				sprite.updateHitbox();
				sprite.x = -199;
				sprite.y = -200;
				sprite.alpha = 0.55;
				add(sprite);

				/*for(ar in cosas){
					var sprite:FlxSprite = new FlxSprite();
					sprite.frames = Paths.getSparrowAtlas(ar[0]);
					sprite.animation.addByPrefix('idle', ar[6], ar[7], true);
					sprite.animation.play('idle', true);
					sprite.antialiasing = true;
					sprite.scrollFactor.set(ar[4],ar[4]);
					sprite.scale.set(ar[3],ar[3]);
					sprite.updateHitbox();
					sprite.x = ar[1];
					sprite.y = ar[2];
					sprite.alpha = ar[5];
					add(sprite);
				}*/
			}
			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
		}else{
		FlxG.save.data.distractions = false;
		switch(stageCheck)
		{
			case 'halloween': 
				curStage = 'spooky';
			case 'philly': 
					curStage = 'philly';
			case 'limo':
				curStage = 'limo';
			case 'mall':
				curStage = 'mall';
			case 'mallEvil':
				curStage = 'mallEvil';
			case 'school':
				curStage = 'school';
			case 'schoolEvil':
				curStage = 'schoolEvil';
			case 'referencezip':
					curStage = 'referencezip';
			case 'referencezip_neon':
					curStage = 'referencezip_neon';
			case 'cliff':
				curStage = 'cliff';
					
			case 'cliff-night':
				curStage = 'cliff-night';
					
			case 'newgrounds':
				defaultCamZoom = 0.9;
				curStage = 'newgrounds';
				if(songLowercase == 'stress'){
					//picoJson = cast Json.parse( Assets.getText( Paths.json('stress/pico-speaker') ).trim() ).song.notes;
					curStage = 'newgrounds2';
					//SONG.gfVersion = 'pico-speaker';
				}
				floats = [FlxG.random.float(-90, 45), FlxG.random.float(7, 9), 400, 1, 0, 0];

				bg2 = new FlxSprite(300, 300);
				bg2.frames = Paths.getSparrowAtlas('tankman/tankRolling');
				bg2.animation.addByPrefix('idle', "BG tank w lighting", 24, true);
				bg2.animation.play('idle', true);
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.5, 0.5);
			case 'none'|'custom':
			{
				curStage = stageCheck.toLowerCase();
			}
			case 'portal'|"portal2"|'portal1'|'portal3':
			{
				curStage = stageCheck;				
			}
			case 'stage':
				curStage = 'stage';
			case '8th-layer':
				curStage = '8th-layer';
			default:
				curStage = 'stage';
		}
		} //fin del if de Optimize

		//defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null) {
			switch(storyWeek)
			{
				case 4: gfCheck = 'gf-car';
				case 5: gfCheck = 'gf-christmas';
				case 6: gfCheck = 'gf-pixel';
				case 7: 
					gfCheck = 'gf-guns';
					if(songLowercase == 'stress')
						gfCheck = 'pico-speaker';
				case 9: gfCheck = 'gf-alt';
			}
		} else {gfCheck = SONG.gfVersion;}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			case 'gf-neon' | 'gf-guns' | 'pico-speaker' | 'gf-alt' | 'speakers':
				curGf = gfCheck;
			default:
				curGf = 'gf';
		}

		gf = new Character(400, 130, curGf);
		gf.scrollFactor.set(0.95, 0.95);

		switch(songLowercase){
			case "impetus":
				SONG.player2 = "keen-inverted";
				SONG.player1 = "OJ";
			case "stress":
				picoJson = cast Json.parse( Assets.getText( Paths.json('stress/pico-speaker') ).trim() ).song.notes;
				SONG.gfVersion = 'pico-speaker';
		}

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'beat' | 'beat-neon':
				camPos.x=700;
				camPos.y=300;
			case 'keen-flying':
				camPos.x += 250;
			
		}
		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions){
				// trailArea.scrollFactor.set();
				//var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				//add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				}


				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'cliff-night':
				boyfriend.x += 100;
				gf.x += 100;
			case 'newgrounds':
				boyfriend.x += 100;
				gf.x -= 100;
				gf.y -= 50;
				dad.x -= 100;
				//if(songLowercase == 'merp')
					//dad.y += 30;
			case 'newgrounds2':
				gf.x -= 100;
				boyfriend.x += 100;
				dad.x -= 100;
			case 'none' | 'custom':
				camPos.x=700;
				camPos.y=300;
			case 'portal'|'portal1'|'portal2'|'portal3':
				camPos.x=700;
				camPos.y=300;
			case '8th-layer':
				camPos.x=700;
				camPos.y=300;
		}

		if (!PlayStateChangeables.Optimize)
		{
		layerGF.add(gf);
		add(layerGF);

		// Shitty layering but whatev it works LOL
		switch(curStage){
			case 'limo':
				add(limo);
			case '8th-layer':
				/*trailDad = new FlxTrailArea(-300,-500,FlxG.width+600,FlxG.height+1000,0.5,18,false,false);
				trailDad.alpha = 0.8;
				trailDad.add(dad);*/
				trailDad = new FlxTrail(dad, null, 6, 36, 0.3, 0.069);
				//dad.animation.getByName("idle").frameRate /= 4;
				dad.animation.add('idle',dad.animation.getByName("idle").frames,dad.animation.getByName("idle").frameRate / 2,false);
				//dad.animation.add("idle", dad.animation.getByName('idle').frames,24,true);
				//evilTrail.changeGraphic(dad.graphic);
				gf.alpha = 0;
				trailDad.velocity.x = 200;
				add(trailDad);
			case 'schoolEvil':
				trailDad = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				dad.animation.add('idle',dad.animation.getByName("idle").frames,dad.animation.getByName("idle").frameRate / 2,false);
				add(trailDad);
			case 'portal1':
				gf.alpha = 0;
		}
		layerChars.add(dad);
		layerBFs.add(boyfriend);
		add(layerChars);
		add(layerBFs);

		if(PlayStateChangeables.singCam){
			posiciones[0] = layerBFs.members[bfID].getMidpoint().y + 300;
			posiciones[1] = layerChars.members[dadID].getMidpoint().y - 100;
		}

		switch(SONG.stage){
				case 'newgrounds' | 'newgrounds2':
					var losers = new flixel.group.FlxGroup();
					var tank0 = new FlxSprite(-500, 650);
					tank0.frames = Paths.getSparrowAtlas('tankman/tank0');
					tank0.antialiasing = true;
					tank0.animation.addByPrefix("idle", "fg", 24, true);
					tank0.scrollFactor.set(1.7, 1.5);
					tank0.animation.play("idle");
					losers.add(tank0);

					var tank1 = new FlxSprite(-300, 750);
					tank1.frames = Paths.getSparrowAtlas('tankman/tank1');
					tank1.antialiasing = true;
					tank1.animation.addByPrefix("idle", "fg", 24, true);
					tank1.scrollFactor.set(2, 0.2);
					tank1.animation.play("idle");
					losers.add(tank1);

					var tank2 = new FlxSprite(450, 940);
					tank2.frames = Paths.getSparrowAtlas('tankman/tank2');
					tank2.antialiasing = true;
					tank2.animation.addByPrefix("idle", "foreground", 24, true);
					tank2.scrollFactor.set(1.5, 1.5);
					tank2.animation.play("idle");
					losers.add(tank2);

					var tank4 = new FlxSprite(1300, 900);
					tank4.frames = Paths.getSparrowAtlas('tankman/tank4');
					tank4.antialiasing = true;
					tank4.animation.addByPrefix("idle", "fg", 24, true);
					tank4.scrollFactor.set(1.5, 1.5);
					tank4.animation.play("idle");
					losers.add(tank4);

					var tank5 = new  FlxSprite(1620, 700);
					tank5.frames = Paths.getSparrowAtlas('tankman/tank5');
					tank5.antialiasing = true;
					tank5.animation.addByPrefix("idle", "fg", 24, true);
					tank5.scrollFactor.set(1.5, 1.5);
					tank5.animation.play("idle");
					losers.add(tank5);

					var tank3 = new FlxSprite(1300, 1200);
					tank3.frames = Paths.getSparrowAtlas('tankman/tank3');
					tank3.antialiasing = true;
					tank3.animation.addByPrefix("idle", "fg", 24, true);
					tank3.scrollFactor.set(3.5, 2.5);
					tank3.animation.play("idle");
					losers.add(tank3);

					add(losers);
				case 'portal'|'portal2'|'portal1':
					/*var datos:Array<Dynamic> = cast Json.parse( Assets.getText( Paths.json('stageCoords') ).trim() ).bgs;
					for(ar in datos){
						if(ar[5]==true){
							var sprite:FlxSprite = new FlxSprite();
							sprite.frames = Paths.getSparrowAtlas(ar[0]);
							sprite.animation.addByPrefix('idle', ar[6], ar[7], true);
							sprite.animation.play('idle', true);
							sprite.antialiasing = true;
							sprite.scrollFactor.set(ar[4],ar[4]);
							sprite.scale.set(ar[3],ar[3]);
							sprite.updateHitbox();
							sprite.x = ar[1];
							sprite.y = ar[2];
							add(sprite);
						}
					}*/
					bottomBoppers = new FlxSprite();
					bottomBoppers.frames = Paths.getSparrowAtlas("OJ/Crowd");
					bottomBoppers.animation.addByPrefix("bop","Crowd0",24,false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.6,0.5);
					bottomBoppers.scale.set(2.65,2.65);
					bottomBoppers.updateHitbox();
					bottomBoppers.x = -350;
					bottomBoppers.y = 350;
					bottomBoppers.animation.play("bop");
					add(bottomBoppers);
				
			}
		} //fin del 2o if de Optimize
		
		switch(songLowercase){
			case 'impetus':
				/*var positions:Array<Float> = [0,0];
				positions[0] = boyfriend.x;
				positions[1] = dad.x;
				boyfriend.y -= 450;*/
				dad.x = 870;
				boyfriend.x = -130;
				boyfriend.y -= 40;
				boyfriend.flipX = false;
				boyfriend.animation.addByPrefix('singLEFT', 'OJ left', 24, false);
				boyfriend.animation.addByPrefix('singRIGHT', 'OJ right', 24, false);
				boyfriend.animation.addByPrefix('singLEFTmiss', 'left fail', 24, false);
				boyfriend.animation.addByPrefix('singRIGHTmiss', 'Right fail', 24, false);
				boyfriend.addOffset("singRIGHT", -140, 62);
				boyfriend.addOffset("singLEFT", -78, 72);
				boyfriend.addOffset("singRIGHTmiss", -140, 62);
				boyfriend.addOffset("singLEFTmiss", -78, 72);
				boyfriend.addOffset('idle', -88, -40);
				boyfriend.addOffset("singUP", 31, 179);
				boyfriend.addOffset("singDOWN", -67, 26);
				boyfriend.addOffset("singUPmiss", 31, 179);
				boyfriend.addOffset("singDOWNmiss", -67, 26);
				boyfriend.updateHitbox();
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
			stateSwitch.usedBotplay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof2 = new DialogueEnd(false, dialogueFinal);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (PlayStateChangeables.useDownscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (PlayStateChangeables.useDownscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		if (FileSystem.exists(Paths.json('healthBar'))){
			var datos:haxe.DynamicAccess<Dynamic> = cast Json.parse( Assets.getText( Paths.json('healthBar') ).trim() );
			trace(datos);
			for(key in datos.keys()){
				var pos:Int = 0;
				var rgb:Array<Int> = [255,255,255];
				var colores:Array<Dynamic> = datos.get(key);
				for(color in colores){
					if(Type.typeof(color) == TInt){
						if(color >= 0 || color < 256)
							rgb[pos] = color;
					}
					pos++;
				}
				colorsMap[key] = FlxColor.fromRGB(rgb[0],rgb[1],rgb[2]);
			}
			setColorBar(true,SONG.player1);
			setColorBar(false,SONG.player2);
		}
		if(!colorsMap.exists(SONG.player2) && dad.colorCode.length > 0){
			trace("Sas dad " + dad.colorCode);
			colorsMap.set(SONG.player2, FlxColor.fromRGB(dad.colorCode[0],dad.colorCode[1],dad.colorCode[2]));
			setColorBar(false,SONG.player2);
		}
		if(!colorsMap.exists(SONG.player1) && boyfriend.colorCode.length > 0){
			trace("Sas bf " + boyfriend.colorCode);
			colorsMap.set(SONG.player1, FlxColor.fromRGB(boyfriend.colorCode[0],boyfriend.colorCode[1],boyfriend.colorCode[2]));
			setColorBar(true,SONG.player1);
		}
		//healthBar.createFilledBar(barColors[0],barColors[1]);
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - DE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		scoreTxt.screenCenter(X);

		originalX = scoreTxt.x;


		scoreTxt.scrollFactor.set();
		
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.cameras = [camHUD];
		replayTxt.scrollFactor.set();
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		botPlayState.alpha = 0;
		botPlayState.cameras = [camHUD];
		if(PlayStateChangeables.botPlay && !loadRep){
			botPlayState.alpha = 1;
			setHealthValues(-1);
		}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		switch(SONG.song.toLowerCase()){
			case 'impetus':
				healthBar.flipX = true;
				/*iconP1 = new HealthIcon(SONG.player2, true);
				iconP1.y = healthBar.y - (iconP1.height / 2);

				iconP2 = new HealthIcon(SONG.player1, false);
				iconP2.y = healthBar.y - (iconP2.height / 2);*/
				iconP1.flipX = true;
				iconP2.flipX = true;				
		}

		animatedIcons["default1"] = new HealthIcon("bf", true);
		animatedIcons["default1"].y = iconP1.y;
		animatedIcons["default1"].alpha = 0.001;
		animatedIcons["default2"] = new HealthIcon("dad", false);
		animatedIcons["default2"].y = iconP2.y;
		animatedIcons["default2"].alpha = 0.001;

		for(icono in animatedIconList)
		{
			for(i in 1...3)
			{
				var icon = new HealthIcon(icono + "Anim", (i == 1));
				if(i == 1){
					icon.y = iconP1.y;
				}else{
					icon.y = iconP2.y;
				}
				icon.alpha = 0.001;
				animatedIcons[icono + "" + i] = icon;
				layerIcons.add(animatedIcons[icono + "" + i]);
				//icon.cameras = [camHUD];
			}
		}

		layerIcons.add(animatedIcons["default1"]);
		layerIcons.add(animatedIcons["default2"]);
		add(iconP1);
		add(iconP2);

		add(layerIcons);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		layerIcons.cameras = [camHUD];
		//animatedIcons["default2"].cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		doof2.cameras = [cam3];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'imposible-posible' | 'moldy-drops':
					schoolIntro(doof);
				case 'six-ft-under':
					schoolIntro(doof);
				case 'growth' | 'exploration' | 'control':
					schoolIntro(doof);
				case 'ugh' | 'guns' | 'stress':
					schoolIntro(doof);
				case 'impetus' | 'sadds' | 'csikos-post' | 'anger' | 'strange-comfort':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var bgJson:Array<Dynamic> = cast Json.parse( Assets.getText( Paths.json('backgrounds') ).trim() ).firstPic;
		trace(bgJson);
		for (ar in bgJson){
			if(SONG.song.toLowerCase() == ar[4]){
				dialogueBG = new FlxSprite(ar[1], ar[2]).loadGraphic(openfl.display.BitmapData.fromFile("assets/shared/images/dialogueBG/" + ar[0] + ".png"));
				dialogueBG.scrollFactor.set();
				dialogueBG.antialiasing = true;
				dialogueBG.scale.set(ar[3], ar[3]);
				add(dialogueBG);
				dialogueBox.hideBlueBG();
				break;
			}
		}

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'roses' || StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
		{
			remove(black);

			if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		if (loadRep)
		{
			add(replayTxt);
		}
		add(botPlayState);

		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[songLowercase]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(musica, 1, false);
		}

		if(isStoryMode){
			switch(SONG.song.toLowerCase())
			{
				case 'six-ft-under' | 'control' | 'strange-comfort':
					FlxG.sound.music.onComplete = outro;
				default:
					FlxG.sound.music.onComplete = endSong;
			}
		}else
					FlxG.sound.music.onComplete = endSong;
			
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default:
				#if windows
				if(executeModchart && luaModchart != null)
					allowedToHeadbang = true;
				else
					allowedToHeadbang = false;
				#else
					allowedToHeadbang = false;
				#end
		}

		preloadNotes();

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		new FlxSound().loadEmbedded(Paths.sound("missnote1","shared"));
		new FlxSound().loadEmbedded(Paths.sound("missnote2","shared"));
		new FlxSound().loadEmbedded(Paths.sound("missnote3","shared"));

		if(openfl.utils.Assets.exists(Paths.inst(PlayState.SONG.song))){
			musica = Paths.inst(PlayState.SONG.song);
			trace("loaded default music");
		}else{
			SONG.validScore = false;
			var archivo:String = "assets/songs/" + PlayState.SONG.song.toLowerCase() + "/Inst.ogg";
			if(FileSystem.exists(archivo) )
				musica = openfl.media.Sound.fromFile(archivo);
			else
				musica = Paths.inst("tutorial");
		}

		if (SONG.needsVoices)
			if(openfl.utils.Assets.exists(Paths.voices(PlayState.SONG.song)))
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			else{
				var archivo:String = "assets/songs/" + PlayState.SONG.song.toLowerCase() + "/Voices.ogg";
				if(FileSystem.exists(archivo) )
					vocals = new FlxSound().loadEmbedded(openfl.media.Sound.fromFile(archivo));
				else
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			}
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);
		vocals.looped = false;

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			// pre lowercasing the song name (generateSong)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, false, gottaHitNote, daType);

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, false, gottaHitNote,daType);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';

			if (PlayStateChangeables.Optimize && player == 0)
				continue;
		
			if (SONG.noteStyle == null) {
				switch(storyWeek) {case 6: noteTypeCheck = 'pixel';case 9: noteTypeCheck = 'dance';}
			} else {noteTypeCheck = SONG.noteStyle;}

			SONG.noteStyle = noteTypeCheck;
			style1 = noteTypeCheck;
			style2 = noteTypeCheck;

			switch (noteTypeCheck)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}
				case 'dance':
						babyArrow.frames = Paths.getSparrowAtlas('keen/NOTE_assets');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
				
				case 'dance2'|'dance3':
						babyArrow.frames = Paths.getSparrowAtlas('OJ/NOTE_assets2');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								if(noteTypeCheck == "dance3"){
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								}else{
									babyArrow.animation.addByPrefix('static', 'arrowUP');
								}
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
				case 'cat':
					babyArrow.frames = Paths.getSparrowAtlas('OJ/NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

					case 'sacred':
						babyArrow.frames = Paths.getSparrowAtlas('modchart/Holy_Note');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
					case 'normal':
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							}
					case 'black':
						babyArrow.frames = Paths.getSparrowAtlas('specialNotes/NOTE_Black');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							}
					default:
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 275;
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;


		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			}


		
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
				layerIcons.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
				layerIcons.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old'){
				iconP1.animation.play(SONG.player1);
				setColorBar(true,SONG.player1);
			}else{
				iconP1.animation.play('bf-old');
				setRGBColorBar(true,233,255,72);
			}
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && !PlayStateChangeables.Optimize)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			case 'newgrounds' | 'newgrounds2':
			{
				floats[0] += FlxG.elapsed * floats[1];
				bg2.angle = floats[0] - 90 + 15;
				bg2.x = floats[2] + 1500 * FlxMath.fastCos(flixel.math.FlxAngle.asRadians(floats[0] + 180));
				bg2.y = 1300 + 1100 * FlxMath.fastSin(flixel.math.FlxAngle.asRadians(floats[0] + 180));
			}
			/*case '8th-layer':
				if(Std.int(elapsed) % 2 == 0)
					trailDad.pixels.scroll(1,0);*/
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		scoreTxt.x = (originalX - (lengthInPx / 2)) + 235;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if(!isStoryMode){
				if (useVideo)
					{
						GlobalVideo.get().stop();
						remove(videoSprite);
						FlxG.stage.window.onFocusOut.remove(focusOut);
						FlxG.stage.window.onFocusIn.remove(focusIn);
						removedVideo = true;
					}
				#if windows
				DiscordClient.changePresence("Chart Editor", null, null, true);
				#end
				FlxG.switchState(new ChartingState());
				#if windows
				if (luaModchart != null)
				{
					luaModchart.die();
					luaModchart = null;
				}
				#end
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		switch(SONG.song.toLowerCase()){	//Cuando este invertido
			case 'impetus':
				iconP2.x = healthBar.x + 540 - (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
				iconP1.x = healthBar.x + 580 - (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP1.width - iconOffset);
			default:
				iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
				iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}

		if (health > 2)
			health = 2;

		/*switch(iconP1.animation.curAnim.name){
			case "daidem":
				iconP1.char = "daidem";
				animatedIcons["daidem1"].alpha = 1;
			default:
				iconP1.char = iconP1.animation.curAnim.name;
		}
		switch(iconP2.animation.curAnim.name){
			case "daidem":
				iconP2.char = "daidem";
				animatedIcons["daidem2"].alpha = 1;
			default:
				iconP2.char = iconP2.animation.curAnim.name;
		}*/

		if (healthBar.percent < 20){
			switch(iconP1.char){
				case 'daidem':
					if(animIcon1 != "losing"){
						iconP1.alpha = 0.001;
						animatedIcons["daidem1"].alpha = 1;
						animatedIcons["daidem1"].animation.play("daidemLosing");
						animIcon1 = "losing";
					}
					animatedIcons["daidem1"].x = iconP1.x;
				default:
					iconP1.alpha = 1;
					iconP1.animation.curAnim.curFrame = 1;
			}
		}else{
			switch(iconP1.char){
				case 'daidem':
					if(animIcon1 != "normal"){
						iconP1.alpha = 0.001;
						animatedIcons["daidem1"].alpha = 1;
						animatedIcons["daidem1"].animation.play("daidem");
						animIcon1 = "normal";
					}
					animatedIcons["daidem1"].x = iconP1.x;
				default:
					iconP1.alpha = 1;
					iconP1.animation.curAnim.curFrame = 0;
			}
		}

		if (healthBar.percent > 80){
			switch(iconP2.char){
				case 'daidem':
					if(animIcon2 != "losing"){
						iconP2.alpha = 0.001;
						animatedIcons["daidem2"].alpha = 1;
						animatedIcons["daidem2"].animation.play("daidemLosing");
						animIcon2 = "losing";
					}
					animatedIcons["daidem2"].x = iconP2.x;
				default:
					iconP2.alpha = 1;
					iconP2.animation.curAnim.curFrame = 1;
			}
		}else{
			switch(iconP2.char){
				case 'daidem':
					if(animIcon2 != "normal"){
						iconP2.alpha = 0.001;
						animatedIcons["daidem2"].alpha = 1;
						animatedIcons["daidem2"].animation.play("daidem");
						animIcon2 = "normal";
					}
					animatedIcons["daidem2"].x = iconP2.x;
				default:
					iconP2.alpha = 1;
					iconP2.animation.curAnim.curFrame = 0;
			}
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1, true));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if(!PlayStateChangeables.Optimize){
			if (camFollow.x != layerChars.members[dadID].getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				mustHitSection = false;
				#if windows
				if (luaModchart != null)
				{
					luaModchart.executeState('playerTwoTurn', []);
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(layerChars.members[dadID].getMidpoint().x + 150, layerChars.members[dadID].getMidpoint().y - 100);

				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (layerChars.members[dadID].curCharacter)
				{
					case 'mom':
						camFollow.y = layerChars.members[dadID].getMidpoint().y;
					case 'senpai':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 430;
						camFollow.x = layerChars.members[dadID].getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 430;
						camFollow.x = layerChars.members[dadID].getMidpoint().x - 100;
					case 'tankman':
						camFollow.y = layerChars.members[dadID].getMidpoint().y + 100;
					case 'keen-inverted':
						camFollow.x = layerChars.members[dadID].getMidpoint().x - 150;
					case 'OJ':
						camFollow.x = layerChars.members[dadID].getMidpoint().x + 200;
						camFollow.y = layerChars.members[dadID].getMidpoint().y -160;
					case 'monika':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 430;
						camFollow.x = layerChars.members[dadID].getMidpoint().x - 100;
					case 'henry':
						camFollow.y = layerChars.members[dadID].getMidpoint().y + 50;
						camFollow.x = layerChars.members[dadID].getMidpoint().x + 300;
					case 'eder-jr':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 285;
					case 'annie':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 200;
						camFollow.x = layerChars.members[dadID].getMidpoint().x + 250;
					case 'void':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 40;
						camFollow.x = layerChars.members[dadID].getMidpoint().x + 300;
					case 'tord':
						camFollow.x = layerChars.members[dadID].getMidpoint().x - 20;
					case 'beat' | 'beat-neon':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 180;
						camFollow.x = layerChars.members[dadID].getMidpoint().x + 300;
					case 'impostor-black':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 170;
						camFollow.x = layerChars.members[dadID].getMidpoint().x - 150;
					case 'keen-flying':
						camFollow.y = layerChars.members[dadID].getMidpoint().y - 100;
						camFollow.x = layerChars.members[dadID].getMidpoint().x + 350;
					case 'kopek':
						camFollow.x = layerChars.members[dadID].getMidpoint().x - 50;
					case 'bf-pixel':
						camFollow.y -= 120;
						camFollow.x -= 100;
					default:
						camFollow.x += layerChars.members[dadID].cameraPosition[0];
						camFollow.y += layerChars.members[dadID].cameraPosition[1];
				}

				if(layerChars.members[dadID].flyingOffset > 0 && canPause){
					camFollow.x += 1;
				}

				switch (curStage)
				{
					case 'portal'|'portal1'|'portal2'|'portal3':
						camFollow.y -= 125;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

					camFollow.x += offsetX;
					camFollow.y += offsetY;
					posiciones[1] = camFollow.y;
				if(PlayStateChangeables.singCam){
					moveCam = true;
					switch(charCam[3]){
						case -1:
						camFollow.y += camFactor;
						case 1:
						camFollow.y -= camFactor;
					}
					switch(charCam[2]){
						case -1:
						camFollow.x -= camFactor;
						case 1:
						camFollow.x += camFactor;
					}
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != layerBFs.members[bfID].getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				mustHitSection = true;
				#if windows
				if (luaModchart != null)
				{
					luaModchart.executeState('playerOneTurn', []);
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(layerBFs.members[bfID].getMidpoint().x - 100 , layerBFs.members[bfID].getMidpoint().y - 100 );

				switch(layerBFs.members[bfID].curCharacter){
					case 'bf-OJ':
						if(SONG.song.toLowerCase() == 'impetus'){
							camFollow.x = layerBFs.members[bfID].getMidpoint().x + 300;
							camFollow.y = layerBFs.members[bfID].getMidpoint().y - 100;
						}else{
							camFollow.x = layerBFs.members[bfID].getMidpoint().x -100;
							camFollow.y = layerBFs.members[bfID].getMidpoint().y -160;
						}
					case 'bf-tankman':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y + 100;
					case 'bf-pixel'|'bf-tankman-pixel':
						if(!curStage.startsWith("school")){
							camFollow.x = layerBFs.members[bfID].getMidpoint().x - 200;
							camFollow.y = layerBFs.members[bfID].getMidpoint().y - 200;
						}
					case 'bf-monika':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 430;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 370;
					case 'bf-senpai':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 430;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 370;
					case 'bf-keen-flying':
						/*camFollow.y = layerBFs.members[bfID].getMidpoint().y - 100;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 100;*/
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 100;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 350;
					case 'bf-henry':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y + 50;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 175;
					case 'eder-jr':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 285;
					case 'bf-annie':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 200;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 200;
					case 'bf-void':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y + 20;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 400;
					case 'bf-pico':
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 200;
					case 'bf-pico-minus':
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 300;
					case 'bf-mami':
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 320;
					case 'bf-tord':
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 220;
					case 'bf-beat' | 'bf-beat-neon':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 140;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 300;
					case 'bf-impostor-black':
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 170;
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 750;
					case 'bf-kopek':
						camFollow.x = layerBFs.members[bfID].getMidpoint().x - 450;
					default:
						camFollow.x -= layerBFs.members[bfID].cameraPosition[0];
						camFollow.y += layerBFs.members[bfID].cameraPosition[1];
				}

				if(layerBFs.members[bfID].flyingOffset > 0 && canPause){
					camFollow.x -= 1;
				}

				switch (curStage)
				{
					case 'portal'|'portal1'|'portal2'|'portal3':
						camFollow.y -= 125;
					case 'limo':
						//camFollow.x = layerBFs.members[bfID].getMidpoint().x - 300;
						camFollow.x -= 200;
					case 'mall':
						//camFollow.y = layerBFs.members[bfID].getMidpoint().y - 200;
						camFollow.x -= 100;
					case 'school':
						/*camFollow.x = layerBFs.members[bfID].getMidpoint().x - 200;
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 200;*/
						if(layerBFs.members[bfID].curCharacter == "bf-pixel"){
							camFollow.x -= 100;
							camFollow.y -= 120;
						}
					case 'schoolEvil':
						/*camFollow.x = layerBFs.members[bfID].getMidpoint().x - 200;
						camFollow.y = layerBFs.members[bfID].getMidpoint().y - 200;*/
						if(layerBFs.members[bfID].curCharacter == "bf-pixel"){
							camFollow.x -= 100;
							camFollow.y -= 120;
						}
				}
					camFollow.x += offsetX;
					camFollow.y += offsetY;
					posiciones[0] = camFollow.y;
				if(PlayStateChangeables.singCam){
					moveCam = true;
					switch(charCam[1]){
						case -1:
						camFollow.y += camFactor;
						case 1:
						camFollow.y -= camFactor;
					}
					switch(charCam[0]){
						case -1:
						camFollow.x -= camFactor;
						case 1:
						camFollow.x += camFactor;
					}
				}
			}
			}//fin del 3er optimize
		}

		if(PlayStateChangeables.singCam && curStep > 0 && moveCam){
			if(mustHitSection){
				var anim:String = layerBFs.members[bfID].animation.curAnim.name;
				if(anim != "singUP" && anim != "singDOWN" && anim != "singLEFT" && anim != "singRIGHT"){
					charCam[0] = 0;
					charCam[1] = 0;
				}
				if(charCam[1] == 0){
					camFollow.y = posiciones[0];
				}
			}else{
				var anim:String = layerChars.members[dadID].animation.curAnim.name;
				if(!anim.startsWith("singUP") && !anim.startsWith("singDOWN") && !anim.startsWith("singLEFT") && !anim.startsWith("singRIGHT")){
					charCam[2] = 0;
					charCam[3] = 0;
				}
				if(charCam[3] == 0){
					camFollow.y = posiciones[1];
				}
			}
			
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									var flag:Bool = false;
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null){
										if(PlayStateChangeables.scrollSpeed != 1){
											if(PlayStateChangeables.scrollSpeed <= 0.8){
												flag = true;
												daNote.y += daNote.prevNote.height/2 - 55 * (0.8 - PlayStateChangeables.scrollSpeed);
											}else
												daNote.y += daNote.prevNote.height/2 + 55 * (PlayStateChangeables.scrollSpeed - 0.8);
										}else{
											if(SONG.speed <= 0.8){
												flag = true;
												daNote.y += daNote.prevNote.height/2 - 55 * (0.8 - SONG.speed);
											}else
												daNote.y += daNote.prevNote.height/2 + 55 * (SONG.speed - 0.8);
										}
										if(daNote.noteTypeCheck == "pixel"){
											if(flag)
												daNote.y += 9;
											else
												daNote.y += 6;
										}
									}else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!PlayStateChangeables.botPlay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										if(!daNote.mustPress){
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;

										}else{
											if(!healthValues.get(""+daNote.specialType).get("damage")){
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
											}
										}
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									switch (daNote.noteTypeCheck)
									{
										case 'pixel':
											if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
												daNote.y -= (daNote.prevNote.height - 5) / 2;
											else
												daNote.y -= daNote.height/2;
										case 'dance'|'dance2'|"dance3":
											if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
												daNote.y -= (daNote.prevNote.height - 15) / 2;
											else
												daNote.y -= daNote.height/2;
										default:
											if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
												daNote.y -= (daNote.prevNote.height - 5) / 2;
											else
												daNote.y -= daNote.height/2;
									}
	
									if(!PlayStateChangeables.botPlay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										if(!daNote.mustPress){
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
										}else{
											if(!healthValues.get(""+daNote.specialType).get("damage")){
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
											}
										}
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						switch(daNote.specialType){
							case 4:
							dad.playAnim(goldAnim[1], true);
							if (FlxG.save.data.cpuStrums)
							{
								cpuStrums.forEach(function(spr:FlxSprite)
								{
									if (Math.abs(daNote.noteData) == spr.ID)
									{
										spr.animation.play('confirm', true);
									}
									if (spr.animation.curAnim.name == 'confirm' && style2 != 'pixel') //&& !curStage.startsWith('school'))
									{
										spr.centerOffsets();
										spr.offset.x -= 13;
										spr.offset.y -= 13;
									}
									else{
										spr.centerOffsets();
									}
								});
							}
							default:
							if(!healthValues[""+daNote.specialType].get("damage")){
							switch (Math.abs(daNote.noteData))
							{
								case 2:
									dad.playAnim('singUP' + altAnim, true);
									if(PlayStateChangeables.singCam && !mustHitSection){
										if(charCam[3] != 1){
											camFollow.x -= camFactor;
											charCam[3] = 1;
											charCam[2] = 0;
										}
									}
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
									if(PlayStateChangeables.singCam && !mustHitSection){
										if(charCam[2] != 1){
											camFollow.x += camFactor;
											charCam[2] = 1;
											charCam[3] = 0;
										}
									}
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);
									if(PlayStateChangeables.singCam && !mustHitSection){
										if(charCam[3] != -1){
											camFollow.x += camFactor;
											charCam[3] = -1;
											charCam[2] = 0;
										}
									}
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);
									if(PlayStateChangeables.singCam && !mustHitSection){
										if(charCam[2] != -1){
											camFollow.x -= camFactor;
											charCam[2] = -1;
											charCam[3] = 0;
										}
									}
							}
						
							if (FlxG.save.data.cpuStrums)
							{
								cpuStrums.forEach(function(spr:FlxSprite)
								{
									if (Math.abs(daNote.noteData) == spr.ID)
									{
										spr.animation.play('confirm', true);
									}
									if (spr.animation.curAnim.name == 'confirm' && style2 != 'pixel') //&& !curStage.startsWith('school'))
									{
										spr.centerOffsets();
										spr.offset.x -= 13;
										spr.offset.y -= 13;
									}
									else{
										spr.centerOffsets();
									}
								});
							}
							}//Fin del if para comprobar si es una nota de dano
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition, daNote.specialType, daNote.isSustainNote]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
                    {
                        switch (daNote.noteTypeCheck)
                        {
                            case 'pixel':
                                switch (daNote.noteData)
                                {
                                    case 2:
                                        daNote.x += daNote.width / 2 + 9;
                                    case 3:
                                        daNote.x += daNote.width / 2 + 9;
                                    case 1:
                                        daNote.x += daNote.width / 2 + 9;
                                    case 0:
                                        daNote.x += daNote.width / 2 + 9;
                                }
                            default:
                                switch (daNote.noteData)
                                {
                                    case 2:
                                        daNote.x += daNote.width / 2 + 21;
                                    case 3:
                                        daNote.x += daNote.width / 2 + 17;
                                    case 1:
                                        daNote.x += daNote.width / 2 + 16;
                                    case 0:
                                        daNote.x += daNote.width / 2 + 18;
                                }
                        }
                        daNote.alpha *= 0.6;
                    }
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate && PlayStateChangeables.useDownscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								if (loadRep && daNote.isSustainNote)
								{
									// im tired and lazy this sucks I know i'm dumb
									if (findByTime(daNote.strumTime) != null)
										totalNotesHit += 1;
									else
									{
										if(!healthValues[""+daNote.specialType].get("damage")){
											if(daNote.isSustainNote && daNote.prevNote != null){
												health += healthValues[""+daNote.specialType].get(storyDifficultyText).get("missLN");
												songScore += healthValues[""+daNote.specialType].get("score").get("missLNScore");
											}else{
												health += healthValues[""+daNote.specialType].get(storyDifficultyText).get("miss");
												songScore += healthValues[""+daNote.specialType].get("score").get("missScore");
											}
											if (theFunne)
												noteMiss(daNote.noteData, daNote);
										}
									}
								}
								else
								{
									if(!healthValues[""+daNote.specialType].get("damage")){
										if(daNote.isSustainNote && daNote.prevNote != null){
											health += healthValues[""+daNote.specialType].get(storyDifficultyText).get("missLN");
											songScore += healthValues[""+daNote.specialType].get("score").get("missLNScore");
										}else{
											health += healthValues[""+daNote.specialType].get(storyDifficultyText).get("miss");
											songScore += healthValues[""+daNote.specialType].get("score").get("missScore");
										}
										if (theFunne)
											noteMiss(daNote.noteData, daNote);
									}
								}
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}else{
					if(spr.animation.curAnim.name == 'confirm' && style2 != 'pixel'){
						var angle = spr.angle;
						if (angle > 360)
							angle -= 360;
						if (angle < 0)
							angle = 360 - angle;
						if(angle > 0 && angle <= 90){
							spr.offset.x = 44 - angle * 0.488;
							spr.offset.y = 42;
						}
						if(angle > 90 && angle <= 180){
							spr.offset.x = 0;
							spr.offset.y = 41 - (angle - 90) * 0.477;
						}
						if(angle > 180 && angle <= 270){
							spr.offset.x = (angle - 180) * 0.577;
							spr.offset.y = 0;
						}
						if(angle > 270 && angle < 360){
							spr.offset.x = 52 - (angle - 270) * 0.077;
							spr.offset.y = (angle - 270) * 0.5;
						}
					}
				}
			});
		}

		if(PlayStateChangeables.botPlay && FlxG.save.data.cpuStrums){
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}/*else{
					if(spr.animation.curAnim.name == 'confirm' && style1 != 'pixel'){
						var angle = spr.angle;
						if (angle > 360)
							angle -= 360;
						if (angle < 0)
							angle = 360 - angle;
						if(angle > 0 && angle <= 90){
							spr.offset.x = 44 - angle * 0.488;
							spr.offset.y = 42;
						}
						if(angle > 90 && angle <= 180){
							spr.offset.x = 0;
							spr.offset.y = 41 - (angle - 90) * 0.477;
						}
						if(angle > 180 && angle <= 270){
							spr.offset.x = (angle - 180) * 0.577;
							spr.offset.y = 0;
						}
						if(angle > 270 && angle < 360){
							spr.offset.x = 52 - (angle - 270) * 0.077;
							spr.offset.y = (angle - 270) * 0.5;
						}
					}
				}*/
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE){
			if(isStoryMode)
				switch(SONG.song.toLowerCase()){
					case 'six-ft-under' | 'control' | 'strange-comfort':
						outro();
					default:
						endSong();
				}
			else
				endSong();
		}
		#end
	}

	function endSong():Void
	{
		if (useVideo)
			{
				GlobalVideo.get().stop();
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				PlayState.instance.remove(PlayState.instance.videoSprite);
			}

		if (isStoryMode)
			campaignMisses = misses;

		if (!loadRep)
			//rep.SaveReplay(saveNotes);
			rep.SaveReplay(saveNotes, saveJudge, replayAna);
		else
		{
			PlayStateChangeables.botPlay = false;
			PlayStateChangeables.scrollSpeed = 1;
			PlayStateChangeables.useDownscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		if(!PlayStateChangeables.Optimize){
			layerBFs.members[bfID].flyingOffset = 0;
			layerChars.members[dadID].flyingOffset = 0;
		}

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		//if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					paused = true;

					FlxG.sound.music.stop();
					vocals.stop();

					switch(SONG.song.toLowerCase()){
						case 'six-ft-under':
							FlxG.save.data.unlocks[0] = true;
						case 'control':
							FlxG.save.data.unlocks[1] = true;
						case 'strange-comfort':
							FlxG.save.data.unlocks[2] = true;
					}

					if (FlxG.save.data.scoreScreen)
						openSubState(new ResultsScreen());
					else
					{
						if(SONG.song.toLowerCase() != 'strange-comfort'){
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							FlxG.switchState(new MainMenuState());
						}else{
							FlxG.switchState(new CreditState());
						}
					}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					//StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
					FlxG.save.data.weekUnlocked[Std.int(Math.min(storyWeek + 1, FlxG.save.data.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					//FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					
					// adjusting the song name to be compatible
					var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
					switch (songFormat) {
						case 'Dad-Battle': songFormat = 'Dadbattle';
						case 'Philly-Nice': songFormat = 'Philly';
					}

					var poop:String = Highscore.formatSong(songFormat, storyDifficulty);

					trace('LOADING NEXT SONG');
					trace(poop);

					if (StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;


					PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');

				paused = true;


				FlxG.sound.music.stop();
				vocals.stop();

				if (FlxG.save.data.scoreScreen)
					openSubState(new ResultsScreen());
				else{
					switch(stateSwitch.state.toLowerCase()){
						case "freeplay":
							FreeplayState.position = stateSwitch.id;
							FlxG.switchState(new FreeplayState());
						case "betadciu":
							FreeplayBetadciuState.position = stateSwitch.id;
							FlxG.switchState(new FreeplayBetadciuState());
					}
				}
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 0;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = healthValues.get(""+daNote.specialType).get("score").get("shitScore");
					combo = 0;
					misses++;
					health += healthValues.get(""+daNote.specialType).get(storyDifficultyText).get("shit");
					ss = false;
					shits++;
					if(healthValues.get(""+daNote.specialType).get("damage")){
						if(PlayStateChangeables.botPlay && !loadRep && healthValues.get(""+daNote.specialType).get(storyDifficultyText).get('shit') < 0)
							FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
						daRating = "sick";
					}else{
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.25;
					}
				case 'bad':
					daRating = 'bad';
					score = healthValues.get(""+daNote.specialType).get("score").get("badScore");
					health += healthValues.get(""+daNote.specialType).get(storyDifficultyText).get("bad");
					ss = false;
					bads++;
					if(healthValues.get(""+daNote.specialType).get("damage")){
						if(PlayStateChangeables.botPlay && !loadRep && healthValues.get(""+daNote.specialType).get(storyDifficultyText).get('bad') < 0)
							FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
						daRating = "good";
					}else{
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					}
				case 'good':
					daRating = 'good';
					score = healthValues.get(""+daNote.specialType).get("score").get("goodScore");
					ss = false;
					goods++;
					health += healthValues.get(""+daNote.specialType).get(storyDifficultyText).get('good');
					if(healthValues.get(""+daNote.specialType).get("damage")){
						if(PlayStateChangeables.botPlay && !loadRep && healthValues.get(""+daNote.specialType).get(storyDifficultyText).get('good') < 0)
							FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
						daRating = "shit";
					}else{
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					}
				case 'sick':
					score = healthValues.get(""+daNote.specialType).get("score").get("sickScore");
					health += healthValues.get(""+daNote.specialType).get(storyDifficultyText).get('sick');
					sicks++;
					if(healthValues.get(""+daNote.specialType).get("damage")){
						if(PlayStateChangeables.botPlay && !loadRep && healthValues.get(""+daNote.specialType).get(storyDifficultyText).get('sick') < 0)
							FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
						daRating = "shit";
					}else{
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
					}
			}

			if(healthValues.get(""+daNote.specialType).get("damage")){
				combo = 0;
				misses++;
				totalNotesHit -= 1;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(PlayStateChangeables.botPlay && !loadRep) msTiming = 0;		
			
			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!PlayStateChangeables.botPlay || loadRep) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!PlayStateChangeables.botPlay || loadRep) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				if(PlayStateChangeables.botPlay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				}
				var anas:Array<Ana> = [null,null,null,null];

				for (i in 0...pressArray.length)
					if (pressArray[i])
						anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!ghostTapping)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit)){
										health += healthValues["missPressed"].get(storyDifficultyText);
										noteMiss(shit, null);
									}
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!ghostTapping)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit]){
									health += healthValues["missPressed"].get(storyDifficultyText);
									noteMiss(shit, null);
								}
						}

					if(dontCheck && possibleNotes.length > 0 && ghostTapping && !PlayStateChangeables.botPlay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

					if (!loadRep)
						for (i in anas)
							if (i != null)
								replayAna.anaArray.push(i); // put em all there
				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(PlayStateChangeables.useDownscroll && daNote.y > strumLine.y ||
					!PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress ||
						PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								var n = findByTime(daNote.strumTime);
								trace(n);
								if(n != null)
								{
									if(!healthValues.get(""+daNote.specialType).get("damage")){
									//case 0|4|5|6:
										goodNoteHit(daNote);
										boyfriend.holdTimer = daNote.sustainLength;
									}
								}
							}else {
								if(!healthValues.get(""+daNote.specialType).get("damage")){
								//case 0|4|5|6:
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}
							
							if (FlxG.save.data.cpuStrums){
								//trace('Note: ' + daNote.noteData + " type: " + daNote.specialType);
								if(!healthValues.get(""+daNote.specialType).get("damage")){
									//case 0|4|5|6:
									playerStrums.members[daNote.noteData].animation.play('confirm', true);
									if (playerStrums.members[daNote.noteData].animation.curAnim.name == 'confirm' && style1 != 'pixel') //&& !curStage.startsWith('school'))
									{
										playerStrums.members[daNote.noteData].centerOffsets();
										playerStrums.members[daNote.noteData].offset.x -= 13;
										playerStrums.members[daNote.noteData].offset.y -= 13;

										var spr:FlxSprite = playerStrums.members[daNote.noteData];
										var angle = spr.angle;
										if (angle > 360)
											angle -= 360;
										if (angle < 0)
											angle = 360 - angle;
										if(angle > 0 && angle <= 90){
											spr.offset.x = 44 - angle * 0.488;
											spr.offset.y = 42;
										}
										if(angle > 90 && angle <= 180){
											spr.offset.x = 0;
											spr.offset.y = 41 - (angle - 90) * 0.477;
										}
										if(angle > 180 && angle <= 270){
											spr.offset.x = (angle - 180) * 0.577;
											spr.offset.y = 0;
										}
										if(angle > 270 && angle < 360){
											spr.offset.x = 52 - (angle - 270) * 0.077;
											spr.offset.y = (angle - 270) * 0.5;
										}
									}else{
										playerStrums.members[daNote.noteData].centerOffsets();
									}
									/*default:
										playerStrums.members[daNote.noteData].animation.play('static');
										playerStrums.members[daNote.noteData].centerOffsets();*/
								}
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}
		 
				if(!PlayStateChangeables.botPlay || !FlxG.save.data.cpuStrums){
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (!holdArray[spr.ID])
							spr.animation.play('static');
		 
						if (spr.animation.curAnim.name == 'confirm' && style1 != 'pixel') //&& !curStage.startsWith('school'))
						{
							spr.centerOffsets();
							spr.offset.x -= 13;
							spr.offset.y -= 13;
							var angle = spr.angle;
							if (angle > 360)
								angle -= 360;
							if (angle < 0)
								angle = 360 - angle;
							if(angle > 0 && angle <= 90){
								spr.offset.x = 44 - angle * 0.488;
								spr.offset.y = 42;
							}
							if(angle > 90 && angle <= 180){
								spr.offset.x = 0;
								spr.offset.y = 41 - (angle - 90) * 0.477;
							}
							if(angle > 180 && angle <= 270){
								spr.offset.x = (angle - 180) * 0.577;
								spr.offset.y = 0;
							}
							if(angle > 270 && angle < 360){
								spr.offset.x = 52 - (angle - 270) * 0.077;
								spr.offset.y = (angle - 270) * 0.5;
							}
						}
						else
							spr.centerOffsets();
					});
				}
			}

			public function findByTime(time:Float):Array<Dynamic>
				{
					for (i in rep.replay.songNotes)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (i[0] == time)
							return i;
					}
					return null;
				}

			public var fuckingVolume:Float = 1;
			public var useVideo = false;

			public static var webmHandler:WebmHandler;

			public var playingDathing = false;

			public var videoSprite:FlxSprite;

			public function focusOut() {
				if (paused)
					return;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
		
					if (FlxG.sound.music != null)
					{
						FlxG.sound.music.pause();
						vocals.pause();
					}
		
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			public function focusIn() 
			{ 
				// nada 
			}


			public function backgroundVideo(source:String) // for background videos
				{
					useVideo = true;
			
					FlxG.stage.window.onFocusOut.add(focusOut);
					FlxG.stage.window.onFocusIn.add(focusIn);

					var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
					WebmPlayer.SKIP_STEP_LIMIT = 90;
					var str1:String = "WEBM SHIT"; 
					webmHandler = new WebmHandler();
					webmHandler.source(ourSource);
					webmHandler.makePlayer();
					webmHandler.webm.name = str1;
			
					GlobalVideo.setWebm(webmHandler);

					GlobalVideo.get().source(source);
					GlobalVideo.get().clearPause();
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().updatePlayer();
					}
					GlobalVideo.get().show();
			
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().restart();
					} else {
						GlobalVideo.get().play();
					}
					
					var data = webmHandler.webm.bitmapData;
			
					videoSprite = new FlxSprite(-470,-30).loadGraphic(data);
			
					videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
			
					remove(gf);
					remove(boyfriend);
					remove(dad);
					add(videoSprite);
					add(gf);
					add(boyfriend);
					add(dad);
			
					trace('poggers');
			
					if (!songStarted)
						webmHandler.pause();
					else
						webmHandler.resume();
				}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			//health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			if (daNote != null)
			{
				if (!loadRep){
					saveNotes.push([daNote.strumTime,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}
			}
			else{
				if (!loadRep){
					saveNotes.push([Conductor.songPosition,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}
				songScore -= 10;
			}

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			//songScore -= 10;

			if(!PlayStateChangeables.botPlay || (PlayStateChangeables.botPlay && loadRep))
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null){
				if(daNote != null)
					luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition, daNote.specialType, daNote.isSustainNote]);
				else
					luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition, -1, false]);
			}
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

				if(loadRep)
					noteDiff = findByTime(note.strumTime)[3];

				note.rating = Ratings.CalculateRating(noteDiff);

				if (note.rating == "miss")
					return;	

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						if(!healthValues.get(""+note.specialType).get("damage"))
							combo += 1;
					}
					else
						totalNotesHit += 1;
	
					switch(note.specialType){
						case 4:
							boyfriend.playAnim(goldAnim[0], true);
						default:
						if(!healthValues[""+note.specialType].get("damage")){
						switch (note.noteData)
						{
							case 2:
								boyfriend.playAnim('singUP', true);
								if(PlayStateChangeables.singCam && mustHitSection){
									if(charCam[1] != 1){
										camFollow.x -= camFactor;
										charCam[1] = 1;
										charCam[0] = 0;
									}
								}
							case 3:
								boyfriend.playAnim('singRIGHT', true);
								if(PlayStateChangeables.singCam && mustHitSection){
									if(charCam[0] != 1){
										camFollow.x += camFactor;
										charCam[0] = 1;
										charCam[1] = 0;
									}
								}
							case 1:
								boyfriend.playAnim('singDOWN', true);
								if(PlayStateChangeables.singCam && mustHitSection){
									if(charCam[1] != -1){
										camFollow.x += camFactor;
										charCam[1] = -1;
										charCam[0] = 0;
									}
								}
							case 0:
								boyfriend.playAnim('singLEFT', true);
								if(PlayStateChangeables.singCam && mustHitSection){
									if(charCam[0] != -1){
										camFollow.x -= camFactor;
										charCam[0] = -1;
										charCam[1] = 0;
									}
								}
						}//Fin del switch
						}else{
						if(!PlayStateChangeables.botPlay && !loadRep){
							switch (note.noteData)
							{
								case 0:
									boyfriend.playAnim('singLEFTmiss', true);
								case 1:
									boyfriend.playAnim('singDOWNmiss', true);
								case 2:
									boyfriend.playAnim('singUPmiss', true);
								case 3:
									boyfriend.playAnim('singRIGHTmiss', true);
							}
						}
						}//fin del else
					}
					
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition, note.specialType, note.isSustainNote]);
					#end


					if(!loadRep && note.mustPress)
					{
						var array = [note.strumTime,note.sustainLength,note.noteData,noteDiff];
						if (note.isSustainNote)
							array[1] = -1;
						trace('pushing ' + array[0]);
						saveNotes.push(array);
					}
					
					if(!healthValues[""+note.specialType].get("damage"))
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animation.getByName('scared') != null)
			boyfriend.playAnim('scared', true);
		if(gf.animation.getByName('scared') != null)
			gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end
		switch(SONG.song.toLowerCase()){
			/*case 'synth-wars':
				if(curStep >= 930 && curStep < 1158)
				{
					defaultCamZoom = 0.5;
				}
				if(curStep >= 1158)
				{
					defaultCamZoom = 0.9;
				}*/
			case 'stress':
				if(Std.int(floats[5]) < picoJson.length){
					if(floats[4] >= 0 && floats[4] < 16){
						//trace("{" + floats[4] + ", " + floats[5] + "} " + picoJson[Std.int(floats[5])].sectionNotes[Std.int(floats[4])]);
						if(floats[4] < picoJson[Std.int(floats[5])].sectionNotes.length){
							switch(picoJson[Std.int(floats[5])].sectionNotes[Std.int(floats[4])][1]){
								case '0':
									gf.playAnim('shoot4');
								case '1':
									gf.playAnim('shoot3');
								case '2':
									gf.playAnim('shoot2');
								case '3':
									gf.playAnim('shoot1');
							}
						}
						floats[4] += 1;
					}
					else if(floats[4] == 16){
						floats[4] = 0;
						floats[5] += 1;
					}
					
				}
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (/*SONG.notes[Math.floor(curStep / 16)].mustHitSection &&*/ dad.curCharacter != 'gf' || !dad.curCharacter.startsWith("gf") || dad.curCharacter == "speakers" && dad.holdTimer == 0){
				if(dad.curCharacter == 'spooky'){
					if(dad.animation.curAnim.name == "danceRight" || dad.animation.curAnim.name == "danceLeft" && dad.animation.curAnim.finished)
						dad.dance();
				}else
					if(dad.animation.curAnim.name == "idle" && dad.animation.curAnim.finished)
						dad.dance();
			}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
						upperBoppers.animation.play('bop', true);
						bottomBoppers.animation.play('bop', true);
						santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
			case 'portal'|'portal1'|'portal2':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
			case '8th-layer':
				upperBoppers.animation.play('bop', true);
		}

		switch(SONG.song.toLowerCase()){
			case 'exploration':
				if((curStep >= 164 && curStep < 740) || (curStep >= 868 && curStep < 996)){
					if(bump){
						bg2.visible = true;
						FlxTween.tween(bg2, {alpha: 0}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){
								bg2.visible = false;
								bg2.alpha = 1.0;
							}
						});
					}
					bump = !bump;
				}
			case 'control':
				if((curStep >= 292 && curStep < 676) || (curStep >= 804 && curStep < 932)){
					if(bump){
						bg2.visible = true;
						FlxTween.tween(bg2, {alpha: 0}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){
								bg2.visible = false;
								bg2.alpha = 1.0;
							}
						});
					}
					bump = !bump;
				}
			case 'stress':
				/*if(bump){
					gf.playAnim('shoot'+Std.int(floats[3]));
					if(floats[3] == 4)
						floats[3] = 1;
					else
						floats[3] += 1;
				}
				bump = !bump;*/
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;

	//yo
	/*public function addAnimatedIcon(char:String, isPlayer:Bool){
		var id:String = "2";
		if(isPlayer)
			id = "1";
		switch(char){
			case "daidem":
				var icon = new HealthIcon("daidemAnim", isPlayer);
				var oldX = animatedIcons["daidem" + id].x;
				var oldY = animatedIcons["daidem" + id].y;
				icon.x = oldX;
				icon.y = oldY;
				animatedIcons["daidem" + id] = icon;
				//add(animatedIcons["daidem" + id]);
				icon.cameras = [camHUD];
		}
	}*/

	public function changeStyle(Style:String, ?mode:Int = 0):Void
	{
		var babyArrow:FlxSprite = new FlxSprite();
		var j:Int = 0;
		var k:Int = 8;
		switch(mode){
			case 1:
				j = 0;
				k = 4;
				style1 = Style;
			case 2:
				j = 4;
				k = 8;
				style2 = Style;
			default:
				style1 = Style;
				style2 = Style;
		}
		for(i in j...k){
			if(i < 4)
				babyArrow = playerStrums.members[i];
			if(i >= 4)
				babyArrow = cpuStrums.members[i-4];
			switch (Style)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0|4:
							//babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1|5:
							//babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2|6:
							//babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3|7:
							//babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
					babyArrow.updateHitbox();
				case 'dance':
					babyArrow.frames = Paths.getSparrowAtlas('keen/NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					babyArrow.updateHitbox();

					switch (Math.abs(i))
					{
						case 0|4:
							//babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1|5:
							//babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2|6:
							//babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3|7:
							//babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				case 'dance2'|'dance3':
					babyArrow.frames = Paths.getSparrowAtlas('OJ/NOTE_assets2');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					babyArrow.updateHitbox();

					switch (Math.abs(i))
					{
						case 0|4:
							//babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1|5:
							//babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2|6:
							//babyArrow.x += Note.swagWidth * 2;
							if(Style == "dance3"){
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							}else{
								babyArrow.animation.addByPrefix('static', 'arrowUP');
							}
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3|7:
							//babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
				case 'cat':
					babyArrow.frames = Paths.getSparrowAtlas('OJ/NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					babyArrow.updateHitbox();

					switch (Math.abs(i))
					{
						case 0|4:
							//babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1|5:
							//babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2|6:
							//babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3|7:
							//babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				case 'sacred':
					babyArrow.frames = Paths.getSparrowAtlas('modchart/Holy_Note');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					babyArrow.updateHitbox();

					switch (Math.abs(i))
					{
						case 0|4:
							//babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1|5:
							//babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2|6:
							//babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3|7:
							//babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
				case 'black':
					babyArrow.frames = Paths.getSparrowAtlas('specialNotes/NOTE_Black');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					babyArrow.updateHitbox();

					switch (Math.abs(i))
					{
						case 0|4:
							//babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1|5:
							//babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2|6:
							//babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3|7:
							//babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
				
				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					babyArrow.updateHitbox();

					switch (Math.abs(i))
					{
						case 0|4:
							//babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1|5:
							//babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2|6:
							//babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3|7:
							//babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}	//Fin del switch
			babyArrow.animation.play('static');
		} // fin del for
	}

	function outro():Void
	{
		PlayStateChangeables.scrollSpeed = 1;
		canPause = false;
		paused = true;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		var flag:Bool = false;
		layerBFs.members[bfID].flyingOffset = 0;
		layerChars.members[dadID].flyingOffset = 0;
		var dialogueBox:DialogueEnd = doof2;
		dialogueBox.finishThing = endSong;
		var bgJson:Array<Dynamic> = cast Json.parse( Assets.getText( Paths.json('backgrounds') ).trim() ).lastPic;
		trace(bgJson);

		for (ar in bgJson){
			if(SONG.song.toLowerCase() == ar[4]){
				dialogueBG = new FlxSprite(ar[1], ar[2]).loadGraphic(openfl.display.BitmapData.fromFile("assets/shared/images/dialogueBG/" + ar[0] + ".png"));
				dialogueBG.scrollFactor.set();
				dialogueBG.antialiasing = true;
				dialogueBG.scale.set(ar[3], ar[3]);
				dialogueBG.alpha = 0;
				add(dialogueBG);
				flag=true;
				break;
			}
		}
		playerStrums.forEach(function(spr:FlxSprite){
			FlxTween.tween(spr, {alpha: 0}, 2, {ease: FlxEase.circOut});
		});
		cpuStrums.forEach(function(spr:FlxSprite){
			FlxTween.tween(spr, {alpha: 0}, 2, {ease: FlxEase.circOut});
		});
		
		if(flag){
				FlxTween.tween(dialogueBG, {alpha: 1}, 2, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) {
				if (dialogueBox != null)
				{
					inCutscene = true;
					add(dialogueBox);
					dialogueBox.initDialogue();
				}else{
					endSong();
				}
			}});
		}else{
			FlxTween.tween(dialogueBox.black, {alpha: 1}, 2, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) {
				if (dialogueBox != null)
				{
					inCutscene = true;
					add(dialogueBox);
					dialogueBox.initDialogue();
				}else{
					endSong();
				}
			}});
		}

		/*new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha += 0.15;

			if (black.alpha < 1)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;
					add(dialogueBox);
					dialogueBox.initDialogue();
				}
				//remove(black);
			}
		});*/
	}

	public function setColorBar(isPlayer:Bool,character:String):Void{
		if (colorsMap.exists(character)){
			if(isPlayer){
				barColors[1] = colorsMap[character];
			}else{
				barColors[0] = colorsMap[character];
			}
			healthBar.createFilledBar(barColors[0],barColors[1]);
		}else{
			if(isPlayer){
				healthBar.createFilledBar(barColors[0], 0xFF66FF33);
			}else{
				healthBar.createFilledBar(0xFFFF0000, barColors[1]);
			}
		}
		healthBar.updateBar();
	}

	public function setRGBColorBar(isPlayer:Bool,red:Int,green:Int,blue:Int):Void{
		if(isPlayer){
			barColors[1] = FlxColor.fromRGB(red,green,blue);
		}else{
			barColors[0] = FlxColor.fromRGB(red,green,blue);
		}
		healthBar.createFilledBar(barColors[0],barColors[1]);
		healthBar.updateBar();
	}

	public function setHealthValues(difficulty:Int){
		switch (difficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case -1:
				var map:Map<String,Dynamic> = healthValues;
				var map2:Map<String,Dynamic>;
				var map3:Map<String,Dynamic>;
				for (key in map.keys()){
					if(key != "missPressed"){
						health2.set(key,new Map<String,Dynamic>());
						map2 = map.get(key);
						for(key2 in map2.keys()){
							map3 = map2.get(key2);
							if(key2 != "damage"){
								var aux:Map<String,Dynamic> = [
									for(key3 in map3.keys())
										key3 => map3[key3]
								];
								health2[key].set(key2,aux);
							}else{
								health2[key].set(key2,map[key].get("damage"));
							}
						}
					}else{
						health2.set(key,map.get("missPressed"));
					}
					//healthValues.set(key,map.get(key).copy());
				}
				for (key2 in healthValues.keys()){
					if(key2 != "missPressed"){
					trace("Key: " + key2 + " map:\n"+healthValues[key2].get(storyDifficultyText));
					var map:Map<String,Dynamic> = healthValues[key2].get(storyDifficultyText);
					for(key3 in map.keys()){
						var valor:Float = healthValues[key2].get(storyDifficultyText).get(key3);
						if(valor < 0){
							healthValues[key2].get(storyDifficultyText).set(key3, 0);
						}
					}//Fin del for
					}//Fin del if
				}
				SONG.validScore = false;
			case -2:
				for (key in health2.keys())
					healthValues.set(key,health2.get(key));
		}
		//trace(storyDifficultyText + " values:\n" + healthValues.toString());
	}

	public function preloadNotes(?loadAll:Bool = false){
		var nota:FlxSprite = new FlxSprite();
		nota.frames = Paths.getSparrowAtlas('specialNotes/NOTE_fire');
		nota.frames = Paths.getSparrowAtlas('specialNotes/NOTE_Black');
		nota.frames = Paths.getSparrowAtlas('specialNotes/HURTNOTE_assets');
		nota.frames = Paths.getSparrowAtlas('specialNotes/NOTE_Black');
		nota.frames = Paths.getSparrowAtlas('specialNotes/Warning');
		nota.frames = Paths.getSparrowAtlas('specialNotes/GoldNote');
		nota.frames = Paths.getSparrowAtlas('specialNotes/whiteoutlined');
		nota.loadGraphic(Paths.image('specialNotes/NOTE_fire-pixel'),true,21,31);
		if(loadAll){
			nota.frames = Paths.getSparrowAtlas('NOTE_assets');
			nota.frames = Paths.getSparrowAtlas('OJ/NOTE_assets');
			nota.frames = Paths.getSparrowAtlas('keen/NOTE_assets');
			nota.frames = Paths.getSparrowAtlas('modchart/Holy_Note');
			nota.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels','week6'), true, 17, 17);
		}
	}
}
