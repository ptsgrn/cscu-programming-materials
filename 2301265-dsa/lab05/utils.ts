import type { CoinChange } from "./code";
import { join } from "node:path";

export function formatResult(result: CoinChange): string {
	let output = `Amount: ${
		result.amount
	}\nDenominations: ${result.denominations.join(", ")}\nWays to make change: ${
		result.ways
	}\n`;
	output += (result.waysList || [])
		.map((way, i) => `${i + 1}\t(${way.join(", ")})`)
		.join("\n");
	return output;
}

export async function readTestcaseFile(filename: string) {
	const fileContent = (
		await Bun.file(join(__dirname, "testcases", filename)).text()
	).trim();
	if (!fileContent) {
		throw new Error(`Testcase file ${filename} is empty or not found.`);
	}
	const splitContent = fileContent.split("\n");
	return {
		amount: +(splitContent[0] || 0),
		denominations: (splitContent[1] || "")
			.split(" ")
			.map(Number)
			.filter(Boolean),
	};
}
