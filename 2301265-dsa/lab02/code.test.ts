import { it, describe, expect } from "bun:test"
import { evaluateExpression, generateAllSubsets, isParenthesesBalanced, readTestcaseFile } from './code';

function isTestcasePythonBalanced(input: string): boolean {
  return input.includes("The file is balanced.")
}

describe("1. Balanced Parentheses", async () => {
  it("should return true for balanced parentheses", () => {
    const input = "(a + b) * (c - d)";
    const result = isParenthesesBalanced(input);
    expect(result).toBe(true);
  });

  it("should return false for unbalanced parentheses", () => {
    const input = "(a + b * (c - d)";
    const result = isParenthesesBalanced(input);
    expect(result).toBe(false);
  });

  for (const i of [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) {
    it(`should return true for balanced parentheses in test${i}.py`, async () => {
      const testCaseText = await readTestcaseFile(`test${i}.py`)
      const result = isParenthesesBalanced(testCaseText);
      expect(result).toBe(isTestcasePythonBalanced(testCaseText));
    });
  }

  it("should return true for balanced parentheses", () => {
    const input = '(a + b) " ` " * (c - d)';
    const result = isParenthesesBalanced(input);
    expect(result).toBe(false);
  });
})

describe("2. Evaluate an arithmetic expression", () => {
  it("should return the correct result for a valid expression", () => {
    const input = "(1 + 2) * 3";
    const result = evaluateExpression(input);
    expect(result).toBe(9);
  });

  it("should return error if input is unbalanced", () => {
    const input = "(1 + 2 * (3 - 4)";
    expect(() => evaluateExpression(input)).toThrow("Invalid expression: Unbalanced parentheses");
  });

  it("should return error if division by zero", () => {
    const input = "(1 + 2) / 0";
    expect(() => evaluateExpression(input)).toThrow("Division by zero");
  });

  it("should return error if input is unbalanced", () => {
    const input = "(1 + 2) # (3 - 4)";
    expect(() => evaluateExpression(input)).toThrow("Unknown operator: #");
  });
});

describe("3. All possible subsets of T", () => {
  it("should return all subsets of a 2 members set", () => {
    const inputSet = [1, 2];
    const expectedSubsets = [
      [],
      [1],
      [2],
      [1, 2]
    ];
    const result = generateAllSubsets(inputSet);
    expect(new Set(result)).toEqual(new Set(expectedSubsets));
  })

  it("should return all subsets of a 5 members set", () => {
    const inputSet = [1, 2, 3, 4, 5]
    const expectedSubsets = [
      [],
      [1],
      [2],
      [3],
      [4],
      [5],
      [1, 2],
      [1, 3],
      [1, 4],
      [1, 5],
      [2, 3],
      [2, 4],
      [2, 5],
      [3, 4],
      [3, 5],
      [4, 5],
      [1, 2, 3],
      [1, 2, 4],
      [1, 2, 5],
      [1, 3, 4],
      [1, 3, 5],
      [1, 4, 5],
      [2, 3, 4],
      [2, 3, 5],
      [2, 4, 5],
      [3, 4, 5],
      [1, 2, 3, 4],
      [1, 2, 3, 5],
      [1, 2, 4, 5],
      [1, 3, 4, 5],
      [2, 3, 4, 5],
      [1, 2, 3, 4, 5]
    ]
    const result = generateAllSubsets(inputSet);
    expect(new Set(result))
      .toEqual(new Set(expectedSubsets));
  })
})
