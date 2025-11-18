import { commonFactors } from "./find-gcd1";

const primeList: number[] = [];

export function primeFacSeive(n: number) {
	let opCount = 0;
	const factors: number[] = [];

	for (let i = 2; i <= n; i++) {
		let isPrime = true;
		for (const prime of primeList) {
			console.log(`Checking if ${i} is divisible by ${prime}`);
			if (prime * prime > i) break;
			if (i % prime === 0) {
				isPrime = false;
				break;
			}
			opCount++;
		}
		if (isPrime) {
			primeList.push(i);
		}
	}

	for (const prime of primeList) {
		console.log(`Checking factors of ${n} with prime ${prime}`);
		while (n % prime === 0) {
			factors.push(prime);
			n /= prime;
			opCount++;
		}
	}

	return { n, factors, opCount };
}

export function findGCD2(m: number, n: number) {
	const mFactors = primeFacSeive(m);
	const nFactors = primeFacSeive(n);

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
