import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('Result:', () {
    test('getOrElse with success', () {
      final result = getUser(willSucceed: true);

      expect(result.getOrElse(() => 'whatever'), 'John');
    });

    test('getOrElse with failure', () {
      final result = getUser(willSucceed: false);

      expect(result.getOrElse(() => 'whatever'), 'whatever');
    });

    test('fold with success', () {
      final result = getUser(willSucceed: true);

      expect(
        result.fold((value) => 'Hello, $value', (_, __) => 'oops'),
        'Hello, John',
      );
    });

    test('fold with failure', () {
      final result = getUser(willSucceed: false);

      expect(
          result.fold((value) => 'Hello, $value', (_, __) => 'oops'), 'oops');
    });

    test('match with failed', () {
      final failedResult = getUser(willSucceed: false);

      String? onSuccessResult;
      Object? onFailureResult;
      failedResult.match(
        onSuccess: (value) => onSuccessResult = value,
        onError: (error, _) => onFailureResult = error.toString(),
      );
      expect(onSuccessResult, isNull);
      expect(onFailureResult, 'Exception: Not found');
    });

    test('match with success', () {
      final successResult = getUser(willSucceed: true);

      String? onSuccessResult;
      Object? onFailureResult;
      successResult.match(
        onSuccess: (value) => onSuccessResult = value,
        onError: (error, _) => onFailureResult = error,
      );
      expect(onSuccessResult, 'John');
      expect(onFailureResult, isNull);
    });

    test('forEach with failure', () {
      final result = getUser(willSucceed: false);
      String? test;
      result.forEach((value) => test = value);
      expect(test, isNull);
    });

    test('forEach with success', () {
      final result = getUser(willSucceed: true);
      String? test;
      result.forEach((value) => test = value);
      expect(test, 'John');
    });

    test('map with success', () {
      final result = getUser(willSucceed: true);
      final user = result.map((i) => i.toUpperCase()).asValue;

      expect(user, ValueResult('JOHN'));
    });

    test('map with error', () {
      final result = getUser(willSucceed: false);
      final error = result.map((i) => i.toUpperCase()).asError?.error;

      expect(error, isA<Exception>());
    });

    test('flatMap with success', () {
      final result = getUser(willSucceed: true);
      final user = result.flatMap((i) => Result.value(i.toUpperCase())).asValue;

      expect(user, ValueResult('JOHN'));
    });

    test('flatMap with error', () {
      final result = getUser(willSucceed: false);
      final error =
          result.flatMap((i) => Result.value(i.toUpperCase())).asError?.error;

      expect(error, isA<Exception>());
    });
  });
}

Result<String> getUser({required bool willSucceed}) => Result(() {
      if (willSucceed) {
        return 'John';
      } else {
        throw Exception('Not found');
      }
    });
