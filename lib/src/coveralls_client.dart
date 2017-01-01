part of grinder_coveralls;

/// Collects the code coverage in [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format and uploads it to the [Coveralls](https://coveralls.io) service.
class Client {

  /// Runs the specified [script] and returns its code coverage in LCOV format.
  /// A list provides the script [arguments].
  Future<String> collect(String script, {List<String> arguments}) async {
    var coverage = await runAndCollect(script, scriptArgs: arguments);
    var formatter = new LcovFormatter(new Resolver());
    return await formatter.format(coverage);
  }

  /// Uploads the specified code [coverage] in LCOV format to the Coveralls service.
  Future<http.Response> upload(String coverage) {
    assert(coverage != null);

    var request = JSON.encode({
      'service_name': 'travis-ci'
    });

    return http.post('https://coveralls.io/api/v1/jobs', body: {'json_file': request});
  }
}
