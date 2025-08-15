import { findGCD3 } from "./find-gcd3";
import { primeFacNaive } from './find-gcd1';
import { test, expect, describe } from "bun:test";
import { join } from "path";

test("primeFacNaive", () => {
  expect(primeFacNaive(12)).toEqual({
    a: 1,
    factors: [2, 2, 3],
    opCount: 4,
  });
});

test("primeFacNaive with 18", () => {
  expect(primeFacNaive(18)).toEqual({
    a: 1,
    factors: [2, 3, 3],
    opCount: 4,
  });
});

test("primeFacNaive with 100000000", () => {
  expect(primeFacNaive(100000000)).toBeDefined();
});

describe("GCD3:regular1", async () => {
  const regular1Filename = join(import.meta.dir, "./regular1.csv");
  if (!(await Bun.file(regular1Filename).exists()))
    throw new Error(`${regular1Filename} not found`);
  const regular1 = (await Bun.file(regular1Filename).text())
    .split("\n")
    .map((line) => line.replace(" ", "").split(",").map(Number));

  for (const [m, n] of regular1) {
    if (!m || !n) continue; // skip empty lines
    test(`GCD3:regular1: ${m}, ${n}`, () => {
      const result = findGCD3(m, n);
      expect(result).toBeDefined();
    });
  }
});

describe("GCD3:regular2", async () => {
  const regular2Filename = join(import.meta.dir, "./regular2.csv");
  if (!(await Bun.file(regular2Filename).exists()))
    throw new Error(`${regular2Filename} not found`);
  const regular2 = (await Bun.file(regular2Filename).text())
    .split("\n")
    .map((line) => line.replace(" ", "").split(",").map(Number));

  for (const [m, n] of regular2) {
    if (!m || !n) continue; // skip empty lines
    test(`GCD3:regular2: ${m}, ${n}`, () => {
      const result = findGCD3(m, n);
      expect(result).toBeDefined();
    });
  }
});

// extra1
describe("GCD3:extra1", async () => {
  const extra1Filename = join(import.meta.dir, "./extra1.csv");
  if (!(await Bun.file(extra1Filename).exists()))
    throw new Error(`${extra1Filename} not found`);
  const extra1 = (await Bun.file(extra1Filename).text())
    .split("\n")
    .map((line) => line.replace(" ", "").split(",").map(Number));

  for (const [m, n, o] of extra1) {
    if (!m || !n) continue; // skip empty lines
    test(`GCD3:extra1: ${m}, ${n}, ${o}`, () => {
      const result = findGCD3(findGCD3(m, n).gcd, o);
      expect(result).toBeDefined();
    });
  }
});
