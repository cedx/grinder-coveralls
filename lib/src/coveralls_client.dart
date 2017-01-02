part of grinder_coveralls;

/// Collects the code coverage in [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format and uploads it to the [Coveralls](https://coveralls.io) service.
class Client {

  /// Uploads the specified code [coverage] in LCOV format to the Coveralls service.
  Future<http.Response> upload(String coverage) {
    assert(coverage != null);

    var request = JSON.encode({
      'service_name': 'travis-ci'
    });

    return http.post('https://coveralls.io/api/v1/jobs', body: {'json_file': request});
  }
}
