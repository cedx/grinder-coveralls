part of grinder_coveralls;

/// Collects the coverage data of a Dart script as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
class Collector {

  /// Creates a new coverage collector.
  Collector({this.basePath, this.packagesPath = '.packages', List<String> reportOn}) : reportOn = reportOn ?? ['lib'];

  /// If provided, paths are reported relative to that path.
  String basePath;

  /// The path to the packages specification file.
  String packagesPath;

  /// If provided, coverage report output is limited to files prefixed with one of the paths included.
  final List<String> reportOn;

  /// Runs the specified [script] and returns its coverage data as LCOV format.
  Future<String> collect(File script, {List<String> arguments, bool checked = true, Duration timeout}) async {
    var hitmap = await collectHitmap(script, arguments: arguments, checked: checked, timeout: timeout);
    var resolver = new Resolver(packagesPath: packagesPath, sdkRoot: sdkDir.path);
    return new LcovFormatter(resolver, basePath: basePath, reportOn: reportOn).format(hitmap);
  }

  /// Runs the specified [script] and returns its coverage data as hitmap.
  /// Throws a [FileSystemException] if the script is not found.
  Future<Map> collectHitmap(File script, {List<String> arguments, bool checked = true, Duration timeout}) async {
    assert(script != null);
    if (!await script.exists())
      throw new FileSystemException('The specified file is not found.', script.path);

    var report = await runAndCollect(script.path, checked: checked, scriptArgs: arguments, timeout: timeout);
    return report.containsKey('coverage') ? createHitmap(report['coverage']) : const {};
  }
}
