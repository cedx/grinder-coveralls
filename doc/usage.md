# Usage
If you haven't used [Grinder](https://github.com/google/grinder.dart) before, be sure to check out the [related documentation](https://google.github.io/grinder.dart), as it explains how to create a `grind.dart` file and to define project tasks. Once you're familiar with that process, you may install this package.

The package provides two functions, `collectCoverage()` and `uploadCoverage()`, that let you collect the code coverage of one or several [Dart](https://dart.dev) scripts, and upload the resulting [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) report to the [Coveralls](https://coveralls.io) service.
    
## Future&lt;String&gt; **collectCoverage**(dynamic patterns)
Runs the test scripts corresponding to the specified file patterns, and returns the collected coverage data as LCOV format.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart');
```

The file patterns use the same syntax as the [`glob` package](https://pub.dev/packages/glob).

!!! tip
    You can provide several file patterns to the `collectCoverage()` function:
    the `patterns` parameter can be a `String` (single pattern) or a `List<String>` (multiple patterns).

### Options

#### String **basePath**
The absolute base path to use for resolving the reported paths. This base path will be stripped from the paths of the source files included in the code coverage.

```dart
import 'dart:io';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', basePath: Directory.current.path);
```

#### Map&lt;String, String&gt; **environment**
The variables that will be injected as compile-time constants. These variables will be accessible using the `fromEnvironment()` method of the [`bool`](https://api.dart.dev/stable/dart-core/bool/bool.fromEnvironment.html), [`int`](https://api.dart.dev/stable/dart-core/int/int.fromEnvironment.html) and [`String`](https://api.dart.dev/stable/dart-core/String/String.fromEnvironment.html) classes.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', environment: {'MY_ENV_VAR': 'FooBar'});
```

#### dynamic **observatoryAddress**
The address used by the [Observatory](https://dart.dev/tools/observatory) profiler.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', observatoryAddress: '127.0.0.1');
```

!!! tip
    The address can be provided as a `String` or as an [`InternetAddress`](https://api.dart.dev/stable/dart-io/InternetAddress-class.html) instance.  
    Defaults to [`InternetAddress.loopbackIPv4`](https://api.dart.dev/stable/dart-io/InternetAddress/loopbackIPv4.html).

#### int **observatoryPort** = `8181`
The port used by the [Observatory](https://dart.dev/tools/observatory) profiler.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', observatoryPort: 8181);
```

#### dynamic **packagesFile**
The path to the `.packages` specification file. This file is used by the LCOV formatter to resolve `package:` imports.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', packagesFile: '.packages');
```

!!! tip
    The path can be provided as a `String` or as a [`File`](https://api.dart.dev/stable/dart-io/File-class.html) instance.

#### List&lt;String&gt; **reportOn**
The prefixes used to limit the files included in the coverage report output. All file paths not containing theses prefixes will be excluded from the code coverage.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', reportOn: [libDir.path]);
```

#### dynamic **saveAs**
The path to a destination file. If provided, the coverage report output will be written to the file at the given path.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<void> collectCoverage() =>
  collectCoverage('test/**_test.dart', saveAs: 'lcov.info');
```

!!! tip
    The path can be provided as a `String` or as a [`File`](https://api.dart.dev/stable/dart-io/File-class.html) instance.

#### bool **silent** = `false`
By default, the `collectCoverage()` function prints to the console the standard output of the underlying process. You can disable this output by setting the `silent` option to `true`.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', silent: true);
```

#### Duration **timeout**
The maximum duration that must not be exceeded before a `TimeoutException` is thrown.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<String> collectCodeCoverage() =>
  collectCoverage('test/**_test.dart', timeout: Duration(minutes: 3));
```

## Future&lt;void&gt; **uploadCoverage**(String report, {Configuration configuration, Uri endPoint})
Uploads the specified coverage report to the [Coveralls](https://coveralls.io) service.

The report can be in [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format, the de facto standard, or in [Clover](https://www.atlassian.com/software/clover) format, a common format produced by [Java](https://www.java.com) and [PHP](https://secure.php.net) test frameworks.

### Options

#### Configuration **configuration**
A set of key-value pairs used to customize the report sent to the [Coveralls](https://coveralls.io) service.

```dart
import 'package:coveralls/coveralls.dart' show Configuration;
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<void> uploadCoverageReport() async {
  final config = await Configuration.loadDefaults();
  config['repo_token'] = 'A7BIfg9TXgImpHpi8y1kwH7Ke3RABYVP4';
  config['service_name'] = 'My Own CI Service';
  
  final coverage = await getFile('lcov.info').readAsString();
  return uploadCoverage(coverage, configuration: config);
}
```

!!! tip
    See the source code of the [`coveralls` package](https://pub.dev/packages/coveralls) for the full list of supported parameters.

#### Uri **endPoint**
The base URI of the API endpoint of the [Coveralls](https://coveralls.io) service.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<void> uploadCoverageReport() async {
  final coverage = await getFile('lcov.info').readAsString();
  return uploadCoverage(coverage, endPoint: Uri.https('coveralls.io', '/api/v1/'));
}
```

#### bool **silent** = `false`
By default, the `uploadCoverage()` function prints to the console a submit message. You can disable this output by setting the `silent` option to `true`.

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task() Future<void> uploadCoverageReport() async {
  final coverage = await getFile('lcov.info').readAsString();
  uploadCoverage(coverage, silent: true);
}
```
