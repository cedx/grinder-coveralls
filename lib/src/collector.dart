part of '../grinder_coveralls.dart';

/// Collects the coverage data of a Dart script as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
class Collector {

  /// The base path to use for resolving the reported paths.
  String basePath;

  /// The variables that will be injected as compile-time constants.
  Map<String, String> environment;

  /// The address of the Observatory profiler.
  InternetAddress observatoryAddress = InternetAddress.loopbackIPv4;

  /// The port of the Observatory profiler.
  int observatoryPort = 8181;

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
  /// The directory will be scanned, according to the value of the [recurse] parameter, for files matching the specified [pattern].
  /// If [environment] is provided, its entries will be injected as compile-time constants.
  Future<String> collectFromDirectory(Directory source, {String pattern = '*.dart', bool recurse = false}) async =>
    collectFromFiles(FileSet.fromDir(source, pattern: pattern, recurse: recurse).files);

  /// Profiles the specified [source] file and returns its coverage data as LCOV format.
  ///
  /// The [arguments] list provides the script arguments.
  /// If [environment] is provided, its entries will be injected as compile-time constants.
  Future<String> collectFromFile(File source, {List<String> arguments}) async {
    final hitmap = await _profileScript(source, arguments: arguments);
    final resolver = Resolver(packagesPath: packagesFile?.path, sdkRoot: sdkDir.path);
    return LcovFormatter(resolver, basePath: basePath, reportOn: reportOn).format(hitmap);
  }

  /// Profiles the specified source files and returns their coverage data as LCOV format.
  /// If [environment] is provided, its entries will be injected as compile-time constants.
  Future<String> collectFromFiles(Iterable<File> sources) async {
    final hash = md5.convert(utf8.encode(DateTime.now().toIso8601String()));
    final output = joinFile(Directory.systemTemp, ['grinder_coveralls_$hash.g.dart']);
    await output.writeAsString(_generateEntryScript(sources));
    return collectFromFile(output);
  }

  /// Generates the entry script corresponding to the specified source files.
  String _generateEntryScript(Iterable<File> sources) {
    final code = Library((library) {
      final statements = <Code>[];
      for (final source in sources) {
        final name = 'test_${md5.convert(utf8.encode(source.absolute.path))}';
        statements.add(Code('$name.main();'));

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

    return code.accept(DartEmitter()).toString();
  }

  /// Runs the specified [script] and collects its coverage data as hitmap.
  /// Throws a [ProcessException] if the process exited with a non-zero exit code.
  Future<Map> _profileScript(File script, {List<String> arguments}) async {
    final dartArgs = ['--enable-vm-service=$observatoryPort/${observatoryAddress.address}', '--pause-isolates-on-exit'];
    if (environment != null) dartArgs.addAll(environment.entries.map((entry) => '-D${entry.key}=${entry.value}'));
    dartArgs.add(script.path);
    if (arguments != null) dartArgs.addAll(arguments);

    final serviceUriCompleter = Completer<Uri>();
    final process = await Process.start('dart', dartArgs, environment: environment);
    process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
      if (!silent) log(line);
      if (!serviceUriCompleter.isCompleted) {
        final match = RegExp(r'^Observatory listening on (.*)$').firstMatch(line);
        final uri = match != null ? match[1].trim() : 'http://${observatoryAddress.address}:$observatoryPort/';
        serviceUriCompleter.complete(Uri.parse(uri));
      }
    });

    Map<String, dynamic> report;
    try { report = await collect(await serviceUriCompleter.future, true, true, timeout: timeout); }
    finally { await process.stderr.drain(); }

    final exitCode = await process.exitCode;
    if (exitCode != 0) throw ProcessException(script.absolute.path, arguments, 'Script terminated with exit code $exitCode.', exitCode);
    return report.containsKey('coverage') ? createHitmap(report['coverage']) : <String, Map<int, int>>{};
  }
}
