/// [Coveralls](https://coveralls.io) plug-in for the [Grinder](https://google.github.io/grinder.dart) build system.
library grinder_coveralls;

import 'dart:async';
import 'dart:io';
import 'package:coverage/coverage.dart';
import 'package:coveralls/coveralls.dart';
import 'package:grinder/grinder.dart';

export 'package:coveralls/coveralls.dart';
part 'src/collector.dart';

/// Runs the specified [script] with optional [arguments].
/// Uploads the collected coverage data to the Coveralls service.
Future<void> collectAndUploadCoverage(Object script, {List<String> arguments}) async {
  var file = FilePath(script).asFile;
  var coverage = await Collector().collect(file, arguments: arguments);
  return Client().upload(coverage);
}

/// Runs the specified [script] and saves its coverage data as LCOV format.
///
/// The [output] path specifies the destination file.
/// The [arguments] list provides the optional script arguments.
Future<void> collectCoverage(Object script, String output, {List<String> arguments}) async {
  var file = FilePath(script).asFile;
  var coverage = await Collector().collect(file, arguments: arguments);
  return getFile(output).writeAsString(coverage);
}

/// Uploads the specified code coverage [report] in LCOV format to the Coveralls service.
Future<void> uploadCoverage(Object report) async {
  var file = FilePath(report).asFile;
  return Client().upload(await file.readAsString());
}
