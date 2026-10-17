

import 'dart:async';

// Change this to make everything faster / slower.
const delay = Duration(milliseconds: 500);
//source:
/// 1 2 3 4 5
Stream<int> getNumbers() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(delay);
    yield i;
  }
}

/// 1 1 2 2 3 3 4 4 5 5
Stream<int> getNumbersDouble() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(delay);
    yield i;
    yield i;
  }
}

/// 1 2 then an error, then 3
Stream<int> getNumbersWithError() async* {
  yield 1;
  yield 2;
  yield* Stream.error('something went wrong');
  yield 3;
}


// operations on streams


/// Change every value: 2 4 6 8 10

Future<void> mapStream() async {
   getNumbers()
      .map((number) => number * 2)
      .listen((event) => print('Mapped Number: $event'));
}

/// Keep only what passes the test: 2 4
Future<void> filterStream() async {
  await getNumbers()
      .where((number) => number % 2 == 0)
      .forEach((event) => print('Filtered Number: $event'));
}

/// Remove repeats that come right after each other: 1 2 3 4 5
Future<void> distinctStream() async {
  await getNumbersDouble()
      .distinct()
      .forEach((event) => print('Distinct Number: $event'));
}

/// One value becomes many: 1 → 1, 10
Future<void> expandStream() async {
  await getNumbers()
      .expand((number) => [number, number * 10])
      .forEach((event) => print('Expanded Number: $event'));
}

/// Like map, but the function is async (waits for each one): "user 1" ...
Future<void> asyncMapStream() async {
  await getNumbers()
      .asyncMap((id) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return 'user $id';
      })
      .forEach((event) => print('Async Mapped: $event'));
}

// -----------------------------------------------------------------------------
// Take / skip
// -----------------------------------------------------------------------------

/// First 3 only, then the stream stops: 1 2 3
Future<void> takeStream() async {
  await getNumbers()
      .take(3)
      .forEach((event) => print('Taken Number: $event'));
}

/// Skip the first 2: 3 4 5
Future<void> skipStream() async {
  await getNumbers()
      .skip(2)
      .forEach((event) => print('Skipped Number: $event'));
}

/// Take while the test is true, stop at the first false: 1 2 3
Future<void> takeWhileStream() async {
  await getNumbers()
      .takeWhile((number) => number < 4)
      .forEach((event) => print('Take While: $event'));
}

// -----------------------------------------------------------------------------
// Collect into one value (each one waits for the stream to finish)
// -----------------------------------------------------------------------------

Future<void> collectStream() async {
  print('toList: ${await getNumbers().toList()}');
  print('first: ${await getNumbers().first}');
  print('last: ${await getNumbers().last}');
  print('reduce (sum): ${await getNumbers().reduce((a, b) => a + b)}');
  print('fold (sum from 100): '
      '${await getNumbers().fold(100, (total, n) => total + n)}');
  print('any > 4: ${await getNumbers().any((n) => n > 4)}');
}

// -----------------------------------------------------------------------------
// Errors
// -----------------------------------------------------------------------------

/// handleError catches the error and the stream keeps going.
Future<void> errorStream() async {
  await getNumbersWithError()
      .handleError((error) => print('Caught: $error'))
      .forEach((event) => print('Number: $event'));
}

// -----------------------------------------------------------------------------
// Ways to listen
// -----------------------------------------------------------------------------
// use listen when you need to have subscription control (pause / resume / cancel).
/// await for: reads like a normal loop.
Future<void> awaitForStream() async {
  await for (final number in getNumbers()) {
    print('await for: $number');
    if (number == 3) break; // break = cancel the stream
  }
}

/// listen: gives you a subscription you can pause / resume / cancel.
Future<void> listenStream() async {
  final done = Completer<void>();

  final subscription = getNumbers().listen(
    (event) => print('Listened Number: $event'),
    onDone: () {
      print('Listen done');
      done.complete();
    },
  );

  await Future.delayed(delay * 2.5);
  print('pause for 2 seconds...');
  subscription.pause();

  await Future.delayed(const Duration(seconds: 2));
  print('resume');
  subscription.resume();

  await done.future;
}

// -----------------------------------------------------------------------------
// Chaining: everything together
// -----------------------------------------------------------------------------

/// 1 1 2 2 3 3 4 4 5 5 → distinct → even → x10 → 20 40
Future<void> chainStream() async {
  await getNumbersDouble()
      .distinct()
      .where((number) => number.isEven)
      .map((number) => number * 10)
      .forEach((event) => print('Chained Number: $event'));
}

// -----------------------------------------------------------------------------

Future<void> main() async {
  await run('map', mapStream);
  await run('where', filterStream);
  await run('distinct', distinctStream);
  await run('expand', expandStream);
  await run('asyncMap', asyncMapStream);
  await run('take', takeStream);
  await run('skip', skipStream);
  await run('takeWhile', takeWhileStream);
  await run('toList / first / last / reduce / fold / any', collectStream);
  await run('handleError', errorStream);
  await run('await for', awaitForStream);
  await run('listen + pause / resume', listenStream);
  await run('chain', chainStream);
}

Future<void> run(String title, Future<void> Function() demo) async {
  print('\n===== $title =====');
  await demo();
}
