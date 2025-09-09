import { bruteForce, greedy } from "./code";
import { describe, test, expect } from "bun:test";

describe("Grab-Passenger Matching Tests", () => {
  test("Case 1: GPPGP, k=1", () => {
    const input = "GPPGP";
    const k = 1;
    expect(bruteForce(input, k)).toEqual([2, 2]);
    expect(greedy(input, k)).toBe(2);
  });

  test("Case 2: PPGGPG, k=2", () => {
    const input = "PPGGPG";
    const k = 2;
    expect(bruteForce(input, k)).toEqual([1, 3]);
    expect(greedy(input, k)).toBe(3);
  });

  test("Case 3: GPGPPG, k=3", () => {
    const input = "GPGPPG";
    const k = 3;
    expect(bruteForce(input, k)).toEqual([3, 3]);
    expect(greedy(input, k)).toBe(3);
  });

  test("Case 4: Long alternating pattern GPGPGP..., k=2", () => {
    const input = "GPGPGPGPGPGPGPGPGPGP"; // length 20
    const k = 2;
    // Expected result: every Grab can match a Passenger
    // There are 10 G's and 10 P's, so maximum is 10
    expect(bruteForce(input, k)).toEqual([1, 10]);
    expect(greedy(input, k)).toBe(10);
  });
});
