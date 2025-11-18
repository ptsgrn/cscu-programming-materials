import { join } from "node:path";
import chalk from "chalk";
import { listWeightedPaths, maxPollutionLevel } from "./code";

export type EdgeList = [number, number, number][];

let testcases = ["10.0", "10.1", "10.2", "10.3", "10.4"];

if (Bun.argv.length > 2) {
	testcases = Bun.argv.slice(2);
}

for (const tc of testcases) {
	console.log(`Running testcase ${tc}:`);

	const testcaseText = await Bun.file(
		join(__dirname, "testcases", `${tc}.txt`),
	).text();
	const inputs = testcaseText.split("\n").map((v) => v.split(" ").map(Number));
	const [v, e, t] = inputs[0] as [number, number, number];
	const edgeList: EdgeList = [];
	for (let i = 1; i < e; i++) {
		const [u, v, w] = (inputs[i] as [number, number, number]) || [0, 0, 0];
		edgeList.push([u, v, w]);
	}

	for (let i = 0; i < t; i++) {
		const [start, end] = inputs[e + 1 + i] as [number, number];
		const result = maxPollutionLevel(v, edgeList, start, end);
		console.log(result === Infinity ? "no path" : result);
		const result2 = listWeightedPaths(v, edgeList, start, end);
		console.log(result2.map((v) => v.join("")).join("\n"));
	}

	console.log(chalk.dim("----------------"));
}
