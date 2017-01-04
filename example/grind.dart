import 'dart:async';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// Starts the build system.
Future main(List<String> args) => grind(args);

/// Uploads the code coverage report.
@Task()
@Depends(test)
void coverage() => uploadCoverage('var/lcov.info');

/// Runs all the test suites.
@Task()
void test() => collectCoverage('test/all.dart', 'var/lcov.info');
