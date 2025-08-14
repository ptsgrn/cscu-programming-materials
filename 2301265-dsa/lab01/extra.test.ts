import { test } from "bun:test";
import { findGCD1 } from "./find-gcd1";
import { findGCD2 } from "./find-gcd2";
import { findGCD3 } from "./find-gcd3";
// 36, 84, 120
// 189, 252, 1197, 292005

test("findGCD1: 36, 84, 120", () => {
	const s1 = findGCD1(36, 84);
	const s2 = findGCD1(s1.product, 120);
	console.table({ s1, s2 });
});

test("findGCD1: 189, 252, 1197, 292005", () => {
	const s1 = findGCD1(189, 252);
	const s2 = findGCD1(s1.product, 1197);
	const s3 = findGCD1(s2.product, 292005);
	console.table({ s1, s2, s3 });
});

test("findGCD2: 36, 84, 120", () => {
	const s1 = findGCD2(36, 84);
	const s2 = findGCD2(s1.product, 120);
	console.table({ s1, s2 });
});

test("findGCD2: 189, 252, 1197, 292005", () => {
	const s1 = findGCD2(189, 252);
	const s2 = findGCD2(s1.product, 1197);
	const s3 = findGCD2(s2.product, 292005);
	console.table({ s1, s2, s3 });
});

test("findGCD3: 36, 84, 120", () => {
	const s1 = findGCD3(36, 84);
	const s2 = findGCD3(s1.gcd, 120);
	console.table({ s1, s2 });
});

test("findGCD3: 189, 252, 1197, 292005", () => {
	const s1 = findGCD3(189, 252);
	const s2 = findGCD3(s1.gcd, 1197);
	const s3 = findGCD3(s2.gcd, 292005);
	console.table({ s1, s2, s3 });
});
