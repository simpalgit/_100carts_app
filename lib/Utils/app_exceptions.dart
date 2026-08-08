class ServerException implements Exception {
  final dynamic message;

  final int statusCode;

  const ServerException(this.message, [this.statusCode = 404]);
}

///local database exception
class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException(message: $message)';
}

/// default exception
class FetchDataException extends ServerException {
  const FetchDataException(String super.message, [super.statusCode = 666]);
}

///Unsupported Media Type
class DataFormateException extends ServerException {
  const DataFormateException(String super.message, [super.statusCode = 415]);
}

/// The server cannot or will not process the request due to an apparent
/// ///client error (e.g., malformed request syntax, size too large,
/// invalid request message framing, or deceptive request routing
class BadRequestException extends ServerException {
  const BadRequestException(String super.message, [super.statusCode = 400]);
}

class UnauthorisedException extends ServerException {
  const UnauthorisedException(String super.message, [super.statusCode = 401]);
}

class ValidationException extends ServerException {
  const ValidationException(super.message, [super.statusCode = 401]);
}

class InvalidInputException extends ServerException {
  const InvalidInputException(String super.message, [super.statusCode = 400]);
}

class InternalServerException extends ServerException {
  const InternalServerException(String super.message, [super.statusCode = 500]);
}

class NetworkException extends ServerException {
  const NetworkException(String super.message, [super.statusCode = 511]);
}

class UnknowException extends ServerException {
  const UnknowException(String super.message, [super.statusCode = 500]);
}

class ObjectToModelException extends ServerException {
  const ObjectToModelException(String super.message, [super.statusCode = 600]);
}
