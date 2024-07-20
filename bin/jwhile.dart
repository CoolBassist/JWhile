import 'package:jwhile/evaluator.dart';
import 'package:jwhile/lexer.dart';
import 'package:jwhile/logger.dart';
import 'package:jwhile/parser.dart';
import 'dart:io';

void main(List<String> arguments) {
  print("JWhile Interpreter V1.0");

  String? input = "";

  Map<String, int> env = {};

  Logger.setNone();

  while (true) {
    stdout.write(">>> ");
    input = stdin.readLineSync() ?? "";

    if (input == "exit") {
      break;
    }

    var lexer = Lexer(input);
    var parser = Parser(lexer.getTokens());
    var eval = Evaluator(parser.generateProgram());

    env = eval.execute(env);
  }

  //var input = "a = 0; while(a <= 10){ print(a); a = a + 1;   } ";

  /*Logger.setWarning();

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

  Logger.setNone();*/
}
