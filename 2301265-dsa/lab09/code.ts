type Graph = Readonly<Record<number, readonly number[]>>;

type TestCase = {
  n: number;
  m: number;
  roads: readonly [number, number, number][];
};

const addEdge = (g: Graph, from: number, to: number): Graph => ({
  ...g,
  [from]: [...(g[from] ?? []), to],
});

const buildGraphs = (n: number, roads: readonly [number, number, number][]) => {
  let g: Graph = {};
  let gr: Graph = {};

  for (let i = 1; i <= n; i++) {
    g[i] = [];
    gr[i] = [];
  }

  for (const [a, b, c] of roads) {
    g = addEdge(g, a, b);
    gr = addEdge(gr, b, a);
    if (c === 2) {
      g = addEdge(g, b, a);
      gr = addEdge(gr, a, b);
    }
  }

  return { g, gr };
};

//
// FP DFS that returns updated visited + stack
//
const dfs = (
  graph: Graph,
  node: number,
  visited: ReadonlySet<number>,
  stack: readonly number[],
): { visited: ReadonlySet<number>; stack: readonly number[] } => {
  if (visited.has(node)) return { visited, stack };
  let newVisited = new Set(visited).add(node);
  let newStack = stack;
  for (const next of graph[node] ?? []) {
    const res = dfs(graph, next, newVisited, newStack);
    newVisited = res.visited;
    newStack = res.stack;
  }
  return { visited: newVisited, stack: [node, ...newStack] };
};

//
// DFS for second pass (no stack, just visited set)
//
const dfsVisit = (
  graph: Graph,
  node: number,
  visited: ReadonlySet<number>,
): ReadonlySet<number> => {
  if (visited.has(node)) return visited;
  let newVisited = new Set(visited).add(node);
  for (const next of graph[node] ?? []) {
    newVisited = dfsVisit(graph, next, newVisited);
  }
  return newVisited;
};

//
// Kosaraju's Algorithm
//
const kosaraju = (n: number, g: Graph, gr: Graph): boolean => {
  // 1st pass
  let visited = new Set<number>();
  let stack: number[] = [];
  for (let i = 1; i <= n; i++) {
    if (!visited.has(i)) {
      const res = dfs(g, i, visited, stack);
      visited = res.visited;
      stack = res.stack;
    }
  }

  // 2nd pass
  visited = new Set();
  let sccCount = 0;
  for (const node of stack) {
    if (!visited.has(node)) {
      visited = dfsVisit(gr, node, visited);
      sccCount++;
    }
  }

  return sccCount === 1;
};

//
// Main function for one test case
//
const isStronglyConnected = (testCase: TestCase): number => {
  const { g, gr } = buildGraphs(testCase.n, testCase.roads);
  return kosaraju(testCase.n, g, gr) ? 1 : 0;
};

//
// Example Runner
//
const solve = (input: string): string => {
  const lines = input.trim().split(/\n/);
  const results: number[] = [];
  let idx = 0;

  while (idx < lines.length) {
    const [N, M] = lines[idx++].trim().split(" ").map(Number);
    if (N === 0 && M === 0) break;

    const roads: [number, number, number][] = [];
    for (let i = 0; i < M; i++) {
      const [a, b, c] = lines[idx++].trim().split(" ").map(Number);
      roads.push([a, b, c]);
    }

    results.push(isStronglyConnected({ n: N, m: M, roads }));
  }

  return results.join("\n");
};
