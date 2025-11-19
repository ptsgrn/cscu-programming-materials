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

export function countScc(
	placeCount: number,
	roads: [number, number, number][],
): number {
	const graph = buildGraph(roads);
	const revGraph = buildReverseGraph(roads);

	const visited = new Set<number>();
	const finishStack: number[] = [];

	for (let v = 1; v <= placeCount; v++) {
		if (!visited.has(v)) {
			fillFinishOrder(v, visited, graph, finishStack);
		}
	}

	visited.clear();
	let sccCount = 0;

	while (finishStack.length > 0) {
		const v = finishStack.pop() as number;
		if (!visited.has(v)) {
			sccCount++;
			dfs(v, visited, revGraph);
		}
	}

	return sccCount;
}

function fillFinishOrder(
	v: number,
	visited: Set<number>,
	graph: Record<number, number[]>,
	finishStack: number[],
) {
	visited.add(v);
	for (const n of graph[v] || []) {
		if (!visited.has(n)) fillFinishOrder(n, visited, graph, finishStack);
	}
	finishStack.push(v);
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

export function countSinkSourcesScc(
	places: number,
	roads: [number, number, number][],
) {
	const graph = buildGraph(roads);
	const revGraph = buildReverseGraph(roads);

	const visited = new Set<number>();
	const finishStack: number[] = [];

	for (let v = 1; v <= places; v++) {
		if (!visited.has(v)) {
			fillFinishOrder(v, visited, graph, finishStack);
		}
	}

	visited.clear();
	const sccs: number[][] = [];
	const nodeToSccIndex: number[] = new Array(places + 1).fill(-1);

	while (finishStack.length > 0) {
		const v = finishStack.pop() as number;
		if (!visited.has(v)) {
			const currentScc: number[] = [];
			collectScc(v, visited, revGraph, currentScc);
			const sccIndex = sccs.length;
			sccs.push(currentScc);
			for (const node of currentScc) {
				nodeToSccIndex[node] = sccIndex;
			}
		}
	}

	const inDegree = new Array(sccs.length).fill(0);
	const outDegree = new Array(sccs.length).fill(0);

	for (const [f, t, _d] of roads) {
		const sccF = nodeToSccIndex[f];
		const sccT = nodeToSccIndex[t];
		if (sccF !== sccT) {
			outDegree[sccF]++;
			inDegree[sccT]++;
		}
	}

	let sinkCount = 0;
	let sourceCount = 0;

	for (let i = 0; i < sccs.length; i++) {
		if (inDegree[i] === 0) sourceCount++;
		if (outDegree[i] === 0) sinkCount++;
	}

	return { sinkCount, sourceCount };
}

function collectScc(
	v: number,
	visited: Set<number>,
	graph: Record<number, number[]>,
	currentScc: number[],
) {
	visited.add(v);
	currentScc.push(v);
	for (const n of graph[v] || []) {
		if (!visited.has(n)) collectScc(n, visited, graph, currentScc);
	}
}
