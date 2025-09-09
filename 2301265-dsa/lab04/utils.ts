import { join } from "node:path";
import ora from "ora";

export function objectValuesToEqualSign(o: Record<string, any>): string {
  return Object.entries(o)
    .map(([key, value]) => `${key} = ${JSON.stringify(value)}`)
    .join("\n");
}

export async function readTestcaseFile(filename: string) {
  return (await Bun.file(join(`${__dirname}/testcases`, filename)).text())
    .trim()
    .replace("\r\n", "\n");
}

export async function runWithTimeout<T>(
  fn: () => T,
  timeoutMs: number
): Promise<T> {
  return new Promise((resolve, reject) => {
    const timeoutId = setTimeout(() => {
      reject(new Error(`Operation timed out after ${timeoutMs} ms`));
    }, timeoutMs);
    try {
      const result = fn();
      resolve(result);
    } catch (error) {
      reject(error);
    } finally {
      clearTimeout(timeoutId);
    }
  });
}
