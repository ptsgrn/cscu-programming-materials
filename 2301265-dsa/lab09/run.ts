import { join } from "node:path";
import { isFullTravelable } from "./code";
// import { checkFullTravelable } from "./code";

let testcases = ["9.0", "9.0.1", "9.1", "9.2", "9.3", "9.4", "9.5", "9.6"];

if (Bun.argv.length > 2) {
	testcases = Bun.argv.slice(2);
}

for (const tc of testcases) {
	const testcaseText = await Bun.file(
		join(__dirname, "testcases", `${tc}.txt`),
	).text();

	console.log(`--- Testcase ${tc} ---`);
	const inputs = testcaseText
		.trim()
		.split("\n")
		.map((v) => v.split(" ").map(Number));

	const startTime = performance.now();
	while (inputs.length > 0) {
		const [placeCount, roadCount] = inputs.shift() as [number, number];

		if (placeCount === 0 && roadCount === 0) {
			break;
		}

		const subTestcaseInputs = [] as [number, number, number][];

		for (let i = 0; i < roadCount; i++) {
			subTestcaseInputs.push(inputs.shift() as [number, number, number]);
		}

		console.log(isFullTravelable(placeCount, subTestcaseInputs) ? 1 : 0);
	}
	const endTime = performance.now();
	console.log(`--- End of Testcase ${tc} ---`);
	console.log(`Execution Time: ${(endTime - startTime).toFixed(4)} ms\n`);
}
