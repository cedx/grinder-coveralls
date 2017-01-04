/// [Coveralls](https://coveralls.io) plug-in for the [Grinder](https://google.github.io/grinder.dart) build system.
library grinder_coveralls;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:coverage/coverage.dart';
import 'package:grinder/grinder.dart';

part 'src/coverage.dart';
part 'src/coveralls_client.dart';
part 'src/coveralls_formatter.dart';

/// Runs the specified [script] and saves its code coverage as LCOV format.
///
/// The [output] path specifies the destination file.
/// The [arguments] list provides the optional script arguments.
void collectCoverage(dynamic script, String output, {List<String> arguments}) {
  var path = script is FilePath ? script : new FilePath(script);
  var coverage = new Coverage().collect(path.asFile, arguments: arguments);
  getFile(output).writeAsStringSync(coverage);
}

/// Runs asynchronously the specified [script] and saves its coverage data as LCOV format.
///
/// The [output] path specifies the destination file.
/// The [arguments] list provides the optional script arguments.
Future collectCoverageAsync(dynamic script, String output, {List<String> arguments}) async {
  var path = script is FilePath ? script : new FilePath(script);
  var coverage = await new Coverage().collectAsync(path.asFile, arguments: arguments);
  await getFile(output).writeAsString(coverage);
}

/// Uploads the specified code [coverage] report in LCOV format to the Coveralls service.
void uploadCoverage(dynamic coverage) {
  var path = coverage is FilePath ? coverage : new FilePath(coverage);
  new CoverallsClient().uploadFile(path.asFile);
}

/// Uploads asynchronously the specified code [coverage] report in LCOV format to the Coveralls service.
Future uploadCoverageAsync(dynamic coverage) async {
  var path = coverage is FilePath ? coverage : new FilePath(coverage);
  await new CoverallsClient().uploadFileAsync(path.asFile);
}
