import 'dart:math';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the functions.
void main() => group('collectCoverage()', () {
  const endOfRecord = 'end_of_record';
  const entryScript = '.dart_tool/grinder_coveralls/test_';
  const sampleTest = 'test/fixtures/sample_test.dart';
  var port = 8181 + Random().nextInt(1024);

  test('should return the code coverage of the sample test directory', () async {
    final coverage = await collectCoverage(getDir('test/fixtures'), observatoryPort: port++, silent: true);
    expect(coverage, stringContainsInOrder([sampleTest, endOfRecord]));
    expect(coverage, contains(entryScript));
  });

  test('should return the code coverage of the sample test file', () async {
    final coverage = await collectCoverage(getFile(sampleTest), observatoryPort: port++, silent: true);
    expect(coverage, stringContainsInOrder([sampleTest, endOfRecord]));
    expect(coverage, isNot(contains(entryScript)));
  });
});
