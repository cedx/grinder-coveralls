part of grinder_coveralls;

/// Formats [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) coverage reports to the format used by the [Coveralls](https://coveralls.io) service.
class CoverallsFormatter {

  /// TODO
  Future<String> format(String coverage) {
    return null;
  }

  /// TODO
  Future<String> formatFile(File coverage) async => format(await coverage.readAsString());
}
