part of grinder_coveralls;

/// Formats [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) coverage reports to the format used by the [Coveralls](https://coveralls.io) service.
class CoverallsFormatter {

  /// TODO
  String format(String coverage) {
    return null;
  }

  /// TODO
  Future<String> formatAsync(String coverage) => new Future<String>.value(format(coverage));

  /// TODO
  String formatFile(File coverage) => format(coverage.readAsStringSync());

  /// TODO
  Future<String> formatFileAsync(File coverage) async => format(await coverage.readAsString());
}
