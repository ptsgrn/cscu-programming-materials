function arrayMax(A: number[]): number {
  if (A.length === 0) {
    throw new Error("Array cannot be empty");
  }
  let max = A[0];
  for (let i = 1; i < A.length; i++) {
    if (A[i]! > max) {
      max = A[i]!;
    }
  }

  return max;
}

console.table({
  arrayMax: arrayMax([2, 41, 2, 5, 235, 0]),
});
