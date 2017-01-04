part of grinder_coveralls;

/// Runs the specified [script] and returns its code coverage in LCOV format.
///
/// The [arguments] list provides the optional script arguments.
/// The [output] path specifies the optional destination file.
String collectCoverage(dynamic script, {List<String> arguments, String output}) {
  var path = script is FilePath ? script : new FilePath(script);
  var coverage = new Coverage().collect(path.asFile, arguments: arguments);
  if (output != null) getFile(output).writeAsStringSync(coverage);
  return coverage;
}

/// Runs asynchronously the specified [script] and returns its code coverage in LCOV format.
///
/// The [arguments] list provides the optional script arguments.
/// The [output] path specifies the optional destination file.
Future<String> collectCoverageAsync(dynamic script, {List<String> arguments, String output}) async {
  var path = script is FilePath ? script : new FilePath(script);
  var coverage = await new Coverage().collectAsync(path.asFile, arguments: arguments);
  if (output != null) await getFile(output).writeAsString(coverage);
  return coverage;
}

/// Collects the code coverage of a Dart script in [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
class Coverage {

  /// Creates a new coverage collector.
  Coverage({this.basePath, this.packagesPath = '.packages', this.reportOn = const ['lib/']});

  /// If provided, paths are reported relative to that path.
  String basePath;

  /// The path to the packages specification file.
  String packagesPath;

  /// If provided, coverage report output is limited to files prefixed with one of the paths included.
  List<String> reportOn;

  /// Runs the specified [script] and returns its code coverage in LCOV format.
  String collect(File script, {List<String> arguments, Duration timeout}) {
    var output;
    new Future<String>
      .sync(() => collectAsync(script, arguments: arguments, timeout: timeout))
      .then((coverage) => output = coverage);

    return output;
  }

  /// Runs asynchronously the specified [script] and returns its code coverage in LCOV format.
  Future<String> collectAsync(File script, {List<String> arguments, Duration timeout}) async {
    assert(script != null);
    if (!await script.exists())
      throw new ArgumentError.value(script, 'script', 'The specified file does not exist.');

    var coverage = await runAndCollect(script.path, scriptArgs: arguments);
    var resolver = new Resolver(packagesPath: packagesPath, sdkRoot: sdkDir.path);
    return await new LcovFormatter(resolver, basePath: basePath, reportOn: reportOn).format(coverage);
  }
}
