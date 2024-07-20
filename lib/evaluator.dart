import 'package:jwhile/parser.dart';

class Evaluator {
  int position = 0;

  List<Statement> program = [];

  Evaluator(this.program);

  Map<String, int> env = {};

  void execute() {
    for (var stmt in program) {
      env = stmt.run(env);
    }
  }
}
