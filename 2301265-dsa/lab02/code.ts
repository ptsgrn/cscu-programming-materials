import { join } from "node:path";

export async function readTestcaseFile(filename: string) {
	return Bun.file(join(`${__dirname}/testcases`, filename)).text();
}

function removeComment(commentRegex: RegExp) {
	return (input: string) => input.replace(commentRegex, "");
}

export function isParenthesesBalanced(input: string): boolean {
	const stack: string[] = [];
	const quoteStack: string[] = [];
	const pairsMap: Map<string, string> = new Map([
		["(", ")"],
		["{", "}"],
		["[", "]"],
	]);
	// console.log(input)
	input = removeComment(/#.*$/gm)(input); // Remove comments
	// console.log(input)
	const quotesList = ["'", '"', "`"];
	let isText = false;

	for (const char of input) {
		// console.log({ char })
		if (pairsMap.has(char) && !isText) {
			stack.push(char);
		} else if (Array.from(pairsMap.values()).includes(char) && !isText) {
			if (stack.length === 0 || pairsMap.get(stack.pop()!) !== char) {
				// console.log("not balance", { stack, char })
				return false;
			}
		} else if (quotesList.includes(char)) {
			// console.log(char)
			// console.log({ char, isText })
			if (quoteStack.length === 0) {
				isText = true;
				quoteStack.push(char);
			} else if (quoteStack[quoteStack.length - 1] === char) {
				quoteStack.pop();
				isText = false;
			} else {
				// If the quote is not the same as the last one, we are still in text mode
				isText = true;
			}
		}
	}

	return stack.length === 0 && quoteStack.length === 0;
}

export function applyOperator(
	leftOperand: string,
	rightOperand: string,
	operator: string,
): string {
	const left = Number(leftOperand);
	const right = Number(rightOperand);

	switch (operator) {
		case "+":
			return (left + right).toString();
		case "-":
			return (left - right).toString();
		case "*":
			return (left * right).toString();
		case "/":
			if (right === 0) throw new Error("Division by zero");
			return (left / right).toString();
		default:
			throw new Error(`Unknown operator: ${operator}`);
	}
}

export function getPrecedence(operator: string): number {
	switch (operator) {
		case "+":
		case "-":
			return 1;
		case "*":
		case "/":
			return 2;
		default:
			return 0;
	}
}

export function evaluateExpression(input: string) {
	const balanced = isParenthesesBalanced(input);
	if (!balanced) {
		throw new SyntaxError("Invalid expression: Unbalanced parentheses");
	}

	// For value tokens (eg. numbers)
	const valuesStack: string[] = [];
	// For operator tokens (eg. +, -, *, /, (, ))
	const operatorsStack: string[] = [];

	// Token segmentation
	const tokens = input
		.split(/(\s+|\(|\)|\+|\-|\*|\/|\d+)/)
		.filter((token) => token.trim() !== "");
	// console.log({ tokens })
	for (const token of tokens) {
		if (!isNaN(Number(token))) {
			// 1.2.1 A number: push it onto the value stack.
			valuesStack.push(token);
		} else if (token === "(") {
			// 1.2.3 A left parenthesis: push it onto the operator stack.
			operatorsStack.push(token);
		} else if (token === ")") {
			// 1.2.4 A right parenthesis:
			// 1 While the thing on top of the operator stack is not a left parenthesis,
			while (
				operatorsStack.length > 0 &&
				operatorsStack[operatorsStack.length - 1] !== "("
			) {
				// 1 Pop the operator from the operator stack.
				const operator = operatorsStack.pop()!;

				// 2 Pop the value stack twice, getting two operands.
				const rightOperand = valuesStack.pop()!;
				const leftOperand = valuesStack.pop()!;

				// 3 Apply the operator to the operands, in the correct order.
				const result = applyOperator(leftOperand, rightOperand, operator);

				// 4 Push the result onto the value stack.
				valuesStack.push(result);
			}

			// 2 Pop the left parenthesis from the operator stack, and discard it.
			operatorsStack.pop(); // Discard the left parenthesis
		} else {
			// 1.2.5 An operator:
			// 1 While the operator stack is not empty, and the top thing on the operator stack has the same or greater precedence as thisOp,
			while (
				operatorsStack.length > 0 &&
				getPrecedence(operatorsStack[operatorsStack.length - 1]) >=
					getPrecedence(token)
			) {
				// 1 Pop the operator from the operator stack.
				const operator = operatorsStack.pop()!;

				// 2 Pop the value stack twice, getting two operands.
				const rightOperand = valuesStack.pop()!;
				const leftOperand = valuesStack.pop()!;

				// 3 Apply the operator to the operands, in the correct order.
				const result = applyOperator(leftOperand, rightOperand, operator);

				// 4 Push the result onto the value stack.
				valuesStack.push(result);
			}

			// 2 Push token onto the operator stack.
			operatorsStack.push(token);
		}
	}

	// 2. While the operator stack is not empty,
	while (operatorsStack.length > 0) {
		// 1 Pop the operator from the operator stack.
		const operator = operatorsStack.pop()!;

		// 2 Pop the value stack twice, getting two operands.
		const rightOperand = valuesStack.pop()!;
		const leftOperand = valuesStack.pop()!;

		// 3 Apply the operator to the operands, in the correct order.
		const result = applyOperator(leftOperand, rightOperand, operator);

		// 4 Push the result onto the value stack.
		valuesStack.push(result);
	}

	// 3. At this point the operator stack should be empty, and the value stack
	// should have only one value in it, which is the final result.
	if (!valuesStack.length) {
		throw new Error("Invalid expression");
	}

	return Number(valuesStack.pop());
}

export function generateAllSubsets(set: number[]): number[][] {
	const subsets: number[][] = [[]]; // Start with the empty set

	const viz = () =>
		JSON.stringify({
			kind: { grid: true },
			text: "test",
			columnLabels: [
				{
					label: "test",
				},
			],
			rows: [
				{
					label: "foo",
					columns: subsets.map((subset, index) => ({
						content: JSON.stringify(subset),
						tag: `subset-${index}`,
					})),
				},
			],
		});

	for (const element of set) {
		const newSubsets = subsets.map((subset) => [...subset, element]);
		subsets.push(...newSubsets);
	}

	// console.log(subsets)
	return subsets;
}
