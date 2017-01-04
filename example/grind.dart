import 'dart:async';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// Starts the build system.
Future main(List<String> args) => grind(args);

/// Collects and uploads the coverage data in one pass.
@Task()
void coverage() => collectAndUploadCoverage('test/all.dart');

/// Collects the coverage data and saves it as LCOV format.
@Task()
void coverageCollect() => collectCoverage('test/all.dart', 'lcov.info');

/// Uploads the LCOV coverage report to [Coveralls](https://coveralls.io).
@Task()
@Depends(coverageCollect)
void coverageUpload() => uploadCoverage('lcov.info');

/// Runs all the test suites.
@Task()
void test() => new TestRunner().test(files: 'test/all.dart');
