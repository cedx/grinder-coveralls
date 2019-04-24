import 'dart:io';
import 'dart:math';
import 'package:grinder_coveralls/grinder_coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the functions.
void main() => group('collectCoverage()', () {
  var port = 8181 + Random().nextInt(1024);

  test('should return the code coverage of the sample test directory', () async {
    final coverage = await collectCoverage(Directory('test/fixtures'), observatoryPort: port++, silent: true);
    expect(coverage, stringContainsInOrder(['test/fixtures/sample_test.dart', 'end_of_record']));
  });

  test('should return the code coverage of the sample test file', () async {
    final coverage = await collectCoverage(File('test/fixtures/sample_test.dart'), observatoryPort: port++, silent: true);
    expect(coverage, stringContainsInOrder(['test/fixtures/sample_test.dart', 'end_of_record']));
  });
});
