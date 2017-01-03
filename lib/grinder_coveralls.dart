/// [Coveralls](https://coveralls.io) plug-in for the [Grinder](https://google.github.io/grinder.dart) build system.
library grinder_coveralls;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:coverage/coverage.dart';
import 'package:grinder/grinder.dart';

part 'src/coverage.dart';

/// Runs the specified [script] and returns its code coverage in LCOV format.
///
/// The [arguments] list provides the optional script arguments.
/// The [output] path specifies the path of an optional output file.
void collectCoverage(String script, {List<String> arguments, String output}) {
  var coverage = new Coverage().collect(script, arguments: arguments);
  if (output != null) getFile(output).writeAsStringSync(coverage);
}

/// Runs asynchronously the specified [script] and returns its code coverage in LCOV format.
///
/// The [arguments] list provides the optional script arguments.
/// The [output] path specifies the path of an optional output file.
Future collectCoverageAsync(String script, {List<String> arguments, String output}) async {
  var coverage = await new Coverage().collectAsync(script, arguments: arguments);
  if (output != null) await getFile(output).writeAsString(coverage);
}
