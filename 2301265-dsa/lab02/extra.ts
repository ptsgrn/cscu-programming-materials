import { readTestcaseFile, evaluateExpression, generateAllSubsets } from './code';

// Testcase 2
const testcase2 = (await readTestcaseFile('extra2.txt')).split('\n')

for (const testcase of testcase2) {
  console.log(testcase, "=", evaluateExpression(testcase))
}

// Testcase 3
const testcase3 = (await readTestcaseFile('extra3.txt'))
  .split('\n')
  .map(line => eval(line.trim().replaceAll("{", "[").replaceAll("}", "]")))

for (const testcase of testcase3) {
  console.log(testcase)
  console.log(testcase.join(","), "=", JSON.stringify(generateAllSubsets(testcase)))
}