enum TokenType {
  Atom = "atom",
  Op = "op",
  EoF = "eof",
}

class Token {
  constructor(public type: TokenType, public value: string) {}
}

class Lexer {
  constructor(public tokens: Token[] = []) {}
  next() {
    return this.tokens.shift();
  }
  peek() {
    return this.tokens[0];
  }

  parse(input: string) {
    const tokens: Token[] = [];
    let i = 0;
    while (i < input.length) {
      const char = input[i];
      if (char === undefined) break;
      if (/\s/.test(char)) {
        i++;
        continue;
      }
      if (/[0-9]/.test(char)) {
        let num = "";
        while (i < input.length && /[0-9]/.test(input[i])) {
          num += input[i];
          i++;
        }
        tokens.push(new Token(TokenType.Atom, num));
        continue;
      }
      if (/[+\-*\/]/.test(char)) {
        tokens.push(new Token(TokenType.Op, char));
        i++;
        continue;
      }
      if (/[\(\)]/.test(char)) {
        tokens.push(new Token(TokenType.Op, char));
        i++;
        continue;
      }
      throw new Error(`Unexpected character: ${char}`);
    }
    tokens.push(new Token(TokenType.EoF, ""));
    return new Lexer(tokens);
  }
}

class Atom {
  constructor(public value: string) {}
}

class Operation {
  constructor(
    public char: string,
    public left: Operation | Atom,
    public right: Operation | Atom
  ) {}
}

function bindingPower(op: string): [number, number] {
  switch (op) {
    case "+":
    case "-":
      return [1, 1.1];
    case "*":
    case "/":
      return [2, 2.1];
    case "(":
    case ")":
      return [3, 3.1];
    default:
      return [0, 0.1];
  }
}

function parseExpression(
  lexer: Lexer,
  minBp: number = 0
): Operation | Atom | undefined {
  let token = lexer.next();
  if (!token) return;

  let lhs: Operation | Atom | undefined;
  if (token.type === TokenType.Atom) {
    lhs = new Atom(token.value);
  } else if (token.value === "(") {
    lhs = parseExpression(lexer, 0);
    if (!lhs) throw new Error("Invalid left-hand side");
    token = lexer.next();
    if (!token || token.value !== ")")
      throw new Error("Expected closing parenthesis");
  } else {
    throw new Error(`Unexpected token: ${token.value}`);
  }
  while (true) {
    let op = 

const lexer = new Lexer();
console.log(parseExpression(lexer.parse("1 + 1 + 1")));
