enum Level { none, debug, info, warning, error }

class Logger {
  static Level _logLevel = Level.debug;

  static void debug(String s) {
    switch (_logLevel) {
      case Level.debug:
        print(s);
      case _:
    }
  }

  static void info(String s) {
    switch (_logLevel) {
      case Level.debug:
      case Level.info:
        print(s);
      case _:
    }
  }

  static void warning(String s) {
    switch (_logLevel) {
      case Level.debug:
      case Level.info:
      case Level.warning:
        print(s);
      case _:
    }
  }

  static void error(String s) {
    switch (_logLevel) {
      case Level.debug:
      case Level.info:
      case Level.warning:
      case Level.error:
        print(s);
      case _:
    }
  }

  static void setDebug() {
    _logLevel = Level.debug;
  }

  static void setInfo() {
    _logLevel = Level.info;
  }

  static void setWarning() {
    _logLevel = Level.warning;
  }

  static void setError() {
    _logLevel = Level.error;
  }

  static void setNone() {
    _logLevel = Level.none;
  }
}
