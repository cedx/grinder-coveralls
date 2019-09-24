part of '../grinder_coveralls.dart';

/// Collects the coverage data of a Dart script as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
class Collector {

  /// Creates a new collector.
  Collector({InternetAddress observatoryAddress, this.observatoryPort = 8181}):
    observatoryAddress = observatoryAddress ?? InternetAddress.loopbackIPv4;

  /// The absolute base path to use for resolving the reported paths.
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

  /// The maximum duration that must not be exceeded before a [TimeoutException] is thrown.
  Duration timeout;

  /// Profiles the test scripts corresponding to the specified file [patterns], and returns their coverage data as LCOV format.
  /// Throws a [FileSystemException] if no test files were found.
  ///
  /// The file patterns are resolved against a given [root] path, which defaults to the current working directory.
  /// Additional [arguments] can be passed to the Dart executable that runs the tests.
  Future<String> run(Iterable<Glob> patterns, {List<String> arguments, Directory root}) async {
    root ??= Directory.current;

    final entities = <FileSystemEntity>[];
    for (final pattern in patterns) entities.addAll(await pattern.list(root: root.path).toList());
    final testFiles = entities.whereType<File>().toList();
    if (testFiles.isEmpty) throw const FileSystemException('No test files were found.');

    final entryScript = testFiles.length > 1 ? await _generateEntryScript(testFiles) : testFiles.first;
    final coverage = await _profileScript(entryScript, arguments: arguments);
    final resolver = Resolver(packagesPath: packagesFile?.path, sdkRoot: sdkDir.path);
    return LcovFormatter(resolver, basePath: basePath, reportOn: reportOn).format(coverage);
  }

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
    await outputFile.writeAsString(code.accept(DartEmitter()).toString(), flush: true);
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
