import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('AsyncResult:', () {
    test('fold with success', () async {
      final result = await getUser(willSucceed: true)
          .fold((value) => 'Hello, $value', (_, __) => 'oops');

      expect(result, 'Hello, John');
    });

    test('fold with future success', () async {
      final result = await getUser(willSucceed: true)
          .fold((value) => Future.value('Hello, $value'), (_, __) => 'oops');

      expect(result, 'Hello, John');
    });

    test('fold with failure', () async {
      final result = await getUser(willSucceed: false)
          .fold((value) => 'Hello, $value', (_, __) => 'oops');

      expect(result, 'oops');
    });

    test('map with success', () async {
      final result = getUser(willSucceed: true);
      final user = await result.map((i) => i.toUpperCase());

      expect(user.asValue, ValueResult('JOHN'));
    });

    test('map with error', () async {
      final result = getUser(willSucceed: false);
      final error = await result.map((i) => i.toUpperCase());

      expect(error.asError?.error, isA<Exception>());
    });

    test('flatMap with success', () async {
      final result = getUser(willSucceed: true);
      final user = await result.flatMap((i) => Result.value(i.toUpperCase()));

      expect(user.asValue, ValueResult('JOHN'));
    });

    test('flatMap with future success', () async {
      final result = getUser(willSucceed: true);
      final user = await result
          .flatMap((i) => Future.value(Result.value(i.toUpperCase())));

      expect(user.asValue, ValueResult('JOHN'));
    });

    test('flatMap with error', () async {
      final result = getUser(willSucceed: false);
      final error = await result
          .flatMap((i) => Future.value(Result.value(i.toUpperCase())));

      expect(error.asError?.error, isA<Exception>());
    });
  });
}

AsyncResult<String> getUser({required bool willSucceed}) =>
    Future.value(Result(() {
      if (willSucceed) {
        return 'John';
      } else {
        throw Exception('Not found');
      }
    }));
