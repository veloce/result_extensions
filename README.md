Useful extensions on [Result](https://pub.dev/documentation/async/latest/async/Result-class.html) class of [async package](https://pub.dev/packages/async).

## Features

- `FutureResult<T>` alias for `Future<Result<T>>`
- `Result<U> map<U>(U Function(T) f);`
- ` Result<T> mapError<E extends Object>(E Function(Object error, StackTrace? stackTrace) f);`
- `Result<U> flatMap<U>(Result<U> Function(T) f);`
- `U fold<U>(U Function(T value) onSuccess, U Function(Object error, StackTrace? stackTrace) onError);`
- `T getOrElse(T Function() orElse);`
- `T getOrThrow();`
- `void match({ void Function(T value)? onSuccess, void Function(Object error, StackTrace? stackTrace)? onError });`
- `void forEach(void Function(T) f)`

## Usage

```dart
final username = await fetchResult(withError: false).fold(
  (user) => user.username,
  (error, _) => 'Cannot fetch user: $error',
);
print(username); // john

final usernameNotOk = await fetchResult(withError: true).fold(
  (user) => user.username,
  (error, _) => 'Cannot fetch user: $error',
);
print(usernameNotOk); // Cannot fetch user: Some Failure happened

final helloUser =
    await fetchResult(withError: false).map((r) => 'hello ${r.username}');
print(helloUser.getOrElse(() => 'Hello, anonymous')); // hello john
```
