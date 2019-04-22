/// [Grinder](https://google.github.io/grinder.dart) plug-in collecting the code coverage and uploading it to [Coveralls](https://coveralls.io).
library grinder_coveralls;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:code_builder/code_builder.dart';
import 'package:coverage/coverage.dart';
import 'package:coveralls/coveralls.dart';
import 'package:crypto/crypto.dart';
import 'package:grinder/grinder.dart' hide ProcessException;
import 'package:path/path.dart' as p;

part 'src/collector.dart';
part 'src/functions.dart';

/// Profiles the specified [source] file or directory containing test files, and returns the collected coverage data as LCOV format.
///
/// If [basePath] is provided, paths are reported relative to this path.
/// If [environment] is provided, its entries will be injected as compile-time constants.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [saveAs] is provided, coverage report output will be written to a file at the given path.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
Future<String> collectCoverage(FileSystemEntity source, {
  String basePath,
  Map<String, String> environment,
  String observatoryAddress,
  int observatoryPort = 8181,
  Object packagesFile,
  List<String> reportOn,
  Object saveAs,
  bool silent = false,
  Duration timeout
}) async {
  final collect = source is Directory ? collectFromDirectory : collectFromFile;
  final coverage = await collect(
    source,
    basePath: basePath,
    environment: environment,
    observatoryAddress: observatoryAddress,
    observatoryPort: observatoryPort,
    packagesFile: packagesFile,
    reportOn: reportOn,
    silent: silent,
    timeout: timeout
  );

  if (saveAs != null) await FilePath(saveAs).asFile.writeAsString(coverage);
  return coverage;
}

/// Uploads the specified code coverage [report], in Clover or LCOV format, to the Coveralls service.
Future<void> uploadCoverage(String report, {Configuration configuration, Uri endPoint}) => Client(endPoint).upload(report, configuration);
