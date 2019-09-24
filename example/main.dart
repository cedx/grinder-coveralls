import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task('Collects and uploads the coverage data in one pass')
Future<void> collectAndUploadCodeCoverage() async =>
  uploadCoverage(await collectCoverage('test/**_test.dart', reportOn: [libDir.path]));

@Task('Collects the coverage data and saves it as LCOV format')
Future<void> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', reportOn: [libDir.path], saveAs: 'path/to/lcov.info');

@Task('Uploads the LCOV coverage report to the Coveralls service')
Future<void> uploadCoverageReport() async =>
  uploadCoverage(await getFile('path/to/lcov.info').readAsString());
