import 'package:jwhile/evaluator.dart';
import 'package:jwhile/lexer.dart';
import 'package:jwhile/logger.dart';
import 'package:jwhile/parser.dart';

void main(List<String> arguments) {
  var input = "a = 4; print(a);";

  Logger.setWarning();

  print("Input: $input");

  var lexer = Lexer(input);

  var tokens = lexer.getTokens();

  print("Tokens:");
  Lexer.prettyPrint(tokens);

  var parser = Parser(tokens);

  var parsed = parser.generateProgram();

  print("Parsed Program: $parsed");

  var eval = Evaluator(parsed);

  print("Executing:");

  eval.execute();

  Logger.setWarning();
}
