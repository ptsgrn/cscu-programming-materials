import { checkFullTravelable } from "./code";
import { join } from "node:path";
let testcases = ["9.0"];

if (Bun.argv.length > 2) {
  testcases = Bun.argv.slice(2);
}

for (const tc of testcases) {
  const testcaseText = await Bun.file(
    join(__dirname, "testcases", `${tc}.txt`),
  ).text();
  const inputs = testcaseText.split("\n").map((v) => v.split(" ").map(Number));
  console.log(checkFullTravelable(inputs));
}
