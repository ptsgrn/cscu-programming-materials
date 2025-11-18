import { join } from "node:path";
import {
	kmpSearch,
	kmpSearchCircular,
	kmpSearchReverse,
	mergeKMPResults,
	naiveReverse,
	naiveSearch,
	naiveSearchCircular,
} from "./code";

const testcases = [
	"8.0",
	"8.1",
	"8.2",
	"8.3",
	"8.4",
	"8.5",
	"8.6",
	"8.7",
	"8.8",
];

if (Bun.argv.slice(2).length !== 0) {
	testcases.splice(0, testcases.length, ...Bun.argv.slice(2));
}

for (const tc of testcases) {
	const [_0, _1, patternLine, textLine] = await Bun.file(
		join(import.meta.dir, "testcases", `${tc}.txt`),
	)
		.text()
		.then((content) =>
			content
				.split("\n")
				.map((line) => line.trim())
				.filter((line) => line.length > 0),
		);

	// Remove spaces from pattern and text
	const pattern = (patternLine ?? "").split(" ").join("");
	const text = (textLine ?? "").split(" ").join("");

	const kmpResult = kmpSearch(text, pattern);
	const kmpReversedResult = kmpSearchReverse(text, pattern);
	const piPrefix = kmpResult.piPrefix;
	const occurrences = mergeKMPResults(kmpResult, kmpReversedResult)
		.occurrences.toSorted((a, b) => a.startIndex - b.startIndex)
		.map((o) => ({
			...o,
			direction: o.startIndex <= o.endIndex ? "LR" : "RL",
		}));
	const naiveSearchResult = naiveSearch(text, pattern).map((o) => ({
		startIndex: o.startIndex + 1,
		endIndex: o.endIndex + 1,
	}));
	const naiveReverseResult = naiveReverse(text, pattern);
	const naiveOccurrences = [...naiveSearchResult, ...naiveReverseResult]
		.toSorted((a, b) => a.startIndex - b.startIndex)
		.map((o) => ({
			...o,
			direction: o.startIndex <= o.endIndex ? "LR" : "RL",
		}));
	console.log(`========= [${tc}] =========`);
	console.log(`Text: \t\t${text}`);
	console.log(`Pattern: \t${pattern}`);
	console.log(`Pi Prefix: \t[${piPrefix.join(", ")}]`);
	console.log(
		`KMP Occurrences: \n\t${occurrences
			.map((occ) => `${occ.startIndex} ${occ.direction}`)
			.join("\n\t")}`,
	);
	console.log("KMP Count:", occurrences.length);
	console.log(
		`Naive Occurrences: \n\t${naiveOccurrences
			.map((occ) => `${occ.startIndex} ${occ.direction}`)
			.join("\n\t")}`,
	);
	console.log("Circular KMP Search:");
	const kmpCircularResult = kmpSearchCircular(text, pattern);
	console.log(
		`\t${kmpCircularResult.occurrences
			.map((occ) => `${occ.startIndex} ${occ.direction}`)
			.join("\n\t")}`,
	);
	console.log("Circular Naive Search:");
	const naiveCircularResult = naiveSearchCircular(text, pattern);
	console.log(
		`\t${naiveCircularResult
			.map((occ) => `${occ.startIndex} ${occ.direction}`)
			.join("\n\t")}`,
	);
	console.log("\n");
}
