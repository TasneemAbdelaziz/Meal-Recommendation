enum ErrorType {
  dns,
  timeout,
  noInternet,
  credentials,
  server,
  unknown,
}

class Failure {
  final String message;
  final ErrorType? errorType;

  Failure([this.message = "an expected error", this.errorType]);
  
  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message, ErrorType.server);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message, [ErrorType? type]) 
      : super(message, type ?? ErrorType.noInternet);
}

class DnsFailure extends Failure {
  DnsFailure(String message) : super(message, ErrorType.dns);
}

class TimeoutFailure extends Failure {
  TimeoutFailure(String message) : super(message, ErrorType.timeout);
}

class ConnectionFailure extends Failure {
  ConnectionFailure(String message) : super(message, ErrorType.noInternet);
}

class CredentialsFailure extends Failure {
  CredentialsFailure(String message) : super(message, ErrorType.credentials);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}
