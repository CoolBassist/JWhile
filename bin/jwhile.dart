import 'package:jwhile/evaluator.dart';
import 'package:jwhile/lexer.dart';
import 'package:jwhile/logger.dart';
import 'package:jwhile/parser.dart';
import 'dart:io';

/* 

An interpreter for the JWhile language, written in Dart.

*/

void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    var program = File(arguments[0]);

    program.exists().then((res) {
      if (!res) {
        print("\"${arguments[0]}\" does not exist!");
        exit(0);
      }
    });

    program.readAsString().then((input) {
      var lexer = Lexer(input);
      var parser = Parser(lexer.getTokens());
      var eval = Evaluator(parser.generateProgram());
      eval.execute({});
    });

    return;
  }

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
}
