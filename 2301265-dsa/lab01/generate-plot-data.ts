import { findGCD1 } from "./find-gcd1";
import { findGCD2 } from "./find-gcd2";
import { findGCD3 } from "./find-gcd3";

const testcase = (await Bun.file("./regular2_plot.csv").text())
	.split("\n")
	.map((line) => {
		return [line[0], line[1]].map(Number) as [number, number];
	});

let results: {
	gcd1: number;
	gcd1_opCount: number;
	gcd2: number;
	gcd2_opCount: number;
	gcd3: number;
	gcd3_opCount: number;
}[] = [];

for (const [m, n] of testcase) {
	const r1 = findGCD1(m, n);
	const r2 = findGCD2(m, n);
	const r3 = findGCD3(m, n);

	results.push({
		gcd1: r1.product,
		gcd1_opCount: r1.opSum,
		gcd2: r2.product,
		gcd2_opCount: r2.opSum,
		gcd3: r3.gcd,
		gcd3_opCount: r3.opCount,
	});
}

// save result to csvfile
const csvContent = results
	.map((row) => Object.values(row).join(","))
	.join("\n");
await Bun.write("./out-regular2_plot.csv", csvContent);
