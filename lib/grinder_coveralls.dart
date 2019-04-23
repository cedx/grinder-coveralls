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

part 'src/collector.dart';

/// Profiles the specified [source] file or directory containing test files, and returns the collected coverage data as LCOV format.
///
/// If [source] is a directory, it will be scanned according to the value of the [recurse] parameter for files matching the specified [pattern].
/// If [basePath] is provided, paths are reported relative to this path.
/// If [environment] is provided, its entries will be injected as compile-time constants.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [saveAs] is provided, coverage report output will be written to a file at the given path.
/// If [timeout] is provided, a `TimeoutException` is thrown when the coverage collection exceeds the given duration.
///
/// The [observatoryAddress] and [observatoryPort] values indicate where the VM service is bound,
/// while the [silent] value indicates whether to silent the collector output.
Future<String> collectCoverage(FileSystemEntity source, {
  String basePath,
  Map<String, String> environment,
  observatoryAddress,
  int observatoryPort = 8181,
  packagesFile,
  String pattern = '*_test.dart',
  bool recurse = true,
  List<String> reportOn,
  saveAs,
  bool silent = false,
  Duration timeout
}) async {
  final address = observatoryAddress is InternetAddress ? observatoryAddress : InternetAddress(observatoryAddress ?? InternetAddress.loopbackIPv4.address);
  final collector = Collector(observatoryAddress: address, observatoryPort: observatoryPort)
    ..basePath = basePath
    ..environment = environment
    ..packagesFile = FilePath(packagesFile ?? '.packages').asFile
    ..reportOn = reportOn
    ..silent = silent
    ..timeout = timeout;

  final coverage = source is Directory
    ? await collector.collectFromFiles(FileSet.fromDir(source, pattern: pattern, recurse: recurse).files)
    : await collector.collectFromFile(source);

  if (saveAs != null) await FilePath(saveAs).asFile.writeAsString(coverage);
  return coverage;
}

/// Uploads the specified code coverage [report] to the Coveralls service.
Future<void> uploadCoverage(String report, {Configuration configuration, Uri endPoint, bool silent = false}) {
  final client = Client(endPoint);
  if (!silent) log('submitting to ${client.endPoint}');
  return client.upload(report, configuration);
}
