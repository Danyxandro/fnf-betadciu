import flixel.math.FlxMath;

class HelperFunctions
{
    public static function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}

	public static function GCD(a, b) {
		return b == 0 ? FlxMath.absInt(a) : GCD(b, a % b);
	}

	public static function getERegMatches(ereg:EReg, input:String, unique:Bool = false, index:Int = 0):Array<String>
	{
		var matches = [];
		while (ereg.match(input))
		{
			if (unique)
			{
				if (!matches.contains(ereg.matched(index)))
					matches.push(ereg.matched(index));
			}
			else
				matches.push(ereg.matched(index));

			input = ereg.matchedRight();
		}
		return matches;
	}
}