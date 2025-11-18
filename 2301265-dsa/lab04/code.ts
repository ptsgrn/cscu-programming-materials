export function bruteForce(s: string, k: number): [number, number] {
	const n = s.length;
	const grabs: number[] = [];
	const passengers: number[] = [];

	// Collect positions
	for (let i = 0; i < n; i++) {
		if (s[i] === "G") grabs.push(i);
		else if (s[i] === "P") passengers.push(i);
	}

	let maxPassengers = 0;
	let solutionCount = 0;

	function backtrack(gIndex: number, used: boolean[], matched: number) {
		// console.log("backtrack", {
		//   gIndex,
		//   used: used.map((u, i) => (i === gIndex ? "G" : u ? "#" : ".")),
		//   matched,
		// });
		if (gIndex === grabs.length) {
			if (matched > maxPassengers) {
				maxPassengers = matched;
				solutionCount = 1;
			} else if (matched === maxPassengers) {
				solutionCount++;
			}
			return;
		}

		const gPos = grabs[gIndex];
		let matchedAny = false;

		// Try assigning passenger to this Grab
		for (let p = 0; p < passengers.length; p++) {
			if (!used[p] && Math.abs(grabs[gIndex] - passengers[p]) <= k) {
				used[p] = true;
				backtrack(gIndex + 1, used, matched + 1);
				used[p] = false;
				matchedAny = true;
			}
		}

		// Option: skip this Grab
		backtrack(gIndex + 1, used, matched);
	}

	backtrack(0, new Array(passengers.length).fill(false), 0);

	return [solutionCount, maxPassengers];
}

export function greedy(s: string, k: number): number {
	const n = s.length;
	let passengers: number[] = [];
	let grabs: number[] = [];

	for (let i = 0; i < n; i++) {
		if (s[i] === "G") grabs.push(i);
		else if (s[i] === "P") passengers.push(i);
	}

	let i = 0,
		j = 0,
		matches = 0;

	// Greedy two-pointer
	while (i < grabs.length && j < passengers.length) {
		if (Math.abs(grabs[i] - passengers[j]) <= k) {
			matches++;
			i++;
			j++;
		} else if (grabs[i] < passengers[j]) {
			i++;
		} else {
			j++;
		}
	}

	return matches;
}
