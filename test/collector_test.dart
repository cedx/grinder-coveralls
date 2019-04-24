import 'dart:io';
import 'dart:math';
import 'package:grinder_coveralls/grinder_coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the [Collector] class.
void main() => group('Collector', () {
  var port = 8181 + Random().nextInt(1024);

  group('.collectDirectory()', () {
    test('should return the code coverage of the sample test directory', () async {
      final coverage = await Collector(observatoryPort: port++).collectFromDirectory(Directory('test/fixtures'));
      expect(coverage, stringContainsInOrder(['test/fixtures/sample_test.dart', 'end_of_record']));
    });
  });

  group('.collectFile()', () {
    test('should return the code coverage of the sample test file', () async {
      final coverage = await Collector(observatoryPort: port++).collectFromFile(File('test/fixtures/sample_test.dart'));
      expect(coverage, stringContainsInOrder(['test/fixtures/sample_test.dart', 'end_of_record']));
    });
  });

  group('.collectFiles()', () {
    test('should return the code coverage of the sample test files', () async {
      final coverage = await Collector(observatoryPort: port++).collectFromFiles([File('test/fixtures/sample_test.dart')]);
      expect(coverage, stringContainsInOrder(['test/fixtures/sample_test.dart', 'end_of_record']));
    });
  });
});
