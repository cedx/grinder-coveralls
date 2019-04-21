part of '../grinder_coveralls.dart';

/// Profiles the specified [source] file or directory containing test files, and returns the collected coverage data as LCOV format.
///
/// If [basePath] is provided, paths are reported relative to this path.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [saveAs] is provided, coverage report output will be written to a file at the given path.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
Future<String> collectCoverage(FileSystemEntity source, {
  String basePath,
  Object packagesFile,
  List<String> reportOn,
  Object saveAs,
  Duration timeout
}) async {
  final collect = source is Directory ? collectFromDirectory : collectFromFile;
  final coverage = await collect(source, basePath: basePath, packagesFile: packagesFile, reportOn: reportOn, timeout: timeout);
  if (saveAs != null) await FilePath(saveAs).asFile.writeAsString(coverage);
  return coverage;
}

/// Profiles the test files of the specified source [directory] and returns their coverage data as LCOV format.
///
/// The directory will be scanned, according to the value of the [recurse] parameter, for files matching the specified [pattern].
/// If [basePath] is provided, paths are reported relative to this path.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
Future<String> collectFromDirectory(Object directory, {
  String basePath,
  Object packagesFile,
  String pattern = '*_test.dart',
  bool recurse = true,
  List<String> reportOn,
  Duration timeout
}) => Collector(packagesFile: FilePath(packagesFile ?? '.packages').asFile, timeout: timeout)
  .collectFromDirectory(FilePath(directory).asDirectory, basePath: basePath, pattern: pattern, recurse: recurse, reportOn: reportOn);

/// Profiles the specified source [file] and returns its coverage data as LCOV format.
///
/// The [arguments] list provides the script arguments.
/// If [basePath] is provided, paths are reported relative to this path.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
Future<String> collectFromFile(Object file, {
  List<String> arguments,
  String basePath,
  Object packagesFile,
  List<String> reportOn,
  Duration timeout
}) => Collector(packagesFile: FilePath(packagesFile ?? '.packages').asFile, timeout: timeout)
  .collectFromFile(FilePath(file).asFile, arguments: arguments, basePath: basePath, reportOn: reportOn);

/// Profiles the specified source [files] and returns their coverage data as LCOV format.
///
/// If [basePath] is provided, paths are reported relative to this path.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
Future<String> collectFromFiles(Iterable files, {
  String basePath,
  Object packagesFile,
  List<String> reportOn,
  Duration timeout
}) => Collector(packagesFile: FilePath(packagesFile ?? '.packages').asFile, timeout: timeout)
  .collectFromFiles(files.map((source) => FilePath(source).asFile), basePath: basePath, reportOn: reportOn);

/// Uploads the specified code coverage [report], in Clover or LCOV format, to the Coveralls service.
Future<void> uploadCoverage(String report, {Configuration configuration, Uri endPoint}) => Client(endPoint).upload(report, configuration);

/// Uploads the specified code coverage [report], in Clover or LCOV format, to the Coveralls service.
Future<void> uploadCoverageFile(Object report, {Configuration configuration, Uri endPoint}) async =>
  uploadCoverage(await FilePath(report).asFile.readAsString(), configuration: configuration, endPoint: endPoint);
