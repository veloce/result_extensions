import 'package:async/async.dart';

extension ResultExtension<T> on Result<T> {
  /// Returns the value from this [ValueResult] or the result of `orElse()` if this is a [ErrorResult].
  T getOrElse(T Function() orElse) => isValue ? asValue!.value : orElse();

  /// Applies `onSuccess` if this is a [ValueResult] or `onError` if this is a [ErrorResult].
  U fold<U>(U Function(T value) onSuccess,
          U Function(Object error, StackTrace? stackTrace) onError) =>
      isValue
          ? onSuccess(asValue!.value)
          : onError(asError!.error, asError!.stackTrace);

  /// Execute `onSuccess` in case of [ValueResult] or `onError` in case of [ErrorResult].
  void match({
    void Function(T value)? onSuccess,
    void Function(Object error, StackTrace? stackTrace)? onError,
  }) {
    if (onSuccess != null && isValue) {
      onSuccess(asValue!.value);
    }
    if (onError != null && isError) {
      onError(asError!.error, asError!.stackTrace);
    }
  }

  /// Maps a [Result<S, F>] to [Result<U, F>] by applying a function
  /// to a contained [ValueResult] value, leaving an [ErrorResult] value untouched.
  ///
  /// This function can be used to compose the results of two functions.
  Result<U> map<U>(U Function(T) f) =>
      isValue ? Result.value(f(asValue!.value)) : this as Result<U>;

  /// Apply a function to a contained [ValueResult] value
  ///
  /// Equivalent to `match(onSuccess: (value) { // do sth with value })`
  void forEach(void Function(T) f) {
    if (isValue) {
      f(asValue!.value);
    }
  }

  /// Maps a [Result<S, F>] to [Result<U, F>] by applying a function
  /// to a contained [ValueResult] value and unwrapping the produced result,
  /// leaving an [ErrorResult] value untouched.
  ///
  /// Use this method to avoid a nested result when your transformation
  /// produces another [Result] type.
  Result<U> flatMap<U>(Result<U> Function(T) f) =>
      isValue ? f(asValue!.value) : this as Result<U>;
}
