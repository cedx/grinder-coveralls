part of '../grinder_coveralls.dart';

/// Collects the coverage data of a Dart script as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
class Collector {

  /// Creates a new coverage collector.
  Collector({this.packagesFile, this.timeout});

  /// The path to the packages specification file.
  File packagesFile;

  /// The maximum duration that must not be exceeded before a `TimeoutException` is thrown.
  Duration timeout;

  /// Profiles the test files of the specified [source] directory and returns their coverage data as LCOV format.
  ///
  /// The directory will be scanned, according to the value of the [recurse] parameter, for files matching the specified [pattern].
  /// If [basePath] is provided, paths are reported relative to this path.
  /// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
  Future<String> collectFromDirectory(Directory source, {String basePath, String pattern = '*.dart', bool recurse = false, List<String> reportOn}) async =>
    collectFromFiles(FileSet.fromDir(source, pattern: pattern, recurse: recurse).files, basePath: basePath, reportOn: reportOn);

  /// Profiles the specified [source] file and returns its coverage data as LCOV format.
  ///
  /// The [arguments] list provides the script arguments.
  /// If [basePath] is provided, paths are reported relative to this path.
  /// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
  Future<String> collectFromFile(File source, {List<String> arguments, String basePath, List<String> reportOn}) async {
    final hitmap = await _profileScript(source, arguments: arguments);
    final resolver = Resolver(packagesPath: packagesFile?.path, sdkRoot: sdkDir.path);
    return LcovFormatter(resolver, basePath: basePath, reportOn: reportOn).format(hitmap);
  }

  /// Profiles the specified source files and returns their coverage data as LCOV format.
  ///
  /// If [basePath] is provided, paths are reported relative to this path.
  /// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
  Future<String> collectFromFiles(Iterable<File> sources, {String basePath, List<String> reportOn}) async {
    final hash = md5.convert(utf8.encode(DateTime.now().toIso8601String()));
    final output = joinFile(Directory.systemTemp, ['grinder_coveralls_$hash.g.dart']);
    await output.writeAsString(_generateEntryScript(sources));
    await getFile('/home/cedric/Bureau/grinder_coveralls.g.dart').writeAsString(_generateEntryScript(sources)); // TODO: remove it!!!
    return collectFromFile(output, basePath: basePath, reportOn: reportOn);
  }

  /// Generates the entry script corresponding to the specified source files.
  String _generateEntryScript(Iterable<File> sources) {
    final code = Library((library) {
      library.directives.add(Directive((directive) => directive
        ..type = DirectiveType.import
        ..url = 'package:test/test.dart'
      ));

      final statements = <Code>[];
      for (final source in sources) {
        final name = '_\$test_${md5.convert(utf8.encode(source.absolute.path))}';
        statements.add(Code('$name.main()'));

        library.directives.add(Directive((directive) => directive
          ..type = DirectiveType.import
          ..url = p.posix.normalize(source.absolute.path)
          ..as = name
        ));
      }

      library.body.add(Method.returnsVoid((method) => method
        ..name = 'main'
        ..body = Block.of(statements)
      ));
    });

    return "@TestOn('vm')\n${code.accept(DartEmitter()).toString()}";
  }

  /// Runs the specified [script] and collects its coverage data as hitmap.
  /// Throws a [FileSystemException] if the script is not found.
  Future<Map> _profileScript(File script, {List<String> arguments}) async {
    if (!script.existsSync()) throw FileSystemException('The specified script is not found.', script.path);
    final report = await runAndCollect(script.path, scriptArgs: arguments, timeout: timeout);
    return report.containsKey('coverage') ? createHitmap(report['coverage']) : <String, Map<int, int>>{};
  }
}
