// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:dirty_check/dirty_check.dart';
import 'package:test/test.dart';

void main() {
  test('should throw if `observe` is used outside of a Zone', () {
    expect(() => observe(() => ''), throwsStateError);
  });

  test('should observe changes', () async {
    final changes = <String>[];
    await runChecked(() async {
      String name = '';
      final sub = observe(() => name).listen(changes.add);
      name = 'A';
      await new Future<Null>.delayed(Duration.ZERO);
      name = 'B';
      await new Future<Null>.delayed(Duration.ZERO);
      name = 'C';
      await new Future<Null>.delayed(Duration.ZERO);
      sub.cancel();
    });
    expect(changes, ['A', 'B', 'C']);
  });
}
