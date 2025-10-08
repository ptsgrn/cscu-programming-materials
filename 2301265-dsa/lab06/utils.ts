import { join } from "node:path";
import { Point } from "./code";

export async function readTestcaseFile(filename: string) {
  const fileContent = (
    await Bun.file(join(__dirname, "testcases", filename)).text()
  ).trim();
  if (!fileContent) {
    throw new Error(`Testcase file ${filename} is empty or not found.`);
  }
  const splitContent = fileContent.split("\n");
  return splitContent.slice(1).map((line) => {
    const [x, y] = line.split(" ").map(Number);
    return new Point(x, y);
  });
}
