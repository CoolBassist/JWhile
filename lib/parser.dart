import 'package:jwhile/lexer.dart';
import 'package:jwhile/logger.dart';
import 'package:jwhile/parse_util.dart' as utils;

abstract class Statement {
  Map<String, int> run(Map<String, int> env);
}

abstract class Expression {
  int eval(Map<String, int> env);
}

class Null extends Expression {
  @override
  int eval(Map<String, int> env) {
    throw Exception("Attempting to evaluate null");
  }
}

class Void extends Statement {
  @override
  Map<String, int> run(Map<String, int> env) {
    throw Exception("Attempting to run a Void statement.");
  }
}

class Number extends Expression {
  int num = 0;

  Number(this.num);

  @override
  int eval(Map<String, int> env) {
    Logger.debug("Getting number $num");
    return num;
  }
}

class Variable extends Expression {
  String name = "";

  Variable(this.name);

  @override
  int eval(Map<String, int> env) {
    if (env.containsKey(name)) {
      return env[name] ?? 0;
    }

    throw Exception("$name does not exist");
  }
}

class IfStatement extends Statement {
  Expression condition = Null();
  List<Statement> body = [Void()];

  IfStatement(this.condition, this.body);

  Map<String, int> _runBody(Map<String, int> env) {
    var tEnv = Map<String, int>.from(env);

    if (condition.eval(tEnv) != 0) {
      for (var stmt in body) {
        tEnv = stmt.run(tEnv);
      }
    }

    return env;
  }

  @override
  Map<String, int> run(Map<String, int> env) {
    return _runBody(env);
  }
}

class IfElseStatement extends IfStatement {
  List<Statement> elseBranch = [Void()];

  IfElseStatement(super.condition, super.body, this.elseBranch);

  @override
  Map<String, int> run(Map<String, int> env) {
    var tEnv = Map<String, int>.from(env);

    if (condition.eval(tEnv) != 0) {
      tEnv = _runBody(env);
    } else {
      for (var stmt in elseBranch) {
        stmt.run(env);
      }
    }

    return env;
  }
}

class EqualityExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  EqualityExpression(this.lhs, this.rhs);

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) == rhs.eval(env) ? 1 : 0;
  }
}

class InequalityExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  InequalityExpression(this.lhs, this.rhs);

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) != rhs.eval(env) ? 1 : 0;
  }
}

class GreaterThanExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  GreaterThanExpression(this.lhs, this.rhs);

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) > rhs.eval(env) ? 1 : 0;
  }
}

class GreaterOrEqualThanExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  GreaterOrEqualThanExpression(this.lhs, this.rhs);

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) >= rhs.eval(env) ? 1 : 0;
  }
}

class LessThanExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  LessThanExpression(this.lhs, this.rhs);

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) < rhs.eval(env) ? 1 : 0;
  }
}

class LessOrEqualThanExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  LessOrEqualThanExpression(this.lhs, this.rhs);

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) <= rhs.eval(env) ? 1 : 0;
  }
}

class ForStatement extends Statement {
  Statement initial = Void();
  Expression cond = Null();
  Statement assignment = Void();
  List<Statement> body = [Void()];

  ForStatement(this.initial, this.cond, this.assignment, this.body);

  @override
  Map<String, int> run(Map<String, int> env) {
    var tempEnv = Map<String, int>.from(env);
    tempEnv = initial.run(tempEnv);
    while (cond.eval(tempEnv) != 0) {
      for (var stmt in body) {
        tempEnv = stmt.run(tempEnv);
      }

      tempEnv = assignment.run(tempEnv);
    }

    //TODO: Copy old values.

    return env;
  }
}

class PrintStatement extends Statement {
  Expression e = Null();

  PrintStatement(this.e);

  @override
  Map<String, int> run(Map<String, int> env) {
    Logger.debug("Inside print statement.");
    print(e.eval(env));
    Logger.debug("Finished printing");
    return env;
  }
}

class DeclareStatement extends Statement {
  int size = 0;
  String name = "";

  DeclareStatement(this.size, this.name);

