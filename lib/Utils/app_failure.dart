abstract class Failure {
  final dynamic message;
  final int statusCode;

  const Failure(this.message, [this.statusCode = 404]);

  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, super.statusCode);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String super.message);
}
