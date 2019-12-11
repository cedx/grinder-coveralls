# Installation

## Requirements
Before installing **Grinder-Coveralls**, you need to make sure you have the [Dart SDK](https://dart.dev/tools/sdk)
and [Pub](https://dart.dev/tools/pub/cmd), the Dart package manager, up and running.

!!! warning
    Grinder-Coveralls requires Dart >= **2.7.0**.

You can verify if you're already good to go with the following commands:

```shell
dart --version
# Dart VM version: 2.7.0 (Fri Dec 6 16:26:51 2019 +0100) on "windows_x64"

pub --version
# Pub 2.7.0
```

!!! info
    If you plan to play with the package sources, you will also need
    [Material for MkDocs](https://squidfunk.github.io/mkdocs-material).

## Installing with Pub package manager

### 1. Depend on it
Add this to your project's `pubspec.yaml` file:

```yaml
dependencies:
  grinder_coveralls: *
```

### 2. Install it
Install this package and its dependencies from a command prompt:

```shell
pub get
```

### 3. Import it
Now in your [Dart](https://dart.dev) code, you can use:

```dart
import 'package:grinder_coveralls/grinder_coveralls.dart';
```