  @override
  Map<String, int> run(Map<String, int> env) {
    return env;
  }
}

class AssignmentStatement extends Statement {
  String ident = "";
  Expression e = Null();

  AssignmentStatement(this.ident, this.e);

  @override
  Map<String, int> run(Map<String, int> env) {
    var tEnv = Map<String, int>.from(env);

    tEnv[ident] = e.eval(tEnv);

    return tEnv;
  }
}

class AssignmentArrayStatement extends Statement {
  String v = "";
  int index = 0;
  Expression e = Null();

  AssignmentArrayStatement(this.v, this.index, this.e);

  @override
  Map<String, int> run(Map<String, int> env) {
    // TODO: implement run
    throw UnimplementedError();
  }
}

class PlusExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  PlusExpression(this.lhs, this.rhs);

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) + rhs.eval(env);
  }
}

class SubExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  SubExpression(this.lhs, this.rhs);

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) - rhs.eval(env);
  }
}

class MultExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) * rhs.eval(env);
  }
}

class DivideExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) ~/ rhs.eval(env);
  }
}

class ModExpression extends Expression {
  Expression lhs = Null();
  Expression rhs = Null();

  @override
  int eval(Map<String, int> env) {
    return lhs.eval(env) % rhs.eval(env);
  }
}

class InputExpression extends Expression {
  @override
  int eval(Map<String, int> env) {
    throw UnimplementedError();
  }
}

class ArrayExpression extends Expression {
  @override
  int eval(Map<String, int> env) {
    // TODO: implement eval
    throw UnimplementedError();
  }
}

class WhileStatement extends Statement {
  Expression cond = Null();
  List<Statement> body = [Void()];

  WhileStatement(this.cond, this.body);

  @override
  Map<String, int> run(Map<String, int> env) {
    var tEnv = Map<String, int>.from(env);

    while (cond.eval(tEnv) != 0) {
      for (var stmt in body) {
        tEnv = stmt.run(tEnv);
      }
    }

    //TODO: Copy old values.

    return tEnv;
  }
}

class Quote {
  String quote = "";

  Quote(this.quote);

  String eval() {
    return quote;
  }
}

class PrintQuoteStatement extends Statement {
  Quote q = Quote("");

  PrintQuoteStatement(this.q);

  @override
  Map<String, int> run(Map<String, int> env) {
    print(q.eval());

    return env;
  }
}

class Parser {
  int position = 0;

  List<Token> tokens = [];

  Parser(this.tokens);

