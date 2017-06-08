# dirty_check

Observe and be notified when a value changes.

**Warning**: This is not an official Google or Dart project.

## Installation

```yaml
dependencies:
  dirty_check: ^0.1.0
```

## Usage

This library uses [Zones](https://www.dartlang.org/articles/libraries/zones) in
order to be notified when the VM event loop ends. As such you'll need to run
some or all of your code inside of a specific function, `runChecked`, in order
to receive updates:

```dart
import 'package:dirty_check/dirty_check.dart';

main() {
  runChecked(() => startYourApp());
}
```

You can then use the `observe` top-level function to receive a `Stream` which
updates when the observed method or closure changes in value. For example to
be notified when `Person#name` changes:

```dart
set person(Person person) {
  observe(() => person.name).listen((newName) {
    print('The user renamed themselves $newName.');
  });
}
```

## Limitations

In order to avoid performance or code-bloat on some platforms, this library
does *not* use `dart:mirrors`, which means it does not have knowledge of class
structure. As such it may not be practical to use this library to arbitrarily
observe many properties on an object.

Users are encouraged to explore alternative APIs/code generation :)