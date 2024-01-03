import 'package:dartz/dartz.dart';

class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() {
    return 'Failure: $message';
  }
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class ClientFailure extends Failure {
  ClientFailure(String message) : super(message);
}