  List<Statement> generateProgram() {
    Token currentToken = _getNextToken();
    List<Statement> statements = [];

    while (currentToken.type != TokenType.eof) {
      currentToken = _getNextToken();

      switch (currentToken.type) {
        case TokenType.identifierTok:
          var ass = _parseAssignment();
          if (_expect(TokenType.semiColonTok)) {
            statements.add(ass);
          } else {
            throw Exception(
                "Expected semicolon for assignment, but got ${_getNextToken().type}.");
          }
        case TokenType.printTok:
          position++;
          if (_expect(TokenType.lParenTok)) {
            position++;
            bool isQuote = false;
            String literal = "";

            Expression e = Null();

            if (_expect(TokenType.quoteTok)) {
              isQuote = true;
              literal = _getNextToken().literal;
              position++;
            } else {
              e = _parseExpression();
            }
            if (_expect(TokenType.rParenTok)) {
              position++;
              if (_expect(TokenType.semiColonTok)) {
                if (isQuote) {
                  statements.add(PrintQuoteStatement(Quote(literal)));
                } else {
                  statements.add(PrintStatement(e));
                }
              } else {
                throw Exception(
                    "Expected ; for print statement, but got ${_getNextToken().type}.");
              }
            } else {
              throw Exception(
                  "Expected ) for print statement but got ${_getNextToken().type}");
            }
          } else {
            throw Exception(
                "Expected ( for print statement, but got ${_getNextToken().type}.");
          }
        case TokenType.whileTok:
          position++;
          if (_expect(TokenType.lParenTok)) {
            position++;
            var cond = _parseBooleanExpression();
            if (_expect(TokenType.rParenTok)) {
              position++;
              if (_expect(TokenType.lBraceTok)) {
                position++;
                var body = _parseStatements();
                if (_expect(TokenType.rBraceTok)) {
                  statements.add(WhileStatement(cond, body));
                } else {
                  throw Exception(
                      "Expected } for while loop, but got ${_getNextToken().type}.");
                }
              } else {
                throw Exception(
                    "Expected { for while loop, but got ${_getNextToken().type}.");
              }
            } else {
              throw Exception(
                  "Expected ( for while loop, but got ${_getNextToken().type}.");
            }
          } else {
            throw Exception(
                "Expected ) for while statement, but got ${_getNextToken().type}.");
          }
        case TokenType.forTok:
          position++;
          if (_expect(TokenType.lParenTok)) {
            if (_expect(TokenType.semiColonTok)) {
              position++;
              var initial = _parseAssignment();
              position++;
              var cond = _parseBooleanExpression();
              if (_expect(TokenType.semiColonTok)) {
                var assignment = _parseAssignment();
                if (_expect(TokenType.rParenTok)) {
                  position++;
                  if (_expect(TokenType.lBraceTok)) {
                    var body = _parseStatements();
                    if (_expect(TokenType.rBraceTok)) {
                      ForStatement(initial, cond, assignment, body);
                    } else {
                      throw Exception(
                          "Expected } for for loop, but got ${_getNextToken().type}.");
                    }
                  } else {
                    throw Exception(
                        "Expected { for for loop, but got ${_getNextToken().type}.");
                  }
                } else {
                  throw Exception(
                      "Expected ) for for loop, but got ${_getNextToken().type}.");
                }
              } else {
                throw Exception(
                    "Expected second ; for for loop, but got ${_getNextToken().type}.");
              }
            } else {
              throw Exception(
                  "Expected first ; for for loop, but got ${_getNextToken().type}.");
            }
          } else {
            throw Exception(
                "Expected ( for for loop, but got ${_getNextToken().type}.");
          }
        case TokenType.ifTok:
          var ifExpression = _parseIfStatement();
          statements.add(ifExpression);
        case TokenType.eof:
          Logger.debug("Reached EOF");
        case _:
          throw Exception(
              "Syntax error ${currentToken.literal} is not meant to be there!");
      }

      position++;
    }

    return statements;
  }

  Token _getNextToken() {
    if (position >= tokens.length) {
      return Token(TokenType.eof, "");
    }

    return tokens[position];
  }

  bool _expect(TokenType type) {
    return _getNextToken().type == type;
  }

  Expression _parseBooleanExpression() {
    var lhs = _parseExpression();
    var operator = _getNextToken();
    position++;
    var rhs = _parseExpression();

    switch (operator.type) {
      case TokenType.lessThanTok:
        return LessThanExpression(lhs, rhs);
      case TokenType.lessOrEqualTok:
        return LessOrEqualThanExpression(lhs, rhs);
      case TokenType.equalityTok:
        return EqualityExpression(lhs, rhs);
      case TokenType.greaterOrEqualTok:
        return GreaterOrEqualThanExpression(lhs, rhs);
      case TokenType.greaterThanTok:
        return GreaterThanExpression(lhs, rhs);
      case TokenType.notEqualTok:
        return InequalityExpression(lhs, rhs);
      case _:
        throw Exception("Unknown boolean operator: ${operator.type}");
    }
  }

