import { generateAPFreeSequence_Iterative } from "./code";

if (Bun.argv.length < 3) {
	console.log("Usage: bun run lab07/run.ts <n>");
	process.exit(1);
}

if (!Bun.argv[2] || !/^\d+$/.test(Bun.argv[2])) {
	console.log("Error: n must be a non-negative integer.");
	process.exit(1);
}

const n = parseInt(Bun.argv[2], 10);
const sequence = generateAPFreeSequence_Iterative(n);
console.log(`AP-Free Sequence (n=${n}): ${sequence.join(" ")}`);
