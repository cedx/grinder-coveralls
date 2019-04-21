import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

@Task('Deletes all generated files and reset any saved state')
void clean() {
  defaultClean();
  ['.dart_tool/build', 'doc/api', 'var/test', webDir.path].map(getDir).forEach(delete);
  FileSet.fromDir(getDir('var'), pattern: '*.{info,json}', recurse: true).files.forEach(delete);
}

@Task('Uploads the results of the code coverage')
Future<void> coverage() => uploadCoverageFile('var/lcov.info');

@Task('Builds the documentation')
Future<void> doc() async {
  for (final path in ['CHANGELOG.md', 'LICENSE.md']) await getFile(path).copy('doc/about/${path.toLowerCase()}');
  DartDoc.doc();
  run('mkdocs', arguments: ['build', '--config-file=doc/mkdocs.yml']);
  ['doc/about/changelog.md', 'doc/about/license.md', '${webDir.path}/mkdocs.yml'].map(getFile).forEach(delete);
}

@Task('Fixes the coding standards issues')
void fix() => DartFmt.format(existingSourceDirs);

@Task('Performs the static analysis of source code')
void lint() => Analyzer.analyze(existingSourceDirs);

@Task('Runs the test suites')
Future<void> test() => collectCoverage(getDir('test'), reportOn: ['lib'], saveAs: 'var/lcov.info');

@Task('Upgrades the project to the latest revision')
void upgrade() {
  run('git', arguments: ['reset', '--hard']);
  run('git', arguments: ['fetch', '--all', '--prune']);
  run('git', arguments: ['pull', '--rebase']);
  Pub.upgrade();
}

@Task('Watches for file changes')
void watch() => Pub.run('build_runner', arguments: ['watch', '--delete-conflicting-outputs']);
