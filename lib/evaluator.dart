import 'package:jwhile/parser.dart';

class Evaluator {
  int position = 0;

  List<Statement> program = [];

  Evaluator(this.program);

  Map<String, int> execute(Map<String, int> env) {
    for (var stmt in program) {
      env = stmt.run(env);
    }

    return env;
  }
}
