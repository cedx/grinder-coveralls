# Grinder-Coveralls
![Runtime](https://img.shields.io/badge/dart-%3E%3D2.2-brightgreen.svg) ![Release](https://img.shields.io/pub/v/grinder_coveralls.svg) ![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Coverage](https://coveralls.io/repos/github/cedx/grinder-coveralls/badge.svg) ![Build](https://travis-ci.com/cedx/grinder-coveralls.svg)

[Grinder](https://google.github.io/grinder.dart) plug-in collecting your code coverage as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) and uploading it to the [Coveralls](https://coveralls.io) service.

!!! warning
    This library was created to run tests on the [Dart VM](https://www.dartlang.org/server/tools/dart-vm) exclusively. It has not been tested and likely won't work for compiled Dart code (i.e. [Flutter](https://flutter.dev) or [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript)).

## Quick start
Append the following line to your project's `pubspec.yaml` file:

```yaml
dependencies:
  grinder_coveralls: *
```

Install the latest version of **Grinder-Coveralls** with [Pub](https://www.dartlang.org/tools/pub):

```shell
pub get
```

For detailed instructions, see the [installation guide](installation.md).
