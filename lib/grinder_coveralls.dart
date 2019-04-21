/// [Grinder](https://google.github.io/grinder.dart) plug-in collecting the code coverage and uploading it to [Coveralls](https://coveralls.io).
library grinder_coveralls;

import 'dart:convert';
import 'dart:io';
import 'package:code_builder/code_builder.dart';
import 'package:coverage/coverage.dart';
import 'package:coveralls/coveralls.dart';
import 'package:crypto/crypto.dart';
import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as p;

part 'src/collector.dart';
part 'src/functions.dart';
