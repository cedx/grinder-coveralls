part of '../grinder_coveralls.dart';

/// Collects the coverage data of a Dart script as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
class Collector {

  /// Creates a new collector.
  Collector({InternetAddress observatoryAddress, this.observatoryPort = 8181}):
    observatoryAddress = observatoryAddress ?? InternetAddress.loopbackIPv4;

  /// The base path to use for resolving the reported paths.
  String basePath;

  /// The variables that will be injected as compile-time constants.
  Map<String, String> environment;

  /// The address of the Observatory profiler.
  final InternetAddress observatoryAddress;

  /// The port of the Observatory profiler.
  final int observatoryPort;

  /// The path to the packages specification file.
  File packagesFile;

  /// The prefixes used to limit the files included in the coverage report output.
  List<String> reportOn;

  /// Value indicating whether to silent the collector output.
  bool silent = true;

  /// The maximum duration that must not be exceeded before a `TimeoutException` is thrown.
  Duration timeout;

  /// Profiles the test files of the specified [source] directory and returns their coverage data as LCOV format.
  ///
  /// Uses the specified file [pattern] to match the eligible Dart scripts.
  /// A [recurse] value indicates whether to process the input directory recursively.
  Future<String> collectFromDirectory(Directory source, {String pattern = '*.dart', bool recurse = false}) async =>
    collectFromFiles(FileSet.fromDir(source, pattern: pattern, recurse: recurse).files);

  /// Profiles the specified [source] file and returns its coverage data as LCOV format.
  Future<String> collectFromFile(File source, {List<String> arguments}) async {
    final coverage = await _profileScript(source, arguments: arguments);
    final resolver = Resolver(packagesPath: packagesFile?.path, sdkRoot: sdkDir.path);
    return LcovFormatter(resolver, basePath: basePath, reportOn: reportOn).format(coverage);
  }

  /// Profiles the specified source files and returns their coverage data as LCOV format.
  Future<String> collectFromFiles(Iterable<File> sources) async => collectFromFile(await _generateEntryScript(sources));

  /// Generates an entry script corresponding to the specified source files.
  /// Returns a reference to the generated file.
  Future<File> _generateEntryScript(Iterable<File> sources) async {
    final outputDir = getDir('.dart_tool/grinder_coveralls');
    await outputDir.create(recursive: true);

    final code = Library((library) {
      final statements = <Code>[];
      for (final source in sources) {
        final name = 'test_${md5.convert(utf8.encode(source.absolute.path))}';
        statements.add(Code('$name.main();'));

        library.directives.add(Directive((directive) => directive
          ..type = DirectiveType.import
          ..url = Uri.file(source.absolute.path).toString()
          ..as = name
        ));
      }

      library.body.add(Method.returnsVoid((method) => method
        ..name = 'main'
        ..body = Block.of(statements)
      ));
    });

    final outputFile = joinFile(outputDir, ['test_${DateTime.now().millisecondsSinceEpoch}.dart']);
    await outputFile.writeAsString(code.accept(DartEmitter()).toString());
    return outputFile;
  }

  /// Runs the specified [script] and collects its coverage data as hitmap.
  ///
  /// Throws a [ProcessException] if the process terminated with a non-zero exit code.
  /// Throws a [TimeoutException] if the process does not terminate before the [timeout] has passed.
  Future<Map> _profileScript(File script, {List<String> arguments}) async {
    final dartArgs = [
      '--enable-asserts',
      '--enable-vm-service=$observatoryPort/${observatoryAddress.address}',
      '--pause-isolates-on-exit',
      if (environment != null) for (final entry in environment.entries) '-D${entry.key}=${entry.value}',
      script.path,
      ...?arguments
    ];

    final serviceUriCompleter = Completer<Uri>();
    final process = await Process.start('dart', dartArgs);
    process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
      if (!silent) log(line);
      if (!serviceUriCompleter.isCompleted) {
        final match = RegExp(r'^Observatory listening on (.*)$').firstMatch(line);
        final uri = match != null ? match[1].trim() : 'http://${observatoryAddress.address}:$observatoryPort/';
        serviceUriCompleter.complete(Uri.parse(uri));
      }
    });

    Map<String, dynamic> report;
    try { report = await collect(await serviceUriCompleter.future, true, true, false, null, timeout: timeout); }
    finally { await process.stderr.drain(); }

    final exitCode = await process.exitCode;
    if (exitCode != 0) throw ProcessException(script.absolute.path, arguments, 'Script terminated with exit code $exitCode.', exitCode);
    return report.containsKey('coverage') ? createHitmap(report['coverage']) : <String, Map<int, int>>{};
  }
}
