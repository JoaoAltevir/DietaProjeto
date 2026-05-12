// 
abstract class Result<S, E> {
  const Result();
}

class Ok<S, E> extends Result<S, E> {
  final S value;
  const Ok(this.value);
}

class Err<S, E> extends Result<S, E> {
  final E error;
  const Err(this.error);
}