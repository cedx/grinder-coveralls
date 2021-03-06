/// [Grinder](https://pub.dev/packages/grinder) plug-in collecting the code coverage and uploading it to [Coveralls](https://coveralls.io).
library grinder_coveralls;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:code_builder/code_builder.dart';
import 'package:coverage/coverage.dart';
import 'package:coveralls/coveralls.dart';
import 'package:crypto/crypto.dart';
import 'package:glob/glob.dart';
import 'package:grinder/grinder.dart' hide ProcessException;

part 'src/collector.dart';

/// Profiles the test scripts corresponding to the specified file [patterns], and returns their coverage data as LCOV format.
///
/// If [basePath] is provided, paths are reported relative to this path.
/// If [environment] is provided, its entries will be injected as compile-time constants.
/// If [packagesFile] is provided, it will be used as path to the `.packages` specification file.
/// If [reportOn] is provided, coverage report output is limited to files prefixed with one of the paths included.
/// If [saveAs] is provided, coverage report output will be written to a file at the given path.
/// If [timeout] is provided, a [TimeoutException] is thrown when the coverage collection exceeds the given duration.
///
/// The [observatoryAddress] and [observatoryPort] values indicate where the VM service is bound,
/// while the [silent] value indicates whether to silent the collector output.
Future<String> collectCoverage(patterns, {
  String basePath,
  Map<String, String> environment,
  observatoryAddress,
  int observatoryPort = 8181,
  packagesFile,
  List<String> reportOn,
  saveAs,
  bool silent = false,
  Duration timeout
}) async {
  assert(patterns is String || patterns is List<String>);
  assert(observatoryAddress == null || observatoryAddress is String || observatoryAddress is InternetAddress);
  assert(packagesFile == null || packagesFile is String || packagesFile is File);
  assert(saveAs == null || saveAs is String || saveAs is File);

  final address = observatoryAddress is InternetAddress ? observatoryAddress : InternetAddress(observatoryAddress ?? InternetAddress.loopbackIPv4.address);
  final collector = Collector(observatoryAddress: address, observatoryPort: observatoryPort)
    ..basePath = basePath
    ..environment = environment
    ..packagesFile = FilePath(packagesFile ?? '.packages').asFile
    ..reportOn = reportOn
    ..silent = silent
    ..timeout = timeout;

  final globs = patterns is List ? patterns : [patterns];
  final coverage = await collector.run(globs.map((pattern) => Glob(pattern)));
  if (saveAs != null) {
    final output = FilePath(saveAs).asFile;
    await output.create(recursive: true);
    await output.writeAsString(coverage);
  }

  return coverage;
}

/// Uploads the specified code coverage [report] to the Coveralls service.
Future<void> uploadCoverage(String report, {Configuration configuration, Uri endPoint, bool silent = false}) {
  assert(report.isNotEmpty);
  final client = Client(endPoint);
  if (!silent) log('submitting to ${client.endPoint}');
  return client.upload(report, configuration);
}
