package gbc.scripting;

import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

/** An FlxPoint class wrapper for use in scripts. Normal FlxPoints don't work
	for some reason.
**/
class Point
{
	public var point:FlxPoint;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		point = new FlxPoint(x, y);
	}

	public function getX():Float
	{
		return point.x;
	}

	public function setX(value:Float)
	{
		point.x = value;
	}

	public function getY():Float
	{
		return point.y;
	}

	public function setY(value:Float)
	{
		point.y = value;
	}

	public function set(x:Float, y:Float)
	{
		point.x = x;
		point.y = y;
	}

	public function degreesTo(other:Point):Float
	{
		return point.degreesTo(other.point);
	}

	public function radiansTo(other:Point):Float
	{
		return FlxAngle.asRadians(point.degreesTo(other.point));
	}

	public function dist(other:Point):Float
	{
		return point.dist(other.point);
	}

	public function dot(other:Point):Float
	{
		return point.dot(other.point);
	}

	public function normalize()
	{
		point.normalize();
	}

	public function isNormalized():Bool
	{
		return point.isNormalized();
	}
}
