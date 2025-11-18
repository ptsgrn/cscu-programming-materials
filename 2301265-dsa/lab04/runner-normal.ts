import { bruteForce, greedy } from "./code";
import { join } from "node:path";
import { objectValuesToEqualSign, readTestcaseFile } from "./utils";

const testcaseFiles = [
	"4.1.1",
	"4.1.2",
	"4.1.3",
	"4.2.1",
	"4.2.2",
	"4.2.3",
	"4.3.1",
	"4.3.2",
	"4.3.3",
];

for (const testcaseFileName of testcaseFiles) {
	const fileContent = await readTestcaseFile(`${testcaseFileName}.txt`);
	const [input, k] = fileContent.split("\n");
	if (!input || !k) continue;
	console.log(`--- ${testcaseFileName} ---`);
	console.log(objectValuesToEqualSign({ input, k }));
	const bruteForceResult = bruteForce(input, +k);
	const greedyResult = greedy(input, +k);
	console.log(objectValuesToEqualSign({ bruteForceResult, greedyResult }));
}
