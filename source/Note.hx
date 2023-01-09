package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";

	public var noteTypeCheck:String = 'normal'; 
	public var flag:Bool = true; //Lo hice yo
	public var specialType:Int = 0;
	private var isTrailNote:Bool = false;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inCharter:Bool = false, ?playerNote:Bool = true, ?specialNote:Int = 0)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		this.specialType = specialNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		if (inCharter)
			this.strumTime = strumTime;
		else 
			this.strumTime = Math.round(strumTime);

		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		//defaults if no noteStyle was found in chart
		noteTypeCheck = 'normal';
		flag = playerNote;

		if(flag){
			if (PlayState.instance.style1 == null) {
				switch(PlayState.storyWeek) {case 6: noteTypeCheck = 'pixel';case 9: noteTypeCheck = 'dance';}
			} else {noteTypeCheck = PlayState.SONG.noteStyle;}
		}else{
			if (PlayState.instance.style2 == null) {
				switch(PlayState.storyWeek) {case 6: noteTypeCheck = 'pixel';case 9: noteTypeCheck = 'dance';}
			} else {noteTypeCheck = PlayState.instance.style2;}
		}
		switch(this.specialType){
			case 1:
				if(noteTypeCheck == "pixel"){
					noteTypeCheck = "fire-pixel";
				}else{
					noteTypeCheck = "fire";
				}
			case 2:
				if(noteTypeCheck == "black"){
					noteTypeCheck = "black-alt";
				}else{
					noteTypeCheck = "black";
				}
			case 3:
				noteTypeCheck = "hurt";
			case 4:
				noteTypeCheck = "gold";
			case 5:
				noteTypeCheck = "warning";
			case 6:
				noteTypeCheck = "white";
		}

		setGraphic(noteTypeCheck, true);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// ass
			if (isSustainNote)
			{
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
					&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
					canBeHit = true;
				else
					canBeHit = false;
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}

		if(flag){
			if(PlayState.instance.style1 != noteTypeCheck && this.specialType == 0){ //&& !isPixel && PlayState.SONG.noteStyle != 'pixel'){
					setGraphic(PlayState.instance.style1);
			}
			switch(this.specialType){
			case 1:
				if(PlayState.instance.style1 == 'pixel'){
					if(noteTypeCheck != "fire-pixel"){
						setGraphic('fire-pixel');
					}
				}else{
					if(noteTypeCheck != "fire"){
						setGraphic('fire');
					}
				}
			case 2:
				if(PlayState.instance.style1 == 'black'){
					if(noteTypeCheck != "black-alt"){
						setGraphic('black-alt');
					}
				}else{
					if(noteTypeCheck != "black"){
						setGraphic('black');
					}
				}
			}
		}else{
			if(PlayState.instance.style2 != noteTypeCheck && this.specialType == 0){ //&& !isPixel && PlayState.SONG.noteStyle != 'pixel'){
				setGraphic(PlayState.instance.style2);
			}
			/*if(this.specialType == 2 && PlayState.instance.style2 == 'black' && noteTypeCheck != "black-alt"){
				setGraphic('black-alt');
			}*/
			switch(this.specialType){
			case 1:
				if(PlayState.instance.style2 == 'pixel'){
					if(noteTypeCheck != "fire-pixel"){
						setGraphic('fire-pixel');
					}
				}else{
					if(noteTypeCheck != "fire"){
						setGraphic('fire');
					}
				}
			case 2:
				if(PlayState.instance.style2 == 'black'){
					if(noteTypeCheck != "black-alt"){
						setGraphic('black-alt');
					}
				}else{
					if(noteTypeCheck != "black"){
						setGraphic('black');
					}
				}
			}
		}
	}

	private function setGraphic(style:String, ?tailNote:Bool = false):Void
	{
		switch (style)
		{
			case 'pixel':
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels','week6'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				antialiasing = false;
				updateHitbox();
			case 'cat':
				frames = Paths.getSparrowAtlas('OJ/NOTE_assets');
				setDefaultAnimations();
				antialiasing = true;
			case 'dance'|'dance2'|'dance3':
				frames = Paths.getSparrowAtlas('keen/NOTE_assets');
				setDefaultAnimations();
				antialiasing = true;
			case 'sacred':
				frames = Paths.getSparrowAtlas('modchart/Holy_Note');
				setDefaultAnimations();
				antialiasing = true;
			case 'fire':
				frames = Paths.getSparrowAtlas('specialNotes/NOTE_fire');
				setGraphicSize(Std.int(width*0.6));
				updateHitbox();
				if(FlxG.save.data.downscroll){
					animation.addByPrefix('greenScroll', 'blue fire0',24,true);
					animation.addByPrefix('redScroll', 'red fire0',24,true);
					animation.addByPrefix('blueScroll', 'green fire0',24,true);
					animation.addByPrefix('purpleScroll', 'purple fire0',24,true);
					this.flipY = true;
					offset.y += 161;
				}else{
					animation.addByPrefix('greenScroll', 'green fire0',24,true);
					animation.addByPrefix('redScroll', 'red fire0',24,true);
					animation.addByPrefix('blueScroll', 'blue fire0',24,true);
					animation.addByPrefix('purpleScroll', 'purple fire0',24,true);
					offset.y += 41;
				}
				offset.x += 34;
				
				antialiasing = true;
			case 'fire-pixel':
				loadGraphic(Paths.image('specialNotes/NOTE_fire-pixel'),true,21,31);
				setGraphicSize(Std.int(width*6));
				updateHitbox();
				if(FlxG.save.data.downscroll){
					animation.add('purpleScroll', [0,1,2],12,true);
					animation.add('greenScroll', [3,4,5],12,true);
					animation.add('blueScroll', [6,7,8],12,true);
					animation.add('redScroll', [9,10,11],12,true);
					this.flipY = true;
					offset.y += 66;
				}else{
					animation.add('purpleScroll', [0,1,2],12,true);
					animation.add('blueScroll', [3,4,5],12,true);
					animation.add('greenScroll', [6,7,8],12,true);
					animation.add('redScroll', [9,10,11],12,true);
					offset.y += 26;
				}
				offset.x += 19;
				antialiasing =false;
			case 'hurt':
				frames = Paths.getSparrowAtlas('specialNotes/HURTNOTE_assets');
				setDefaultAnimations();
				antialiasing = true;
			case 'black':
				frames = Paths.getSparrowAtlas('specialNotes/NOTE_Black');
				setDefaultAnimations();
				antialiasing = true;
			case 'black-alt':
				frames = Paths.getSparrowAtlas('NOTE_assets');
				//setDefaultAnimations();
				animation.addByIndices('greenScroll', 'up press', [0], "", 24, false);
				animation.addByIndices('blueScroll', 'down press', [0], "", 24, false);
				animation.addByIndices('purpleScroll', 'left press', [0], "", 24, false);
				animation.addByIndices('redScroll', 'right press', [0], "", 24, false);
				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
			case 'warning':
				frames = Paths.getSparrowAtlas('specialNotes/Warning');
				animation.addByIndices('greenScroll', 'Warning warning', [0], "", 24, false);
				animation.addByIndices('blueScroll', 'Warning warning', [0], "", 24, false);
				animation.addByIndices('purpleScroll', 'Warning warning', [0], "", 24, false);
				animation.addByIndices('redScroll', 'Warning warning', [0], "", 24, false);

				animation.addByPrefix('purpleholdend', 'Warning hold end');
				animation.addByPrefix('greenholdend', 'Warning hold end');
				animation.addByPrefix('redholdend', 'Warning hold end');
				animation.addByPrefix('blueholdend', 'Warning hold end');

				animation.addByPrefix('purplehold', 'Warning hold piece');
				animation.addByPrefix('greenhold', 'Warning hold piece');
				animation.addByPrefix('redhold', 'Warning hold piece');
				animation.addByPrefix('bluehold', 'Warning hold piece');
				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
			case 'gold':
				frames = Paths.getSparrowAtlas('specialNotes/GoldNote');
				animation.addByIndices('greenScroll', 'GoldNote green', [0], "", 24, false);
				animation.addByIndices('blueScroll', 'GoldNote blue', [0], "", 24, false);
				animation.addByIndices('purpleScroll', 'purple', [0], "", 24, false);
				animation.addByIndices('redScroll', 'GoldNote red', [0], "", 24, false);

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'pruple end hold');
				animation.addByPrefix('redholdend', 'pruple end hold');
				animation.addByPrefix('blueholdend', 'pruple end hold');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'purple hold piece');
				animation.addByPrefix('redhold', 'purple hold piece');
				animation.addByPrefix('bluehold', 'purple hold piece');
				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
			case 'white':
				frames = Paths.getSparrowAtlas('specialNotes/whiteoutlined');
				setDefaultAnimations();
				antialiasing = true;
			default:
				frames = Paths.getSparrowAtlas('NOTE_assets');

				setDefaultAnimations();
				antialiasing = true;
		}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && isSustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			if(isTrailNote && !tailNote){
				switch (noteData)
				{
					case 0:
						animation.play('purplehold');
					case 1:
						animation.play('bluehold');
					case 2:
						animation.play('greenhold');
					case 3:
						animation.play('redhold');
				}

				if(PlayStateChangeables.scrollSpeed != 1)
					scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayStateChangeables.scrollSpeed;
				else
					scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				switch(style.toLowerCase())
                {
                    case 'pixel':
						scale.y *= 1.19 * 4.2;
						scale.y *= (6 / height);
                }
				// prevNote.setGraphicSize();
			}

			updateHitbox();

			x -= width / 2;

			if(prevNote.specialType == 5)
					prevNote.offset.x -= 3;

			//if (PlayState.curStage.startsWith('school'))
			if (style.toLowerCase() == 'pixel')
				x += 30;

			if (prevNote.isSustainNote && tailNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}
				prevNote.isTrailNote = true;
				if(FlxG.save.data.scrollSpeed != 1)
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * FlxG.save.data.scrollSpeed;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				switch(style.toLowerCase())
                {
                    case 'pixel':
						prevNote.scale.y *= 1.19 * 4.2;
						prevNote.scale.y *= (6 / height);
                }
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}

		noteTypeCheck =style;
	}

	private function setDefaultAnimations():Void
	{
		animation.addByPrefix('greenScroll', 'green0');
		animation.addByPrefix('redScroll', 'red0');
		animation.addByPrefix('blueScroll', 'blue0');
		animation.addByPrefix('purpleScroll', 'purple0');

		animation.addByPrefix('purpleholdend', 'pruple end hold');
		animation.addByPrefix('greenholdend', 'green hold end');
		animation.addByPrefix('redholdend', 'red hold end');
		animation.addByPrefix('blueholdend', 'blue hold end');

		animation.addByPrefix('purplehold', 'purple hold piece');
		animation.addByPrefix('greenhold', 'green hold piece');
		animation.addByPrefix('redhold', 'red hold piece');
		animation.addByPrefix('bluehold', 'blue hold piece');

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
	}
}