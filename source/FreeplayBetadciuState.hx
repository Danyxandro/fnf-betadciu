package;

import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import ui.InputTextFix;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import FreeplayState.SongMetadata;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayBetadciuState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int;
	public static var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:FlxTypedGroup<HealthIcon> = new FlxTypedGroup<HealthIcon>();

	private var searchGroup:FlxSpriteGroup;
	private var searchIconBG:FlxSprite;
	private var searchIcon:FlxSprite;
	private var searchModInput:InputTextFix;
	private var inst:FlxText;
	private var searchExtended:Bool = false;
	private var searchExtending:Bool = false;
	private var cachedSongsList:Array<SongMetadata> = [];
	private var playMusic:Bool = true;
	private var playingSong:String = "";
	private var songDifficulty:Int = 1;

	public static var position:Int = 0;

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('betadciuSonglist'));
		
		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var difficulties:Array<Bool> = [true,true,true];
			if(data[3] != null){
				difficulties = [];
				var datos:Array<String> = data[3].split('|');
				for(obj in datos){
					switch(obj.toLowerCase()){
						case "easy":
							difficulties[0]=true;
						case "hard":
							difficulties[2]=true;
						default:
							difficulties[1]=true;
					}
				}
				if(difficulties.length < 1)
					difficulties[1]=true;
			}
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1],i,difficulties));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In BETADCIUs Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		add(iconArray);

		var list = songs.copy();
		for (i in list)
			cachedSongsList.push(i);
		FlxG.mouse.visible = true;

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);
		curSelected = position;
		changeSelection();
		//changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		 //This is from forever engine searching function
		searchGroup = new FlxSpriteGroup();

		searchIconBG = new FlxSprite(0, 16).makeGraphic(64, 64, 0xFF000000);
		searchIconBG.alpha = 0.6;

		searchIcon = new FlxSprite();
		searchIcon.frames = Paths.getSparrowAtlas(FlxG.random.bool(10) ? "search_glass_watson" : "search_glass");
		searchIcon.animation.addByPrefix("a", "", 24);
		searchIcon.animation.play("a");
		searchIcon.setGraphicSize(0, 54);
		searchIcon.updateHitbox();
		searchIcon.antialiasing = true;
		searchIcon.x = (searchIconBG.width / 2) - (searchIcon.width / 2);
		searchIcon.y = searchIconBG.y + 5;

		var searchBG = new FlxSprite(64, 16).makeGraphic(256, 64, 0xFF000000);
		searchBG.alpha = 0.6;

		var searchInputBG = new FlxSprite(64, 0).makeGraphic(10, 10, 0xFF000000);
		searchInputBG.alpha = 0.3;

		searchModInput = new InputTextFix(searchBG.x + 10, searchBG.y + 9, Std.int(searchBG.width - 20), "", 16, FlxColor.WHITE);
		searchModInput.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, NONE);
		searchModInput.caretColor = FlxColor.WHITE;
		searchModInput.fieldBorderColor = FlxColor.TRANSPARENT;
		searchModInput.offset.y = -2;
		searchModInput.callback = updateSearch;
		@:privateAccess
		searchModInput.backgroundSprite.alpha = 0;

		searchInputBG.setGraphicSize(Std.int(searchBG.width - 18), 24);
		searchInputBG.updateHitbox();
		searchInputBG.setPosition(searchBG.x + 9, searchBG.y + 8);

		inst = new FlxText(searchBG.x + 10, searchBG.y + 9, "Click to input search...");
		inst.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, NONE);
		inst.alpha = 0.5;
		inst.offset.y = -2;

		var weekTxt = new FlxText(searchBG.x + 10, searchBG.y + 34, "Search a week or song");
		weekTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, NONE);
		weekTxt.offset.y = -2;

		searchGroup.add(searchIconBG);
		searchGroup.add(searchIcon);
		searchGroup.add(searchBG);
		searchGroup.add(searchInputBG);
		searchGroup.add(searchModInput);
		searchGroup.add(weekTxt);
		searchGroup.add(inst);
		
		searchGroup.x = FlxG.width - 64;
		searchGroup.y = FlxG.height - 34 - searchGroup.height;
		add(searchGroup);

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = controls.ACCEPT;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.DPAD_UP)
			{
				changeSelection(-1);
			}
			if (gamepad.justPressed.DPAD_DOWN)
			{
				changeSelection(1);
			}
			if (gamepad.justPressed.DPAD_LEFT)
			{
				changeDiff(-1);
			}
			if (gamepad.justPressed.DPAD_RIGHT)
			{
				changeDiff(1);
			}
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);

		if (controls.BACK && !searchExtended)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}
			
			trace(songs[curSelected].songName);

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);

			trace(poop);
			FlxG.mouse.visible = false;
			PlayState.stateSwitch.state = "betadciu";
			PlayState.stateSwitch.id = songs[curSelected].listPos;
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(searchIconBG))
				extendSearch();
		}

		if (FlxG.keys.justPressed.F)
		{
			if (FlxG.keys.pressed.CONTROL)
				extendSearch();
		}
	}

	function changeDiff(change:Int = 0)
	{
		songDifficulty += change;

		if (songDifficulty < 0)
			songDifficulty = 2;
		if (songDifficulty > 2)
			songDifficulty = 0;

		curDifficulty = 0 + songDifficulty;
		var aux:Array<Bool> = songs[curSelected].difficulties;
		while(!aux[curDifficulty]){
			curDifficulty++;
			if (curDifficulty > 2)
				curDifficulty = 0;
		}

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}
		
		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end

		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
		changeDiff(0);

		// selector.y = (70 * curSelected) + 30;
		
		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		/*var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end*/

		#if PRELOAD_ALL
		var archivo = Paths.inst(songs[curSelected].songName);
		var song:String = songs[curSelected].songName.toLowerCase();
		if(playMusic && playingSong != song){
			if(openfl.utils.Assets.exists(archivo))
				FlxG.sound.playMusic(archivo, 0);
			else{
				if(sys.FileSystem.exists("assets/songs/" + song + "/Inst.ogg") )
					FlxG.sound.playMusic(openfl.media.Sound.fromFile("assets/songs/" + song + "/Inst.ogg"), 0);
				else
					FlxG.sound.playMusic(Paths.inst("tutorial"), 0);
			}
			playingSong = song;
		}
		#else
		var archivo = songs[curSelected].songName;
		var song:String = songs[curSelected].songName.toLowerCase();
		if(playMusic && playingSong != song){
			if(sys.FileSystem.exists("assets/songs/" + song + "/Inst.ogg") )
				FlxG.sound.playMusic(openfl.media.Sound.fromFile("assets/songs/" + song + "/Inst.ogg"), 0);
			else
				FlxG.sound.playMusic(Paths.inst("tutorial"), 0);
			playingSong = song;
		}
		#end

		var bullShit:Int = 0;

		/*for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;*/

		/*for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}*/
		for (i in 0...grpSongs.members.length)
		{
			var item = grpSongs.members[i];
			var icon = iconArray.members[i];

			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = icon.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = icon.alpha = 1;
		}
	}

	function extendSearch():Void
	{
		if (!searchExtending)
		{
			searchExtending = true;

			if (searchExtended)
			{
				playMusic = true;
				changeSelection();
				FlxTween.tween(searchGroup, {x: FlxG.width - 64}, 0.3, {
					onComplete: function(_) {
						searchExtending = false;
						searchExtended = false;
					}
				});
			}
			else
			{
				FlxTween.tween(searchGroup, {x: FlxG.width - searchGroup.width}, 0.3, {
					onComplete: function(_) {
						searchExtending = false;
						searchExtended = true;
						playMusic = false;
					}
				});
			}
		}
	}

	private var searchResults:Array<SongMetadata> = [];

	// FOR SEARCH FUNCTION
	function updateSearch(_, _):Void
	{
		searchResults.splice(0, searchResults.length);

		if (searchModInput.text.length < 1)
		{
			inst.visible = true;
			searchResults = cachedSongsList.copy();
			updateSongs();
			return;
		}
		else
			inst.visible = false;

		var weekregex:EReg = ~/^(-)?[0-9]+$/g;//~/week:[0-9]+/g;
		var search = searchModInput.text.trim().toLowerCase();
		
		for (song in cachedSongsList.copy())
		{
			if(song == cachedSongsList[0])
				continue;
			var songName = song.songName.toLowerCase().trim();
			var weekStr = "" + song.week;

			if(weekregex.match(search)){
				if(search == weekStr)
					searchResults.push(song);
			}else
			if (songName.startsWith(search))
			{
				searchResults.push(song);
			}
		}
		//Had to analyze list first song apart due a bug
		var songName = cachedSongsList[0].songName.toLowerCase().trim();

		if (songName.startsWith(search))
		{
			searchResults.insert(0,cachedSongsList[0]);
		}

		var matches = [];
		if (searchResults.length > 0)
		{
			for (i in 0...searchResults.length)
				matches.push(searchResults[i] == cachedSongsList[i]);
		}

		if (matches.length != cachedSongsList.length && matches.contains(false))
			updateSongs();
	}

	private function updateSongs():Void{
		songs.splice(0, songs.length);
		if (searchResults.length > 0)
		{
			for (song in searchResults.copy())
				songs.push(song);
		}
		else
		{
			for (song in cachedSongsList.copy())
				songs.push(song);
		}
		grpSongs.clear();
		iconArray.clear();
		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		changeSelection();
	}
}
