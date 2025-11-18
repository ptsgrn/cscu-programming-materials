export function isFullTravelable(
	placeCount: number,
	roads: [number, number, number][],
): boolean {
	const graph = buildGraph(roads);
	const revGraph = buildReverseGraph(roads);

	const visited1 = new Set<number>();
	dfs(1, visited1, graph);

	if (visited1.size !== placeCount) return false;

	const visited2 = new Set<number>();
	dfs(1, visited2, revGraph);

	if (visited2.size !== placeCount) return false;

	return true;
}

function dfs(v: number, visited: Set<number>, graph: Record<number, number[]>) {
	visited.add(v);
	for (const n of graph[v] || []) {
		if (!visited.has(n)) dfs(n, visited, graph);
	}
}

function buildGraph(roads: [number, number, number][]) {
	const graph: Record<number, number[]> = [];
	for (const [f, t, d] of roads) {
		if (!graph[f]) graph[f] = [];
		graph[f].push(t);

		if (d === 2) {
			if (!graph[t]) graph[t] = [];
			graph[t].push(f);
		}
	}
	return graph;
}

function buildReverseGraph(roads: [number, number, number][]) {
	const graph: Record<number, number[]> = [];
	for (const [f, t, d] of roads) {
		if (!graph[t]) graph[t] = [];
		graph[t].push(f);
		if (d === 2) {
			if (!graph[f]) graph[f] = [];
			graph[f].push(t);
		}
	}
	return graph;
}
