import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

@Task('Deletes all generated files and reset any saved state')
void clean() {
  defaultClean();
  ['.dart_tool', 'doc/api', 'var/test', webDir.path].map(getDir).forEach(delete);
  FileSet.fromDir(getDir('var'), pattern: '!.*', recurse: true).files.forEach(delete);
}

@Task('Uploads the results of the code coverage')
Future<void> coverage() async => uploadCoverage(await getFile('var/lcov.info').readAsString());

@Task('Builds the documentation')
Future<void> doc() async {
  for (final path in ['CHANGELOG.md', 'LICENSE.md']) await getFile(path).copy('doc/about/${path.toLowerCase()}');
  DartDoc.doc();
  run('mkdocs', arguments: ['build', '--config-file=doc/mkdocs.yaml']);
  ['doc/about/changelog.md', 'doc/about/license.md', '${webDir.path}/mkdocs.yaml'].map(getFile).forEach(delete);
}

@Task('Fixes the coding standards issues')
void fix() => DartFmt.format(existingSourceDirs);

@Task('Performs the static analysis of source code')
void lint() => Analyzer.analyze(existingSourceDirs);

@Task('Publishes the package to the registry')
@Depends(clean, fix)
void publish() => run('pub', arguments: ['publish', '--force'], runOptions: RunOptions(runInShell: true));

@Task('Runs the test suites')
Future<void> test() => collectCoverage('test/**_test.dart', reportOn: [libDir.path], saveAs: 'var/lcov.info');

@Task('Upgrades the project to the latest revision')
void upgrade() {
  run('git', arguments: ['reset', '--hard']);
  run('git', arguments: ['fetch', '--all', '--prune']);
  run('git', arguments: ['pull', '--rebase']);
  Pub.upgrade();
}

@Task('Watches for file changes')
void watch() => Pub.run('build_runner', arguments: ['watch', '--delete-conflicting-outputs']);
