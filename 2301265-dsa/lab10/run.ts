import { join } from "node:path";
import { listWeightedPaths, minWeightedPath } from "./code";

let testcases = ["10.0"];

if (Bun.argv.length > 2) {
  testcases = Bun.argv.slice(2);
}

for (const tc of testcases) {
  const testcaseText = await Bun.file(
    join(__dirname, "testcases", `${tc}.txt`)
  ).text();
  const inputs = testcaseText.split("\n").map((v) => v.split(" ").map(Number));
  const [v, e, t] = inputs[0];
  const edgeList: [number, number, number][] = [];
  for (let i = 1; i < e; i++) {
    const [u, v, w] = inputs[i] || [0, 0, 0];
    edgeList.push([u, v, w]);
  }
  console.log(edgeList);

  for (let i = 0; i < t; i++) {
    // console.log({ i });
    const [start, end] = inputs[e + 1 + i] || [0, 0];
    const result = minWeightedPath(edgeList, start, end);
    console.log(result);
    const result2 = listWeightedPaths(edgeList, [[start, end]], v, e);
    console.log(result2);
    console.log("-----");
  }
}
