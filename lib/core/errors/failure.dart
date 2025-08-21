// Base failure class
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Server Failure"]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache Failure"]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No Internet"]);
}
