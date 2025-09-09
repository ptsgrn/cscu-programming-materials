import { findGCD1 } from "./find-gcd1";
import { findGCD2 } from "./find-gcd2";
import { findGCD3 } from "./find-gcd3";

const testcase = (await Bun.file("./regular2_plot.csv").text())
  .split("\n")
  .map((line) => {
    const [a, b] = line.split(",").map((s) => s.trim());
    return [a, b].map(Number) as [number, number];
  });

let results: {
  a: number | string;
  b: number | string;
  gcd1: number | string;
  gcd1_opCount: number | string;
  gcd2: number | string;
  gcd2_opCount: number | string;
  gcd3: number | string;
  gcd3_opCount: number | string;
}[] = [];

results.push({
  a: "a",
  b: "b",
  gcd1: "gcd1",
  gcd1_opCount: "gcd1opcount",
  gcd2: "gcd2",
  gcd2_opCount: "gcd2opcount",
  gcd3: "gcd3",
  gcd3_opCount: "gcd3opcount",
});

for (const [m, n] of testcase) {
  const r1 = findGCD1(m, n);
  const r2 = findGCD2(m, n);
  const r3 = findGCD3(m, n);

  results.push({
		a: m,
		b: n,
    gcd1: r1.product,
    gcd1_opCount: r1.opSum,
    gcd2: r2.product,
    gcd2_opCount: r2.opSum,
    gcd3: r3.gcd,
    gcd3_opCount: r3.opCount,
  });
}

// save result to csvfil
const csvContent = results
  .map((row) => Object.values(row).join(","))
  .join("\n");
await Bun.write("./out-regular2_plot.csv", csvContent);
