export interface CoinChange {
  amount: number;
  denominations: number[];
  ways: number;
  waysList?: number[][];
}

export function coinChange(
  n: number,
  denominations: number[],
  memory: Map<number, CoinChange> = new Map(),
  depth = 0,
): CoinChange {
  if (memory.has(n)) {
    return memory.get(n)!;
  }
  if (n <= 0) {
    return { amount: n, denominations, ways: 1, waysList: [[]] };
  }
  let ways = 0;
  let waysList: number[][] = [];
  for (const coin of denominations) {
    if (n - coin >= 0) {
      // console.log(
      //   `${"  ".repeat(depth)} Checking coin ${coin} for amount ${n}`,
      // );
      const result = coinChange(n - coin, denominations, memory, depth + 1);
      // console.log(
      //   `${"  ".repeat(depth + 1)} Result for amount ${n - coin} ${
      //     memory.has(n - coin) ? "(memorized)" : ""
      //   }`,
      // );
      if (result.waysList) {
        for (const way of result.waysList) {
          const prevValue = way[way.length - 1] || 0;
          if (way.length === 0 || coin >= prevValue) {
            ways += 1;
            waysList.push([...way, coin]);
          }
        }
      }
    }
  }

  const result = { amount: n, denominations, ways, waysList };
  memory.set(n, result);
  return result;
}

export function minimumCoinChange(
  n: number,
  denominations: number[],
  memory: Map<
    number,
    {
      amount: number;
      changes: number[];
    }
  > = new Map(),
  depth = 0,
): {
  amount: number;
  changes: number[];
} {
  if (memory.has(n)) {
    return memory.get(n)!;
  }
  if (n <= 0) {
    return { amount: n, changes: [] };
  }
  let sortedDenominations = denominations.toSorted((a, b) => b - a);
  let minChanges: number[] = [];
  for (const coin of sortedDenominations) {
    if (n - coin >= 0) {
      console.log(
        `${"  ".repeat(depth)} Checking coin ${coin} for amount ${n}`,
      );
      const result = minimumCoinChange(
        n - coin,
        sortedDenominations,
        memory,
        depth + 1,
      );
      console.log(
        `${"  ".repeat(depth + 1)} Result for amount ${n - coin} = {${
          result.changes
        }} ${memory.has(n - coin) ? "(memorized)" : ""}`,
      );
      if (
        minChanges.length === 0 ||
        (result.changes.length + 1 < minChanges.length &&
          result.amount + coin === n)
      ) {
        minChanges = [...result.changes, coin];
      }
    }
  }

  const result = { amount: n, changes: minChanges };
  memory.set(n, result);
  return result;
}
