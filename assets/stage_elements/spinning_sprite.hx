var spinSpeed;

function onNew(data)
{
	spinSpeed = data.spinSpeed;
}

function onUpdateMusic(time, bpm, beat)
{
	this.angle = 360.0 * beat * spinSpeed;
}
