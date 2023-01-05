function onHit(state, time) {}
function onMiss(state, time) {}

function getScore(accuracy, combo):Int
{
	return cast(accuracy * 100.0 * cast(combo / 8.0, Int), Int);
}
