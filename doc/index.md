# Grinder-Coveralls
![Runtime](https://img.shields.io/badge/dart-%3E%3D2.7-brightgreen.svg) ![Release](https://img.shields.io/pub/v/grinder_coveralls.svg) ![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Coverage](https://coveralls.io/repos/github/cedx/grinder-coveralls/badge.svg) ![Build](https://github.com/cedx/grinder-coveralls/workflows/Continuous%20integration/badge.svg)

[Grinder](https://pub.dev/packages/grinder) plug-in collecting your code coverage as [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) and uploading it to the [Coveralls](https://coveralls.io) service.

!!! danger
    This package is **abandoned** and no longer maintained.  
    Consider using the [`coverage`](https://pub.dev/packages/coverage) and
    [`coveralls`](https://pub.dev/packages/coveralls) packages as an alternative.

## Quick start
Append the following line to your project's `pubspec.yaml` file:

```yaml
dependencies:
  grinder_coveralls: *
```

Install the latest version of **Grinder-Coveralls** with [Pub](https://dart.dev/tools/pub):

```shell
pub get
```

For detailed instructions, see the [installation guide](installation.md).
