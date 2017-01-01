part of grinder_coveralls;

/// Collects the code coverage in [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
class Coverage {

  /// TODO
  Coverage(this.scriptPath, {this.scriptArgs});

  /// TODO
  List<String> scriptArgs;

  /// TODO
  String scriptPath;

  /// Runs the specified [script] and returns its code coverage in LCOV format.
  /// The [arguments] list provides the optional script arguments.
  String collect() {
    var lcov;
    new Future<String>.sync(() => collectAsync()).then((coverage) => lcov = coverage);
    return lcov;
  }

  /// Runs asynchronously the specified [script] and returns its code coverage in LCOV format.
  /// The [arguments] list provides the optional script arguments.
  Future<String> collectAsync() async {
    var coverage = await runAndCollect(this.scriptPath, scriptArgs: this.scriptArgs);
    return await new LcovFormatter(new Resolver()).format(coverage);
  }
}
