import 'dart:io';
import 'dart:math';
import 'package:glob/glob.dart';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Tests the features of the [Collector] class.
void main() => group('Collector', () {
  var port = 8181 + Random().nextInt(1024);

  final entryScript = p.normalize('.dart_tool/grinder_coveralls/test_');
  final hasSampleTest = stringContainsInOrder([p.normalize('test/fixtures/script1.dart'), 'end_of_record']);
  final testFiles = [Glob('test/fixtures/*.dart')];

  group('.basePath', () {
    test('should change the file paths of the code coverage', () async {
      final collector = Collector(observatoryPort: port++)..basePath = joinDir(Directory.current, ['test', 'fixtures']).path;
      final coverage = await collector.run(testFiles);
      expect(coverage, stringContainsInOrder(['SF:script1.dart', 'end_of_record']));
      expect(coverage, stringContainsInOrder(['SF:script2.dart', 'end_of_record']));
    });
  });

  group('.reportOn', () {
    test('should limit the files included in the code coverage', () async {
      final collector = Collector(observatoryPort: port++)..reportOn = ['test'];
      final coverage = await collector.run(testFiles);
      expect(coverage, allOf(hasSampleTest, isNot(contains(entryScript))));
    });
  });

  group('.run()', () {
    test('should return the code coverage of the sample test directory', () async {
      final coverage = await Collector(observatoryPort: port++).run(testFiles);
      expect(coverage, allOf(hasSampleTest, contains(entryScript)));
    });
  });
});
