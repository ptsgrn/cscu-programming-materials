import {
  sortPointsClockwise,
  minTriangulationConvexPolygonCostBottomUp,
  maxTriangulationConvexPolygonCostBottomUp,
} from "./code";
import { readTestcaseFile } from "./utils";
import c from "chalk";

let normalTestcases: string[] = [
  "1.1",
  "1.2",
  "2.1",
  "2.2",
  "3",
  "4",
  "5",
  "6",
];

if (Bun.argv.slice(2).length !== 0) {
  normalTestcases = Bun.argv.slice(2);
}

for (const tc of normalTestcases) {
  const points = await readTestcaseFile(`${tc}.txt`);
  const result = minTriangulationConvexPolygonCostBottomUp(points);
  const sortedPoints = sortPointsClockwise(points);
  const sortedPointsResult =
    minTriangulationConvexPolygonCostBottomUp(sortedPoints);
  const maxResult = maxTriangulationConvexPolygonCostBottomUp(points);
  const maxSortedResult = maxTriangulationConvexPolygonCostBottomUp(sortedPoints)
  
  if (points.length < 10)
    console.log(
      c.blue(
        `Sorted Points: \t${c.yellow(
          `[${sortedPoints.map((p) => `(${p.x}, ${p.y})`).join(", ")}]`
        )}`
      )
    );
  console.log(c.grey(`========= [${c.white(tc)}] =========`));
  console.log(c.green(`Result: \t${c.yellow(result)}`));
  console.log(c.magenta(`Sorted Points: \t${c.yellow(sortedPointsResult)}`));
  console.log(c.cyan(`Max Result: \t${c.yellow(maxResult)}`));
  console.log(c.cyan(`Sorted Result: \t${c.yellow(maxSortedResult)}`))
  console.log();
}
