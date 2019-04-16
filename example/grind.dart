import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

/// Collects and uploads the coverage data in one pass.
@Task('Collect and upload the coverage')
Future<void> coverage() => collectAndUploadCoverage('test/all.dart');

/// Collects the coverage data and saves it as LCOV format.
@Task('Collect the coverage data')
Future<void> coverageCollect() => collectCoverage('test/all.dart', 'out/lcov.info');

/// Uploads the LCOV coverage report to Coveralls.
@Task('Upload the coverage report')
@Depends(coverageCollect)
Future<void> coverageUpload() => uploadCoverage('out/lcov.info');

/// Runs all the test suites.
@Task('Run the tests')
void test() => TestRunner().test(files: 'test/all.dart');
