import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';

void main() async {
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
}

Future<User> fetch(bool withError) async {
  await Future<void>.delayed(const Duration(milliseconds: 100));
  if (withError) {
    throw ExampleException();
  } else {
    return User(username: 'john');
  }
}

FutureResult fetchResult({required bool withError}) =>
    Result.capture(fetch(withError));

class User {
  final String username;

  const User({required this.username});
}

class ExampleException implements Exception {
  final String message = 'Some Failure happened';
  @override
  toString() => message;
}
