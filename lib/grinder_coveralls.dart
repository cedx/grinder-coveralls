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

/// Runs the specified [script] and returns its code coverage in LCOV format.
///
/// The [arguments] list provides the optional script arguments.
/// The [output] path specifies the optional destination file.
String collectCoverage(dynamic script, {List<String> arguments, String output}) {
  var path = script is FilePath ? script : new FilePath(script);
  var coverage = new Coverage().collect(path.asFile, arguments: arguments);
  if (output != null) getFile(output).writeAsStringSync(coverage);
  return coverage;
}

/// Runs asynchronously the specified [script] and returns its code coverage in LCOV format.
///
/// The [arguments] list provides the optional script arguments.
/// The [output] path specifies the optional destination file.
Future<String> collectCoverageAsync(dynamic script, {List<String> arguments, String output}) async {
  var path = script is FilePath ? script : new FilePath(script);
  var coverage = await new Coverage().collectAsync(path.asFile, arguments: arguments);
  if (output != null) await getFile(output).writeAsString(coverage);
  return coverage;
}
}
