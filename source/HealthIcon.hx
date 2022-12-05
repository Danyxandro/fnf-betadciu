package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var char:String;
	public var isCustom:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.char = char;
		
		switch(char){
			case 'daidemAnim':
				var tex = Paths.getSparrowAtlas('modchart/IconAssets', 'shared');
				frames = tex;
				antialiasing = true;
				animation.addByPrefix('daidem', 'DaidemNormal0', 24, true, isPlayer);
				animation.addByPrefix('daidemLosing', 'DaidemLoosing0', 24, true, isPlayer);
				//char = char + "Anim";
				animation.play("daidem");
			default:
				changeIcon(char, isPlayer);
		}

		scrollFactor.set();

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function changeIcon(char:String, isPlayer:Bool){
		if(sys.FileSystem.exists("assets/shared/images/characters/" + char + "/icon.png")){
			trace("agregado: " + char);
			loadGraphic(openfl.display.BitmapData.fromFile("assets/shared/images/characters/" + char + "/icon.png"), true, Math.floor(width / 2), Math.floor(height));
			animation.add(char, [0, 1], 0, false, isPlayer);
			antialiasing = false;
			isCustom = true;
			animation.play(char);
		}else{
			loadGraphic(Paths.image('iconGrid'), true, 150, 150);

			antialiasing = true;
			animation.add(char, [10, 11], 0, false, isPlayer);
			animation.add('bf', [0, 1], 0, false, isPlayer);
			animation.add('bf-car', [0, 1], 0, false, isPlayer);
			animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
			animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
			animation.add('spooky', [2, 3], 0, false, isPlayer);
			animation.add('pico', [4, 5], 0, false, isPlayer);
			animation.add('pico-minus', [4, 5], 0, false, isPlayer);
			animation.add('mom', [6, 7], 0, false, isPlayer);
			animation.add('mom-car', [6, 7], 0, false, isPlayer);
			animation.add('tankman', [8, 9], 0, false, isPlayer);
			animation.add('bf-tankman-pixel', [8, 9], 0, false, isPlayer);
			animation.add('face', [10, 11], 0, false, isPlayer);
			animation.add('dad', [12, 13], 0, false, isPlayer);
			animation.add('senpai', [22, 22], 0, false, isPlayer);
			animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
			animation.add('spirit', [23, 23], 0, false, isPlayer);
			animation.add('bf-old', [14, 15], 0, false, isPlayer);
			animation.add('gf', [16], 0, false, isPlayer);
			animation.add('crazy-GF', [16], 0, false, isPlayer);
			animation.add('gf-christmas', [16], 0, false, isPlayer);
			animation.add('gf-pixel', [16], 0, false, isPlayer);
			animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
			animation.add('monster', [19, 20], 0, false, isPlayer);
			animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
			animation.add('beat', [24, 25], 0, false, isPlayer);
			animation.add('beat-neon', [24, 25], 0, false, isPlayer);
			animation.add('bf-neon', [0, 1], 0, false, isPlayer);
			animation.add('keen', [26, 27], 0, false, isPlayer);
			animation.add('keen-inverted', [26, 27], 0, false, isPlayer);
			animation.add('keen-flying', [26, 27], 0, false, isPlayer);
			animation.add('bf-cat', [0, 1], 0, false, isPlayer);
			animation.add('bf-holding-gf', [0, 1], 0, false, isPlayer);
			animation.add('bf-keen', [26, 27], 0, false, isPlayer);
			animation.add('OJ', [28, 29], 0, false, isPlayer);
			animation.add('whitty', [30, 31], 0, false, isPlayer);
			animation.add('hex', [32, 33], 0, false, isPlayer);
			animation.add('sarv', [34, 35], 0, false, isPlayer);
			animation.add('ruv', [36, 37], 0, false, isPlayer);
			animation.add('impostor', [38, 39], 0, false, isPlayer);
			animation.add('agoti', [40, 41], 0, false, isPlayer);
			animation.add('kapi', [42, 43], 0, false, isPlayer);
			animation.add('sky', [44, 45], 0, false, isPlayer);
			animation.add('sky-annoyed', [44, 45], 0, false, isPlayer);
			animation.add('annie', [46, 47], 0, false, isPlayer);
			animation.add('monika', [48, 49], 0, false, isPlayer);
			animation.add('bob', [50, 51], 0, false, isPlayer);
			animation.add('tabi', [52, 53], 0, false, isPlayer);
			animation.add('garcello', [54, 55], 0, false, isPlayer);
			animation.add('bluskys', [56, 57], 0, false, isPlayer);
			animation.add('tricky', [58, 59], 0, false, isPlayer);
			animation.add('impostor-black', [60, 61], 0, false, isPlayer);
			animation.add('majin-sonic', [62, 63], 0, false, isPlayer);
			animation.add('henry', [64, 65], 0, false, isPlayer);
			animation.add('sarvente-lucifer', [66, 67], 0, false, isPlayer);
			animation.add('selever', [68, 69], 0, false, isPlayer);
			animation.add('ron', [70, 71], 0, false, isPlayer);
			animation.add('eder-jr', [10, 11], 0, false, isPlayer);
			animation.add('daidem', [72, 73], 0, false, isPlayer);
			animation.add('retrospecter', [74, 75], 0, false, isPlayer);
			animation.add('sans', [76, 77], 0, false, isPlayer);
			animation.add('speakers', [88, 89], 0, false, isPlayer);
			animation.add('test', [10, 11], 0, false, isPlayer);
			animation.add('pico-test', [10, 11], 0, false, isPlayer);
			animation.add('myra', [78, 79], 0, false, isPlayer);
			animation.add('salad-fingers', [80, 81], 0, false, isPlayer);
			animation.add('void', [82, 83], 0, false, isPlayer);
			animation.add('cassette-girl', [84, 85], 0, false, isPlayer);
			animation.add('sunday', [10, 11], 0, false, isPlayer);
			animation.add('hank', [86, 87], 0, false, isPlayer);
			animation.add('ex-tricky', [88, 89], 0, false, isPlayer);
			animation.add('cassandra', [90, 91], 0, false, isPlayer);
			animation.add('sky-mad', [92, 92], 0, false, isPlayer);
			animation.add('mami', [93, 94], 0, false, isPlayer);
			animation.add('tord', [95, 96], 0, false, isPlayer);
			animation.add('nene', [97, 98], 0, false, isPlayer);
			animation.add('kopek', [100, 99], 0, false, isPlayer);
			animation.play(char);

			switch(char)
			{
				case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel' | 'bf-tankman-pixel':
					antialiasing = false;
			}
		}
	}
}
