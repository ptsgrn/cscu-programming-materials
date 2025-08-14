export function primeFacNaive(a: number) {
	let opCount = 0;
	const factors: number[] = [];
	let divisor = 2;

	while (a >= 2) {
		if (a % divisor === 0) {
			factors.push(divisor);
			opCount++;
			a /= divisor;
		} else {
			opCount++;
			divisor++;
		}
	}

	return {
		a,
		factors,
		opCount,
	};
}

export function commonFactors(a: number[], b: number[]) {
	let opCount = 0;
	let common: number[] = [];
	const bCopy = [...b];

	for (const item of a) {
		const index = bCopy.indexOf(item);
		if (index !== -1) {
			opCount++;
			common.push(item);
			bCopy.splice(index, 1); // remove the matched item
		}
	}

	return {
		a,
		b,
		common,
		opCount,
	};
}

export function findGCD1(m: number, n: number) {
	const mFactors = primeFacNaive(m);
	const nFactors = primeFacNaive(n);

	const common = commonFactors(mFactors.factors, nFactors.factors);
	// console.table(common)
	let product = 1;
	for (const factor of common.common) {
		product *= factor;
	}

	return {
		m,
		n,
		product,
		opSum: mFactors.opCount + nFactors.opCount + common.opCount,
	};
}
