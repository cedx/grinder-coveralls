import 'dart:async';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// The list of source directories.
const List<String> _sources = const ['lib', 'test', 'tool'];

/// Starts the build system.
Future main(List<String> args) => grind(args);

/// Deletes all generated files and reset any saved state.
@Task('Delete the generated files')
void clean() => defaultClean();

/// Uploads the code coverage report.
@Task('Upload the code coverage')
@Depends(test)
Future coverage() => uploadCoverage('var/lcov.info');

/// Builds the documentation.
@Task('Build the documentation')
void doc() => DartDoc.doc();

/// Fixes the coding standards issues.
@Task('Fix the coding issues')
void fix() => DartFmt.format(_sources);

/// Performs static analysis of source code.
@Task('Perform the static analysis')
void lint() => Analyzer.analyze(_sources);

/// Runs all the test suites.
@Task('Run the tests')
Future test() => collectCoverage('test/all.dart', 'var/lcov.info');
