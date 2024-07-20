import 'package:jwhile/lexer.dart';

(bool, List<Token> lhs, List<Token> rhs) parseSplit(
    List<Token> tokens, TokenType type) {
  for (int i = 0; i < tokens.length; i++) {
    if (tokens[i].type == type) {
      return (true, tokens.sublist(0, i), tokens.sublist(i + 1, tokens.length));
    }
  }

  return (false, tokens, []);
}
