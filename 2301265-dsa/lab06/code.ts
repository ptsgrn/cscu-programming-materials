export class Point {
	constructor(
		public x: number,
		public y: number,
	) {}
}

export const P = (x: number, y: number) => new Point(x, y);

export function triangulationConvexPolygonCostTopDown(
	ps: Point[],
	memo = new Map<string, number>(),
): {
	cost: number;
	memo: Map<string, number>;
} {
	const key = ps.map((p) => `${p.x},${p.y}`).join(";");
	if (memo.has(key)) return { cost: memo.get(key) || 0, memo };

	const distance = (p1: Point, p2: Point) => {
		return Math.sqrt((p1.x - p2.x) ** 2 + (p1.y - p2.y) ** 2);
	};

	if (ps.length < 3) return { cost: 0, memo };
	if (ps.length === 3) {
		const cost =
			distance(ps[0], ps[1]) + distance(ps[1], ps[2]) + distance(ps[2], ps[0]);
		memo.set(key, cost);
		return { cost, memo };
	}

	let minCost = Infinity;
	for (let i = 1; i < ps.length - 1; i++) {
		const cost1 = distance(ps[0], ps[i]);
		const cost2 = distance(ps[i], ps[ps.length - 1]);
		const cost3 = distance(ps[0], ps[ps.length - 1]);
		const { cost: subCost1 } = triangulationConvexPolygonCostTopDown(
			ps.slice(0, i + 1),
			memo,
		);
		const { cost: subCost2 } = triangulationConvexPolygonCostTopDown(
			ps.slice(i),
			memo,
		);
		const totalCost = cost1 + cost2 + cost3 + subCost1 + subCost2;
		minCost = Math.min(minCost, totalCost);
	}
	memo.set(key, minCost);
	return { cost: minCost, memo };
}

export function minTriangulationConvexPolygonCostBottomUp(ps: Point[]): number {
	const distance = (p1: Point, p2: Point) => {
		return Math.sqrt((p1.x - p2.x) ** 2 + (p1.y - p2.y) ** 2);
	};

	const n = ps.length;
	if (n < 3) return 0;

	const dp: number[][] = Array.from({ length: n }, () => Array(n).fill(0));

	for (let length = 3; length <= n; length++) {
		for (let i = 0; i <= n - length; i++) {
			const j = i + length - 1;
			dp[i][j] = Infinity;

			for (let k = i + 1; k < j; k++) {
				// console.log({
				//   length,
				//   i,
				//   j,
				//   k,
				//   dp_ik: dp[i][k],
				//   dp_kj: dp[k][j],
				// })
				const cost =
					distance(ps[i], ps[k]) +
					distance(ps[k], ps[j]) +
					distance(ps[i], ps[j]) +
					dp[i][k] +
					dp[k][j];
				dp[i][j] = Math.min(dp[i][j], cost);
			}
		}
	}

	// console.table({ dp });

	return dp[0][n - 1];
}

export function sortPointsClockwise(points: Point[]): Point[] {
	if (points.length === 0) return [];

	// Find the centroid of the points
	const centroid = points.reduce(
		(acc, p) => new Point(acc.x + p.x, acc.y + p.y),
		new Point(0, 0),
	);
	centroid.x /= points.length;
	centroid.y /= points.length;

	// Sort points based on the angle from the centroid
	return points.toSorted((a, b) => {
		const angleA = Math.atan2(a.y - centroid.y, a.x - centroid.x);
		const angleB = Math.atan2(b.y - centroid.y, b.x - centroid.x);
		return angleA - angleB;
	});
}

export function maxTriangulationConvexPolygonCostBottomUp(ps: Point[]): number {
	const distance = (p1: Point, p2: Point) => {
		return Math.sqrt((p1.x - p2.x) ** 2 + (p1.y - p2.y) ** 2);
	};

	const n = ps.length;
	if (n < 3) return 0;

	const dp: number[][] = Array.from({ length: n }, () => Array(n).fill(0));

	for (let length = 3; length <= n; length++) {
		for (let i = 0; i <= n - length; i++) {
			const j = i + length - 1;
			dp[i][j] = -Infinity;

			for (let k = i + 1; k < j; k++) {
				// console.log({
				//   length,
				//   i,
				//   j,
				//   k,
				//   dp_ik: dp[i][k],
				//   dp_kj: dp[k][j],
				// })
				const cost =
					distance(ps[i], ps[k]) +
					distance(ps[k], ps[j]) +
					distance(ps[i], ps[j]) +
					dp[i][k] +
					dp[k][j];
				dp[i][j] = Math.max(dp[i][j], cost);
			}
		}
	}

	// console.log({ dp });

	return dp[0][n - 1];
}

// console.log(
//   triangulationConvexPolygonCostTopDown([
//     P(0, 0),
//     P(1, 0),
//     P(2, 1),
//     P(1, 2),
//     P(0, 2),
//   ]).cost
// );

// console.log(
//   triangulationConvexPolygonCostBottomUp([
//     P(0, 0),
//     P(1, 0),
//     P(2, 1),
//     P(1, 2),
//     P(0, 2),
//   ])
// );
