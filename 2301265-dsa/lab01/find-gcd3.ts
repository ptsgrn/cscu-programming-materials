export function findGCD3(m: number, n: number, opCount: number = 0) {
	opCount++;
	if (m === 0) {
		return { m, n, gcd: n, opCount };
	}
	if (n === 0) {
		return { m, n, gcd: m, opCount };
	}
	if (m > n) {
		return findGCD3(m % n, n, opCount);
	}
	if (m < n) {
		return findGCD3(m, n % m, opCount);
	}
	if (m === n) {
		return { m, n, gcd: m, opCount };
	}
	return { m, n, gcd: m, opCount };
}
