import chalk from "chalk";
import type { EdgeList } from "./run";

class Edge {
	constructor(
		public from: number | null,
		public to: number,
		public weight: number = 0,
		public isMarked: boolean = false,
	) {}

	toString() {
		const blueTo = chalk.gray(this.to);
		const weight = this.isMarked ? chalk.bgGreen(this.weight) : this.weight;
		if (this.from === null) {
			return `${blueTo}`;
		}
		return ` ${chalk.dim(`-${weight}->`)} ${blueTo}`;
	}
}

type Graph = Record<string, Edge[]>;

export const maxPollutionLevel = (
	v: number,
	edgeList: EdgeList,
	start: number,
	end: number,
) => {
	// console.log(edgeList.join(", "));
	const graph = buildGraph(edgeList);
	// floyd-warshall algorithm
	const dist: number[][] = Array.from({ length: v + 1 }).map((_, i) =>
		Array.from({ length: v + 1 }).map((__, j) =>
			i === j ? 0 : (graph[i]?.find((n) => n.to === j)?.weight ?? Infinity),
		),
	);

	for (let k = 1; k < v + 1; k++) {
		for (let i = 1; i < v + 1; i++) {
			for (let j = 1; j < v + 1; j++) {
				// console.log({
				// 	minmax: Math.min(dist[i][j], Math.max(dist[i][k], dist[k][j])),
				// 	ij: dist[i][j],
				// 	ik: dist[i][k],
				// 	kj: dist[k][j],
				// });
				dist[i][j] = Math.min(dist[i][j], Math.max(dist[i][k], dist[k][j]));
			}
		}
	}

	// console.log(dist);

	return dist[start][end];
};

export const listWeightedPaths = (
	v: number,
	edgeList: EdgeList,
	start: number,
	end: number,
) => {
	const graph = buildGraph(edgeList);
	const results: Edge[][] = [];
	const visited: boolean[] = Array(v + 1).fill(false);

	const dfs = (node: number, path: Edge[]) => {
		if (node === end) {
			results.push([...path]);
			return;
		}

		visited[node] = true;

		for (const neighbor of graph[node] || []) {
			if (!visited[neighbor.to]) {
				path.push(neighbor);
				dfs(neighbor.to, path);
				path.pop();
			}
		}

		visited[node] = false;
	};

	dfs(start, [new Edge(null, start)]);

	const maxLevel = maxPollutionLevel(v, edgeList, start, end);

	const filteredResults = results
		.filter((p) => Math.max(...p.map((n) => n.weight)) === maxLevel)
		.map((p) =>
			p.map((n) =>
				n.weight === maxLevel ? new Edge(n.from, n.to, n.weight, true) : n,
			),
		);

	return filteredResults;
};

export const buildGraph = (edgeList: number[][]) => {
	const graph: Graph = {};

	for (const e of edgeList) {
		const [a, b, w] = e as [number, number, number];
		if (!(a in graph)) graph[a] = [];
		if (!(b in graph)) graph[b] = [];

		graph[a].push(new Edge(a, b, w));
		graph[b].push(new Edge(b, a, w));
	}

	return graph;
};
