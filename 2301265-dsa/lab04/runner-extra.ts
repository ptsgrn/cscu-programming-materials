import { bruteForce, greedy } from "./code";
import { objectValuesToEqualSign, readTestcaseFile } from "./utils";

const testcaseFiles = [
  "4.4.1",
  "4.4.2",
  "4.4.3",
  "4.4.4",
  "4.4.5",
  "4.5.1",
  "4.5.2",
  "4.5.3",
];

for (const testcaseFileName of testcaseFiles) {
  const fileContent = await readTestcaseFile(`${testcaseFileName}.txt`);
  const [input, k] = fileContent.split("\n");
  if (!input || !k) continue;
  console.log(`--- ${testcaseFileName} ---`);
  console.log(objectValuesToEqualSign({ input, k }));
  // const bruteForceResult = runWithTimeout(function _bruteForce() {
  //   return bruteForce(input, +k);
  // }, 10_000);
  const greedyResult = greedy(input, +k);
  console.log(
    objectValuesToEqualSign({
      // bruteForceResult,
      greedyResult,
    })
  );
}
