// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:async_track/async_track.dart';

// Unique object used to check for presence of a specific zone.
final Object _dirtyCheckZone = new Object();

typedef AsyncTracker _GetAsyncTracker();

/// Execute [run] within a [Zone] that checks objects after asynchronous events.
///
/// ## Example use
///
/// ```dart
/// import 'package:dirty_check/dirty_check.dart';
///
/// main() {
///  runChecked(() => startYourApp());
/// }
/// ```
R runChecked<R>(R run()) {
  // Short circuit if we already in a dirty-checking zone.
  if (Zone.current[_dirtyCheckZone] != null) {
    return run();
  }
  // TODO: Remove the need to wrap in another zone.
  AsyncTracker tracker;
  AsyncTracker getTracker() => tracker;
  return runZoned(() {
    return (tracker = new AsyncTracker()).runTracked(run);
  }, zoneValues: <dynamic, dynamic>{_dirtyCheckZone: getTracker});
}

/// Returns a stream that emits when the result of calling [value] changes.
///
/// May define an [equals] implementation, otherwise defaults to `==`:
/// ```dart
/// observe(() => someObj.value, equals: identical);
/// ```
///
/// Throws [StateError] if not run within a [runChecked] zone.
Stream<R> observe<R>(R value(), {bool equals(R a, R b)}) {
  final getTracker = (Zone.current[_dirtyCheckZone] as _GetAsyncTracker);
  final tracker = getTracker != null ? getTracker() : null;
  if (tracker == null) {
    throw new StateError('Not used within runChecked.');
  }
  return tracker.onTurnEnd.map((_) => value()).distinct(equals);
}
