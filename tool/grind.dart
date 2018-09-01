import 'dart:async';
import 'dart:io';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

@Task('Delete the generated files')
void clean() {
  defaultClean();
  ['.dart_tool/build', 'doc/api', webDir.path].map(getDir).forEach(delete);
  FileSet.fromDir(getDir('var'), pattern: '*.{info,json}').files.forEach(delete);
}

@Task('Upload the code coverage')
Future<void> coverage() => uploadCoverage('var/lcov.info');

@Task('Builds the documentation')
Future<void> doc() async {
  await File('CHANGELOG.md').copy('doc/about/changelog.md');
  await File('LICENSE.md').copy('doc/about/license.md');
  DartDoc.doc();
  run('mkdocs', arguments: ['build']);
}

@Task('Fix the coding issues')
void fix() => DartFmt.format(existingSourceDirs, lineLength: 200);

@Task('Perform the static analysis')
void lint() => Analyzer.analyze(existingSourceDirs);

@Task('Run the tests')
Future<void> test() => collectCoverage('test/all.dart', 'var/lcov.info');

@Task('Upgrade the project')
void upgrade() {
  run('git', arguments: ['reset', '--hard']);
  run('git', arguments: ['fetch', '--all', '--prune']);
  run('git', arguments: ['pull', '--rebase']);
  Pub.upgrade();
}
