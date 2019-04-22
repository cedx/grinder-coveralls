part of '../grinder_coveralls.dart';

/// Profiles the test files of the specified source [directory] and returns their coverage data as LCOV format.
///
/// The directory will be scanned, according to the value of the [recurse] parameter, for files matching the specified [pattern].
/// If [basePath] is provided, paths are reported relative to this path.
/// If [environment] is provided, its entries will be injected as compile-time constants.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
Future<String> collectFromDirectory(Object directory, {
  String basePath,
  Map<String, String> environment,
  String observatoryAddress,
  int observatoryPort = 8181,
  Object packagesFile,
  String pattern = '*_test.dart',
  bool recurse = true,
  List<String> reportOn,
  bool silent = false,
  Duration timeout
}) => (Collector()
  ..basePath = basePath
  ..environment = environment
  ..observatoryAddress = InternetAddress(observatoryAddress ?? InternetAddress.loopbackIPv4.address)
  ..observatoryPort = observatoryPort
  ..packagesFile = FilePath(packagesFile ?? '.packages').asFile
  ..reportOn = reportOn
  ..silent = silent
  ..timeout = timeout
).collectFromDirectory(FilePath(directory).asDirectory, pattern: pattern, recurse: recurse);

/// Profiles the specified source [file] and returns its coverage data as LCOV format.
///
/// The [arguments] list provides the script arguments.
/// If [basePath] is provided, paths are reported relative to this path.
/// If [environment] is provided, its entries will be injected as compile-time constants.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
Future<String> collectFromFile(Object file, {
  List<String> arguments,
  String basePath,
  Map<String, String> environment,
  String observatoryAddress,
  int observatoryPort = 8181,
  Object packagesFile,
  List<String> reportOn,
  bool silent = false,
  Duration timeout
}) => (Collector()
  ..basePath = basePath
  ..environment = environment
  ..observatoryAddress = InternetAddress(observatoryAddress ?? InternetAddress.loopbackIPv4.address)
  ..observatoryPort = observatoryPort
  ..packagesFile = FilePath(packagesFile ?? '.packages').asFile
  ..reportOn = reportOn
  ..silent = silent
  ..timeout = timeout
).collectFromFile(FilePath(file).asFile, arguments: arguments);

/// Profiles the specified source [files] and returns their coverage data as LCOV format.
///
/// If [basePath] is provided, paths are reported relative to this path.
/// If [environment] is provided, its entries will be injected as compile-time constants.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
Future<String> collectFromFiles(Iterable files, {
  String basePath,
  Map<String, String> environment,
  String observatoryAddress,
  int observatoryPort = 8181,
  Object packagesFile,
  List<String> reportOn,
  bool silent = false,
  Duration timeout
}) => (Collector()
  ..basePath = basePath
  ..environment = environment
  ..observatoryAddress = InternetAddress(observatoryAddress ?? InternetAddress.loopbackIPv4.address)
  ..observatoryPort = observatoryPort
  ..packagesFile = FilePath(packagesFile ?? '.packages').asFile
  ..reportOn = reportOn
  ..silent = silent
  ..timeout = timeout
).collectFromFiles(files.map((source) => FilePath(source).asFile));

/// Uploads the specified code coverage [report], in Clover or LCOV format, to the Coveralls service.
Future<void> uploadCoverageFile(Object report, {Configuration configuration, Uri endPoint}) async =>
  uploadCoverage(await FilePath(report).asFile.readAsString(), configuration: configuration, endPoint: endPoint);
