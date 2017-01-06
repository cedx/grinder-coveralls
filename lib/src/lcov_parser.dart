part of grinder_coveralls;

/// Parses [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) coverage reports as [Coveralls](https://coveralls.io) hitmaps.
class LcovParser {

  /// TODO
  Future<Map> parse(String coverage) {
    List<Map> data = [];
    Map item;

    List<String> lines = ['end_of_record'];
    lines.addAll(coverage.split(new RegExp(r'\r?\n')));
    lines.forEach((String line) {
      line = line.trim();

      if (line.contains('end_of_record')) {
        data.add(item);
        item = _createRecord();
      }
    });

    return null;
  }

  /// TODO
  Future<Map> parseFile(File coverage) async => parse(await coverage.readAsString());

  /// TODO
  Map<String, Map> _createRecord() => {
    'branches': {
      'details': [],
      'found': 0,
      'hit': 0
    },
    'functions': {
      'details': [],
      'found': 0,
      'hit': 0
    },
    'lines': {
      'details': [],
      'found': 0,
      'hit': 0
    }
  };
}
