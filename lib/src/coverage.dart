part of grinder_coveralls;

/// Collects the coverage data of a Dart script as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
class Coverage {

  /// Creates a new coverage collector.
  Coverage({this.basePath, this.packagesPath = '.packages', this.reportOn = const ['lib/']});

  /// If provided, paths are reported relative to that path.
  String basePath;

  /// The path to the packages specification file.
  String packagesPath;

  /// If provided, coverage report output is limited to files prefixed with one of the paths included.
  List<String> reportOn;

  /// Runs the specified [script] and returns its coverage data as LCOV format.
  String collect(File script, {List<String> arguments, bool checked = true, Duration timeout}) {
    var coverage;
    new Future<String>
      .sync(() => collectAsync(script, arguments: arguments, checked: checked, timeout: timeout))
      .then((cov) => coverage = cov);

    return coverage;
  }

  /// Runs asynchronously the specified [script] and returns its coverage data as LCOV format.
  Future<String> collectAsync(File script, {List<String> arguments, bool checked = true, Duration timeout}) async {
    assert(script != null);
    if (!await script.exists())
      throw new ArgumentError.value(script, 'script', 'The specified file does not exist.');

    var coverage = await runAndCollect(script.path, checked: checked, scriptArgs: arguments, timeout: timeout);
    var resolver = new Resolver(packagesPath: packagesPath, sdkRoot: sdkDir.path);
    return await new LcovFormatter(resolver, basePath: basePath, reportOn: reportOn).format(coverage);
  }
}
