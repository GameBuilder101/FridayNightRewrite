function onHit(state, time, accuracy)
{
	state.score += cast(accuracy * 100.0 * cast(state.combo / 8.0, Int), Int);
	state.combo += 1;
}

function onMiss(state, time)
{
	state.combo = 0;
}
