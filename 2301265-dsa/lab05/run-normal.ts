import { readTestcaseFile } from "./utils";
import { coinChange, minimumCoinChange } from "./code";
import { formatResult } from "./utils";
import c from "chalk";

let normalTestcases: string[] = [
  "0.1",
  "5.1",
  "5.2",
  "5.3",
  "5.4",
  "5.5",
  "5.6",
  "5.7",
  "5.8",
  "5.9",
  "5.10",
  "5.11",
  "5.12",
  "5.13",
  "5.14(Extra)",
];

if (Bun.argv.slice(2).length !== 0) {
  normalTestcases = Bun.argv.slice(2);
}

for (const tc of normalTestcases) {
  const { amount, denominations } = await readTestcaseFile(`${tc}.txt`);
  console.log(c.grey(`========= [${c.white(tc)}] =========`));
  const resultCoinChange = coinChange(amount, denominations);
  console.log(c.bold("-- Coin Change --"));
  console.log(formatResult(resultCoinChange));
  console.log(c.bold("-- Minimum Coin Change --"));
  const result = minimumCoinChange(amount, denominations);
  console.log(
    `The minimum number of coins is ${
      result.changes.length
    }, which is {${result.changes.join(",")}}`
  );
}
