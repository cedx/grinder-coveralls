import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

@Task('Collects and uploads the coverage data in one pass')
Future<void> collectAndUploadCoverage() async =>
  coveralls.uploadCoverage(await coveralls.collectCoverage(getFile('test/all.dart')));

@Task('Collects the coverage data and saves it as LCOV format')
Future<void> collectCoverage() =>
  coveralls.collectCoverage(getFile('test/all.dart'), saveAs: 'path/to/lcov.info');

@Task('Uploads the LCOV coverage report to the Coveralls service')
Future<void> uploadCoverage() =>
  coveralls.uploadCoverageFile('path/to/lcov.info');
