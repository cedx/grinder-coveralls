import 'dart:io';
import 'dart:math';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the [Collector] class.
void main() => group('Collector', () {
  const entryScript = '.dart_tool/grinder_coveralls/test_';
  const sampleTest = 'test/fixtures/script.dart';
  final hasSampleTest = stringContainsInOrder([sampleTest, 'end_of_record']);
  var port = 8181 + Random().nextInt(1024);

  group('.basePath', () {
    test('should change the file paths of the code coverage', () async {
      final collector = Collector(observatoryPort: port++)..basePath = joinDir(Directory.current, ['test', 'fixtures']).path;
      final coverage = await collector.collectFromDirectory(getDir('test/fixtures'));
      expect(coverage, stringContainsInOrder(['SF:${fileName(getFile(sampleTest))}', 'end_of_record']));
    });
  });

  group('.reportOn', () {
    test('should limit the files included in the code coverage', () async {
      final collector = Collector(observatoryPort: port++)..reportOn = ['test'];
      final coverage = await collector.collectFromDirectory(getDir('test/fixtures'));
      expect(coverage, allOf(hasSampleTest, isNot(contains(entryScript))));
    });
  });

  group('.collectDirectory()', () {
    test('should return the code coverage of the sample test directory', () async {
      final coverage = await Collector(observatoryPort: port++).collectFromDirectory(getDir('test/fixtures'));
      expect(coverage, allOf(hasSampleTest, contains(entryScript)));
    });
  });

  group('.collectFile()', () {
    test('should return the code coverage of the sample test file', () async {
      final coverage = await Collector(observatoryPort: port++).collectFromFile(getFile(sampleTest));
      expect(coverage, allOf(hasSampleTest, isNot(contains(entryScript))));
    });
  });

  group('.collectFiles()', () {
    test('should return the code coverage of the sample test files', () async {
      final coverage = await Collector(observatoryPort: port++).collectFromFiles([getFile(sampleTest)]);
      expect(coverage, allOf(hasSampleTest, contains(entryScript)));
    });
  });
});
