enum TokenType {
  numberTok,
  identifierTok,
  quoteTok,
  assignTok,
  greaterThanTok,
  lessThanTok,
  equalityTok,
  lessOrEqualTok,
  greaterOrEqualTok,
  notEqualTok,
  plusTok,
  subtractTok,
  multiplyTok,
  divideTok,
  modulusTok,
  ifTok,
  elseTok,
  whileTok,
  forTok,
  charTok,
  printTok,
  inputTok,
  declareTok,
  semiColonTok,
  lParenTok,
  rParenTok,
  lBraceTok,
  rBraceTok,
  lBracketTok,
  rBracketTok,
  eof,
  unknown,
}

class Token {
  TokenType type;
  String literal;

  Token(this.type, this.literal);
}

class Lexer {
  int position = 0;
  String input = "";

  Lexer(this.input);

  List<Token> getTokens() {
    var currentChar = _getNextChar();
    List<Token> tokens = [];

    while (currentChar != "") {
      currentChar = _getNextChar();

      switch (currentChar) {
        case " ":
        case "\t":
        case "\r":
        case "\n":
          position++;
          continue;
        case "=":
          if (_getCharAfterNext() == "=") {
            tokens.add(Token(TokenType.equalityTok, "=="));
            position++;
          } else {
            tokens.add(Token(TokenType.assignTok, "="));
          }
        case "<":
          if (_getCharAfterNext() == "=") {
            tokens.add(Token(TokenType.lessOrEqualTok, "<="));
            position++;
          } else {
            tokens.add(Token(TokenType.lessThanTok, "<"));
          }
        case ">":
          if (_getCharAfterNext() == "=") {
            tokens.add(Token(TokenType.greaterThanTok, ">="));
            position++;
          } else {
            tokens.add(Token(TokenType.greaterThanTok, ">"));
          }
        case "!":
          if (_getCharAfterNext() == "=") {
            tokens.add(Token(TokenType.notEqualTok, "!="));
            position++;
          }
        case "+":
          tokens.add(Token(TokenType.plusTok, "+"));
        case "-":
          tokens.add(Token(TokenType.subtractTok, "-"));
        case "*":
          tokens.add(Token(TokenType.multiplyTok, "*"));
        case "/":
          tokens.add(Token(TokenType.divideTok, "/"));
        case "%":
          tokens.add(Token(TokenType.modulusTok, "%"));
        case "0" || "1" || "2" || "3" || "4" || "5" || "6" || "7" || "8" || "9":
          tokens.add(Token(TokenType.numberTok, _parseNumber()));
          continue;
        case "\"":
          tokens.add(Token(TokenType.quoteTok, _parseQuote()));
        case ";":
          tokens.add(Token(TokenType.semiColonTok, ";"));
        case "(":
          tokens.add(Token(TokenType.lParenTok, "("));
        case ")":
          tokens.add(Token(TokenType.rParenTok, ")"));
        case "[":
          tokens.add(Token(TokenType.lBraceTok, "["));
        case "]":
          tokens.add(Token(TokenType.rBraceTok, "]"));
        case "{":
          tokens.add(Token(TokenType.lBraceTok, "{"));
        case "}":
          tokens.add(Token(TokenType.rBraceTok, "}"));
        case "":
          tokens.add(Token(TokenType.eof, ""));
        case _:
          tokens.add(_parseIdentifier());
          continue;
      }

      position++;
    }

    return tokens;
  }

  String _getNextChar() {
    if (position >= input.length) {
      return "";
    }

    return input[position];
  }

  String _getCharAfterNext() {
    if ((position + 1) >= input.length) {
      return "";
    }

    return input[position + 1];
  }

  String _parseQuote() {
    var t = "";

    position++;

    while (_getNextChar() != "\"") {
      t += _getNextChar();
      position++;
    }

    return t;
  }

  String _parseNumber() {
    var t = "";

    while (_isNumeric(_getNextChar())) {
      t += _getNextChar();
      position++;
    }

    return t;
  }

  bool _isNumeric(String s) {
    var value = int.tryParse(s);

    return value != null;
  }

  bool _isValidIdentifierCharacter(s) {
    return "_abcdefghijklmnopqrstuwxyz0123456789".contains(s);
  }

  Token _parseIdentifier() {
    var t = "";

    while (_isValidIdentifierCharacter(_getNextChar())) {
      t += _getNextChar();
      position++;
    }

    switch (t) {
      case "if":
        return Token(TokenType.ifTok, "if");
      case "else":
        return Token(TokenType.elseTok, "else");
      case "while":
        return Token(TokenType.whileTok, "while");
      case "for":
        return Token(TokenType.forTok, "for");
      case "char":
        return Token(TokenType.charTok, "char");
      case "print":
        return Token(TokenType.printTok, "print");
      case "input":
        return Token(TokenType.inputTok, "input");
      case "declare":
        return Token(TokenType.declareTok, "declare");
      case _:
        return Token(TokenType.identifierTok, t);
    }
  }

  static void prettyPrint(List<Token> tokens) {
    for (var tok in tokens) {
      print("(Type: ${tok.type}, Literal: `${tok.literal}`)");
    }
  }
}
