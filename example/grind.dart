import 'dart:async';
import 'package:grinder/grinder.dart';
import 'package:grinder_coveralls/grinder_coveralls.dart';

/// The list of source directories.
const List<String> _sources = const ['lib', 'test', 'tool'];

/// Starts the build system.
Future main(List<String> args) => grind(args);

/// Uploads the code coverage to the [Coveralls](https://coveralls.io) service.
@Task()
@Depends(test)
void coverage() {
  // TODO
}

/// Collects the code coverage in [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) format.
@Task()
void test() {
  // TODO
}
