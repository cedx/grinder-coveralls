import 'dart:async';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// The list of source directories.
const List<String> _sources = const ['lib', 'test', 'tool'];

/// Starts the build system.
Future main(List<String> args) => grind(args);

/// Deletes all generated files and reset any saved state.
@Task()
void clean() => defaultClean();

/// Collects the code coverage and uploads the results.
@Task()
void coverage() {
  // TODO
}

/// Builds the documentation.
@Task()
void doc() => DartDoc.doc();

/// Fixes the coding standards issues.
@Task()
void fix() => DartFmt.format(_sources);

/// Performs static analysis of source code.
@Task()
void lint() => Analyzer.analyze(_sources);

/// Runs all the test suites.
@Task()
void test() {
  collectCoverage('test/all.dart', output: 'var/lcov.info');
}
