# Usage
If you haven't used [Grinder](https://github.com/google/grinder.dart) before, be sure to check out the [related documentation](https://google.github.io/grinder.dart), as it explains how to create a `grind.dart` file and to define project tasks. Once you're familiar with that process, you may install this package.

The package provides two functions, `collectCoverage()` and `uploadCoverage()`, that let you collect the code coverage of one or several [Dart](https://www.dartlang.org) scripts, and upload the resulting [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) report to the [Coveralls](https://coveralls.io) service.
    
## Future&lt;String&gt; **collectCoverage**(FileSystemEntity source)
Runs the specified source script, or source directory containing test files, and returns the collected coverage data as LCOV format.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task('Collects the code coverage of Dart scripts from a given directory')
Future<String> collectFromDirectory() =>
  coveralls.collectCoverage(getDir('path/to/src'));

@Task('Collects the code coverage of a single Dart script')
Future<String> collectFromFile() =>
  coveralls.collectCoverage(getFile('path/to/src/script.dart'));
```

### Options

#### String **basePath**
TODO

```dart
import 'dart:io';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), basePath: Directory.current.path);
```

#### Map<String, String> **environment**
TODO

#### dynamic **observatoryAddress**
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), observatoryAddress: '127.0.0.1');
```

#### int **observatoryPort** = `8181`
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), observatoryPort: 8181);
```

#### dynamic **packagesFile**
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), packagesFile: '.packages');
```

#### String **pattern** = `"*_test.dart"`
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), pattern: '*_test.dart');
```

#### bool **recurse** = `true`
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), recurse: false);
```

#### List<String> **reportOn**
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), reportOn: [libDir.path]);
```

#### dynamic **saveAs**
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<void> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), saveAs: 'lcov.info');
```

#### bool **silent** = `false`
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), silent: true);
```

#### Duration **timeout**
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<String> collectCoverage() =>
  coveralls.collectCoverage(getDir('test'), timeout: Duration(minutes: 3));
```

## Future&lt;void&gt; **uploadCoverage**(String report, {Configuration configuration, Uri endPoint})
Uploads the specified coverage report to the [Coveralls](https://coveralls.io) service.

The report can be in [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format, the de facto standard, or in [Clover](https://www.atlassian.com/software/clover) format, a common format produced by [Java](https://www.java.com) and [PHP](https://secure.php.net) test frameworks

### Options

#### Configuration **configuration**
TODO

```dart
import 'package:coveralls/coveralls.dart' show Configuration;
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<void> uploadCoverage() async {
  final config = await Configuration.loadDefaults();
  config['repo_token'] = 'A7BIfg9TXgImpHpi8y1kwH7Ke3RABYVP4';
  config['service_name'] = 'My Own CI Service';
  
  final coverage = await getFile('lcov.info').readAsString();
  return coveralls.uploadCoverage(coverage, configuration: config);
}
```

#### Uri **endPoint**
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;

@Task() Future<void> uploadCoverage() async {
  final coverage = await getFile('lcov.info').readAsString();
  return coveralls.uploadCoverage(coverage, endPoint: Uri.https('coveralls.io', '/api/v1/'));
}
```
