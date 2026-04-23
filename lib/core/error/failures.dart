abstract class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class SystemFailure extends Failure {
  const SystemFailure(super.message);
}
