part of grinder_coveralls;

/// Uploads the specified code [coverage] report in LCOV format to the Coveralls service.
void uploadCoverage(dynamic coverage) {
  var path = coverage is FilePath ? coverage : new FilePath(coverage);
  new CoverallsClient().uploadFile(path.asFile);
}

/// Uploads asynchronously the specified code [coverage] report in LCOV format to the Coveralls service.
Future uploadCoverageAsync(dynamic coverage) async {
  var path = coverage is FilePath ? coverage : new FilePath(coverage);
  await new CoverallsClient().uploadFileAsync(path.asFile);
}

/// Uploads code coverage reports to the [Coveralls](https://coveralls.io) service.
class CoverallsClient {

  /// The URL of the API end point.
  static final Uri endPoint = Uri.parse('https://coveralls.io/api/v1/jobs');

  /// The stream of "request" events.
  Stream<http.Request> get onRequest => _onRequest.stream;

  /// The stream of "response" events.
  Stream<http.Response> get onResponse => _onResponse.stream;

  /// The handler of "request" events.
  final StreamController<http.Request> _onRequest = new StreamController<http.Request>.broadcast();

  /// The handler of "response" events.
  final StreamController<http.Response> _onResponse = new StreamController<http.Response>.broadcast();

  /// Uploads the specified code [coverage] report in LCOV format to the Coveralls service.
  http.Response upload(String coverage) {
    var lcov;
    new Future<String>.sync(() => uploadAsync(coverage)).then((response) => lcov = response);
    return lcov;
  }

  /// Uploads asynchronously the specified code [coverage] report in LCOV format to the Coveralls service.
  Future<http.Response> uploadAsync(String coverage) async {
    assert(coverage != null);
    var jsonFile = JSON.encode({
      'service_name': 'travis-ci'
    });

    var request = new http.Request('POST', endPoint)..bodyFields = {'json_file': jsonFile};
    _onRequest.add(request);
    var response = await http.post(request.url, body: request.bodyFields);
    _onResponse.add(response);
    return response;
  }

  /// Uploads the specified code [coverage] report in LCOV format to the Coveralls service.
  http.Response uploadFile(File coverage) => upload(coverage.readAsStringSync());

  /// Uploads asynchronously the specified code [coverage] report in LCOV format to the Coveralls service.
  Future<http.Response> uploadFileAsync(File coverage) async => await uploadAsync(await coverage.readAsString());
}
