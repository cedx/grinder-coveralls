import 'dart:math';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Tests the features of the functions.
void main() => group('collectCoverage()', () {
  final entryScript = p.normalize('.dart_tool/grinder_coveralls/test_');
  final hasSampleTest = stringContainsInOrder([p.normalize('test/fixtures/script.dart'), 'end_of_record']);
  var port = 8181 + Random().nextInt(1024);

  test('should return the code coverage of the sample test directory', () async {
    final coverage = await collectCoverage(getDir('test/fixtures'), observatoryPort: port++, pattern: '*.dart', silent: true);
    expect(coverage, allOf(hasSampleTest, contains(entryScript)));
  });

  test('should return the code coverage of the sample test file', () async {
    final coverage = await collectCoverage(getFile('test/fixtures/script.dart'), observatoryPort: port++, silent: true);
    expect(coverage, allOf(hasSampleTest, isNot(contains(entryScript))));
  });

  test('should write the code coverage to the given file', () async {
    final output = getFile('var/test/collectCoverage/lcov.info');
    await collectCoverage(getDir('test/fixtures'), observatoryPort: port++, pattern: '*.dart', saveAs: output, silent: true);
    expect(await output.readAsString(), allOf(hasSampleTest, contains(entryScript)));
  });
});
