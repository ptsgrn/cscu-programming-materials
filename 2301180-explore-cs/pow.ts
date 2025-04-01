async function hashText(text: string) {
  const hasher = new Bun.CryptoHasher("sha256");
  hasher.update(text);
  return hasher.digest("hex");
}

function isValid(
  hash: string,
  difficulty: number,
): boolean {
  return hash.startsWith("0".repeat(difficulty))
}

async function proofOfWork(
  text: string,
  difficulty: number,
) {
  let nonce = 0;
  let hash;

  let input = `${text}${nonce}`;
  do {
    input = `${text}${nonce}`;
    hash = await hashText(input);
    console.log(`nonce: ${nonce}, hash: ${hash}`);
    nonce++;
  } while (!isValid(hash, difficulty));

  return {
    hash,
    nonce: nonce - 1,
    input
  }
}

const argv = Bun.argv;

const difficulty = parseInt(argv[2]);
const text = argv[3] || "hello world";

if (isNaN(difficulty)) {
  console.error("Please provide a valid difficulty level.");
  Bun.exit(1);
}
if (!text) {
  console.error("Please provide a text to hash.");
  Bun.exit(1);
}

const start = Date.now();
const hash = await proofOfWork(text, difficulty);
const end = Date.now();
const timeTaken = end - start;

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  bold: '\x1b[1m',
}

console.log(`\n${colors.green}[ Proof of Work completed! ]${colors.reset}`);
console.log(`Time taken: ${timeTaken}ms`);
console.log(`Difficulty: ${difficulty}`);
console.log(`Text: ${text}`);
console.log(`Nonce: ${hash.nonce}`);
console.log(`Input: ${colors.bold}${hash.input}${colors.reset}`);
console.log(`Hash: ${hash.hash}`);