/// [Coveralls](https://coveralls.io) plug-in for the [Grinder](https://google.github.io/grinder.dart) build system.
library grinder_coveralls;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:coverage/coverage.dart';
import 'package:grinder/grinder.dart';

part 'src/client.dart';
part 'src/collector.dart';

/// Runs the specified [script] with optional [arguments].
/// Uploads the collected coverage data to the Coveralls service.
Future collectAndUploadCoverage(dynamic script, {List<String> arguments}) async {
  var path = script is FilePath ? script : new FilePath(script);
  var coverage = await new Collector().collect(path.asFile, arguments: arguments);
  return new Client().upload(coverage);
}

/// Runs the specified [script] and saves its coverage data as LCOV format.
///
/// The [output] path specifies the destination file.
/// The [arguments] list provides the optional script arguments.
Future collectCoverage(dynamic script, String output, {List<String> arguments}) async {
  var path = script is FilePath ? script : new FilePath(script);
  var coverage = await new Collector().collect(path.asFile, arguments: arguments);
  return getFile(output).writeAsString(coverage);
}

/// Uploads the specified code [coverage] report in LCOV format to the Coveralls service.
Future uploadCoverage(dynamic coverage) async {
  var path = coverage is FilePath ? coverage : new FilePath(coverage);
  return new Client().uploadFile(path.asFile);
}
