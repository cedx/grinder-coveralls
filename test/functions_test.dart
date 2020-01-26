import 'dart:io';
import 'dart:math';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Tests the features of the functions.
void main() => group('collectCoverage()', () {
  var port = 8181 + Random().nextInt(1024);

  final entryScript = p.normalize('.dart_tool/grinder_coveralls/test_');
  final hasSampleTest = stringContainsInOrder([p.normalize('test/fixtures/script1.dart'), 'end_of_record']);

  test('should return the code coverage of the sample test directory', () async {
    final coverage = await collectCoverage('test/fixtures/*.dart', observatoryPort: port++, silent: true);
    expect(coverage, allOf(hasSampleTest, contains(entryScript)));
  });

  test('should support the `basePath` option of the collector', () async {
    final basePath = joinDir(Directory.current, ['test', 'fixtures']).path;
    final coverage = await collectCoverage('test/fixtures/*.dart', basePath: basePath, observatoryPort: port++, silent: true);
    expect(coverage, stringContainsInOrder(['SF:script1.dart', 'end_of_record']));
    expect(coverage, stringContainsInOrder(['SF:script2.dart', 'end_of_record']));
  });

  test('should support the `reportOn` option of the collector', () async {
    final coverage = await collectCoverage('test/fixtures/*.dart', observatoryPort: port++, reportOn: ['test'], silent: true);
    expect(coverage, allOf(hasSampleTest, isNot(contains(entryScript))));
  });
});
