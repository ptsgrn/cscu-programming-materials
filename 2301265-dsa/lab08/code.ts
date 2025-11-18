interface KMPResult {
	piPrefix: number[];
	occurrences: {
		startIndex: number;
		endIndex: number;
	}[];
}

export function computePiPrefix(pattern: string): number[] {
	const m = pattern.length;
	const pi: number[] = new Array(m).fill(0);
	pi[0] = 0;
	let k = 0;
	for (let q = 1; q < m; q++) {
		while (k > 0 && pattern[k] !== pattern[q]) {
			k = pi[k - 1];
		}
		if (pattern[k] === pattern[q]) {
			k = k + 1;
		}
		pi[q] = k;
	}
	return pi;
}

export function kmpSearch(text: string, pattern: string): KMPResult {
	const n = text.length;
	const m = pattern.length;
	const pi = computePiPrefix(pattern);
	const occurrences: { startIndex: number; endIndex: number }[] = [];
	let q = 0;

	for (let i = 0; i < n; i++) {
		while (q > 0 && pattern[q] !== text[i]) {
			q = pi[q - 1] ?? 0;
		}
		if (pattern[q] === text[i]) {
			q = q + 1;
		}
		if (q === m) {
			occurrences.push({ startIndex: i - m + 1, endIndex: i });
			q = pi[q - 1] ?? 0;
		}
	}

	return {
		piPrefix: pi,
		occurrences: occurrences,
	};
}

export function kmpSearchReverse(text: string, pattern: string): KMPResult {
	const reversedText = text.split("").reverse().join("");
	const kmpResult = kmpSearch(reversedText, pattern);

	// Adjust occurrences to match original text indices
	const adjustedOccurrences = kmpResult.occurrences.map((occ) => ({
		startIndex: text.length - occ.startIndex,
		endIndex: text.length - 1 - occ.endIndex,
	}));

	return {
		piPrefix: kmpResult.piPrefix,
		occurrences: adjustedOccurrences,
	};
}

export function mergeKMPResults(
	result1: KMPResult,
	result2: KMPResult,
): KMPResult {
	const mergedPiPrefix =
		result1.piPrefix.length >= result2.piPrefix.length
			? result1.piPrefix
			: result2.piPrefix;

	const mergedOccurrences = [
		...result1.occurrences.map((o) => ({
			startIndex: o.startIndex + 1,
			endIndex: o.endIndex + 1,
		})),
		...result2.occurrences,
	];

	return {
		piPrefix: mergedPiPrefix,
		occurrences: mergedOccurrences,
	};
}

export function naiveSearch(
	text: string,
	pattern: string,
): KMPResult["occurrences"] {
	const n = text.length;
	const m = pattern.length;
	const occurrences: { startIndex: number; endIndex: number }[] = [];

	for (let i = 0; i <= n - m; i++) {
		let match = true;
		for (let j = 0; j < m; j++) {
			if (text[i + j] !== pattern[j]) {
				match = false;
				break;
			}
		}
		if (match) {
			occurrences.push({ startIndex: i, endIndex: i + m - 1 });
		}
	}

	return occurrences;
}

export function naiveReverse(
	text: string,
	pattern: string,
): KMPResult["occurrences"] {
	const reversedText = text.split("").reverse().join("");
	return naiveSearch(reversedText, pattern).map((occ) => ({
		startIndex: text.length - occ.startIndex,
		endIndex: text.length - 1 - occ.endIndex,
	}));
}

export function kmpSearchCircular(text: string, pattern: string): KMPResult {
	const circularText = text + text;
	const kmpResult = kmpSearch(circularText, pattern);

	// Filter occurrences to only include those that start within the original text length
	const filteredOccurrences = kmpResult.occurrences
		.filter((occ) => occ.startIndex < text.length)
		.map((occ) => ({
			startIndex: occ.startIndex,
			endIndex: occ.endIndex,
			direction: occ.startIndex <= occ.endIndex ? "LR" : "RL",
		}));

	return {
		piPrefix: kmpResult.piPrefix,
		occurrences: filteredOccurrences,
	};
}

export function naiveSearchCircular(
	text: string,
	pattern: string,
): KMPResult["occurrences"] {
	const circularText = text + text;
	const occurrences = naiveSearch(circularText, pattern);

	// Filter occurrences to only include those that start within the original text length
	return occurrences
		.filter((occ) => occ.startIndex < text.length)
		.map((occ) => ({
			startIndex: occ.startIndex,
			endIndex: occ.endIndex,
			direction: occ.startIndex <= occ.endIndex ? "LR" : "RL",
		}));
}