  Statement _parseIfStatement() {
    if (_expect(TokenType.ifTok)) {
      position++;
      if (_expect(TokenType.lParenTok)) {
        position++;
        var cond = _parseBooleanExpression();
        if (_expect(TokenType.rParenTok)) {
          position++;
          if (_expect(TokenType.lBraceTok)) {
            position++;
            var body = _parseStatements();
            if (_expect(TokenType.rBraceTok)) {
              position++;
              if (_expect(TokenType.elseTok)) {
                position++;
                if (_expect(TokenType.lBraceTok)) {
                  var elseBranch = _parseStatements();
                  if (_expect(TokenType.rBraceTok)) {
                    return IfElseStatement(cond, body, elseBranch);
                  } else {
                    throw Exception(
                        "Expected } on else statement, but got ${_getNextToken().type}.");
                  }
                } else {
                  throw Exception(
                      "Expected { on else statement, but got ${_getNextToken().type}.");
                }
              } else {
                return IfStatement(cond, body);
              }
            } else {
              throw Exception(
                  "Expected } on if statement, but got ${_getNextToken().type}.");
            }
          } else {
            throw Exception(
                "Expected { on else statement, but got ${_getNextToken().type}.");
          }
        } else {
          throw Exception(
              "Expected ) on else statement, but got ${_getNextToken().type}.");
        }
      } else {
        throw Exception(
            "Expected ( on else statement, but got ${_getNextToken().type}.");
      }
    } else {
      throw Exception("How?");
    }
  }

  List<Statement> _parseStatements() {
    int numberOfBrackets = 0;

    List<Token> tokens = [];

    while (_getNextToken().type != TokenType.eof && numberOfBrackets >= 0) {
      if (_getNextToken().type == TokenType.lBraceTok) {
        numberOfBrackets++;
      }

      if (_getNextToken().type == TokenType.rBraceTok) {
        if (numberOfBrackets == 0) {
          break;
        }

        numberOfBrackets--;
      }

      tokens.add(_getNextToken());

      position++;
    }

    if (_getNextToken().type == TokenType.eof && numberOfBrackets >= 0) {
      throw Exception("Expected } on while loop.");
    }

    var subParser = Parser(tokens);

    return subParser.generateProgram();
  }

  AssignmentStatement _parseAssignment() {
    var ident = _getNextToken();
    position++;
    if (_expect(TokenType.assignTok)) {
      position++;
      var exp = _parseExpression();
      return AssignmentStatement(ident.literal, exp);
    }

    throw Exception(
        "Expected = on assignment, but got ${_getNextToken().type}.");
  }

  Expression _parseExpression() {
    // iterate through and create a list of all sensible tokens.

    List<Token> goodTokens = [];
    List<TokenType> goodTypes = [
      TokenType.numberTok,
      TokenType.identifierTok,
      TokenType.plusTok,
      TokenType.subtractTok,
      TokenType.multiplyTok,
      TokenType.divideTok,
      TokenType.modulusTok,
    ];

    while (goodTypes.contains(_getNextToken().type)) {
      goodTokens.add(_getNextToken());
      position++;
    }

    return _parseExpressionWrap(goodTokens);
  }

  Expression _parseExpressionWrap(List<Token> tokens) {
    var (hasPlus, lhsPlus, rhsPlus) =
        utils.parseSplit(tokens, TokenType.plusTok);
    if (hasPlus) {
      return PlusExpression(
          _parseExpressionWrap(lhsPlus), _parseExpressionWrap(rhsPlus));
    }

    var (hasSub, lhsSub, rhsSub) =
        utils.parseSplit(tokens, TokenType.subtractTok);
    if (hasSub) {
      return SubExpression(
          _parseExpressionWrap(lhsSub), _parseExpressionWrap(rhsSub));
    }

    var (hasMult, lhsMult, rhsMult) =
        utils.parseSplit(tokens, TokenType.multiplyTok);
    if (hasMult) {
      return SubExpression(
          _parseExpressionWrap(lhsMult), _parseExpressionWrap(rhsMult));
    }

    var (hasDiv, lhsDiv, rhsDiv) =
        utils.parseSplit(tokens, TokenType.divideTok);
    if (hasDiv) {
      return SubExpression(
          _parseExpressionWrap(lhsDiv), _parseExpressionWrap(rhsDiv));
    }

    if (tokens.length == 1) {
      switch (tokens[0].type) {
        case TokenType.numberTok:
          return Number(int.parse(tokens[0].literal));
        case TokenType.identifierTok:
          return Variable(tokens[0].literal);
        case _:
          throw Exception("Syntax Error parsing expression. tokens: $tokens");
      }
    }

    print("Error!!");

    Lexer.prettyPrint(tokens);

    throw Exception("Syntax error parsing expression");
  }
}
