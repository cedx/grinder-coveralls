# Grinder-Coveralls

[Coveralls](https://coveralls.io) plug-in for [Grinder](https://google.github.io/grinder.dart), the [Dart](https://www.dartlang.org) build system.

Collect your code coverage in [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format and upload it to the [Coveralls](https://coveralls.io) service.

## Getting started
If you haven't used Grinder before, be sure to check out the [related documentation](https://google.github.io/grinder.dart), as it explains how to create a `grind.dart` file and to define project tasks. Once you're familiar with that process, you may install this plug-in.

## Installing via [Pub](https://pub.dartlang.org)

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

```yaml
devDpendencies:
  grinder_coveralls: *
```

### 2. Install it
Install this package and its dependencies from a command prompt:

```shell
$ pub get
```

### 3. Import it
Now in your [Dart](https://www.dartlang.org) code, you can use:

```dart
import 'package:grinder_coveralls/grinder_coveralls.dart';
```

## Usage

### The easy way
The simplest way to collect and upload your coverage data is to use the dedicated set of functions.

#### 1. Collect the code coverage
TODO

#### 2. Upload the coverage report
TODO

### The hard way
TODO

#### 1. Collect the code coverage
TODO

#### 2. Format the coverage data
TODO

#### 3. Upload the coverage report
TODO

## Examples
You can find a detailled sample in the `example` folder:  
[Sample Grinder tasks](https://github.com/cedx/grinder-coveralls/blob/master/example/grind.dart)

## See also
- [API reference](https://cedx.github.io/grinder-coveralls)
- [Code coverage](https://coveralls.io/github/cedx/grinder-coveralls)
- [Continuous integration](https://travis-ci.org/cedx/grinder-coveralls)

## License
[Grinder-Coveralls](https://github.com/cedx/grinder-coveralls) is distributed under the Apache License, version 2.0.
