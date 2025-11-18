export function mergeSort(arr: number[], p: number, r: number): number[] {
	if (p < r) {
		const q = Math.floor((p + r) / 2);
		mergeSort(arr, p, q);
		mergeSort(arr, q + 1, r);
		merge(arr, p, q, r);
	}
}

export function merge(A: number[], p: number, q: number, r: number) {
	const n1 = q - p + 1;
	const n2 = r - q;
	const L = new Array(n1); // 0..n1 equals to 1..n1+1 anyway
	const R = new Array(n2);

	for (let i = 0; i <= n1; i++) {
		L[i] = A[p + i];
	}

	for (let j = 0; j <= n2; j++) {
		R[j] = A[q + j];
	}

	L[n1] = Infinity; // sentinel
	R[n2] = Infinity; // sentinel

	let i = 0;
	let j = 0;

	for (let k = p; k <= r; k++) {
		if (L[i] <= R[j]) {
			A[k] = L[i];
			i++;
		} else {
			A[k] = R[j];
			j++;
		}
	}
}
