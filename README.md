# Grinder-Coveralls
![Runtime](https://img.shields.io/badge/dart-%3E%3D2.2-brightgreen.svg) ![Release](https://img.shields.io/pub/v/grinder_coveralls.svg) ![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Coverage](https://coveralls.io/repos/github/cedx/grinder-coveralls/badge.svg) ![Build](https://travis-ci.com/cedx/grinder-coveralls.svg)

[Grinder](https://google.github.io/grinder.dart) plug-in collecting your code coverage as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) and uploading it to the [Coveralls](https://coveralls.io) service.

## Getting started
If you haven't used Grinder before, be sure to check out the [related documentation](https://google.github.io/grinder.dart), as it explains how to create a `grind.dart` file and to define project tasks. Once you're familiar with that process, you may install this plug-in.

## Installing via [Pub](https://pub.dartlang.org)

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

```yaml
devDpendencies:
  grinder: *
  grinder_coveralls: *
```

### 2. Install it
Install this package and its dependencies from a command prompt:

```shell
$ pub get
```

Once the plug-in has been installed, it may be enabled inside your `grind.dart` file.

## Usage

### The easy way
The simplest way to collect and upload your coverage data is to use the [dedicated set of functions](https://github.com/cedx/grinder-coveralls/blob/master/lib/grinder_coveralls.dart).

#### 1. Collect the code coverage

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task('Collects the coverage data and saves it as LCOV format')
Future<void> coverageCollect() => collectCoverage('test/all.dart', 'lcov.info');
```

#### 2. Upload the coverage report

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

@Task('Uploads the LCOV coverage report to Coveralls')
@Depends(coverageCollect)
Future<void> coverageUpload() => uploadCoverage('lcov.info');
```

### The hard way
This package uses some defaults based on the [Pub package layout](https://www.dartlang.org/tools/pub/package-layout) conventions.
To customize its behavior, you can use the underlying classes used by the helper functions: the `Collector` class from this package, and the classes exported from the [`coveralls` package](https://pub.dartlang.org/packages/coveralls).

#### 1. Collect the code coverage
TODO

```dart
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';
```

#### 2. Format the coverage data
TODO

#### 3. Upload the coverage report
TODO

## Examples
You can find a sample `grind.dart` file in the `example` folder:  
[Sample Grinder tasks](https://github.com/cedx/grinder-coveralls/blob/master/example/grind.dart)





## Documentation
- [User guide](https://dev.belin.io/grinder-coveralls)
- [API reference](https://dev.belin.io/grinder-coveralls/api)

## Development
- [Git repository](https://github.com/cedx/grinder-coveralls)
- [Pub package](https://pub.dartlang.org/packages/grinder_coveralls)
- [Submit an issue](https://github.com/cedx/grinder-coveralls/issues)

## License
[Grinder-Coveralls](https://dev.belin.io/grinder-coveralls) is distributed under the MIT License.
