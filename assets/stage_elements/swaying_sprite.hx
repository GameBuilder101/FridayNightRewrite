var swaySpeed;
var swayDistance;

function onNew(data)
{
	swaySpeed = data.swaySpeed;
	swayDistance = data.swayDistance;
}

function onUpdateMusic(time, bpm, beat)
{
	this.angle = FlxMath.fastSin(2.0 * Math.PI * beat * swaySpeed) * swayDistance;
}
