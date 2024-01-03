import 'dart:async';
import 'dart:io';

import 'package:animal/core/either.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

class ApiCallWithError {
  const ApiCallWithError._();

  static Future<Either<Failure, Response>> call<T>(
      Future<Response> Function() f) async {
    try {
      Response response = await f();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response);
      } else if (response.statusCode == 400) {
        return Left(ClientFailure('Bad request'));
      } else {
        if (response.statusCode == 401) {
          return Left(ClientFailure('Unauthorized'));
        } else if (response.statusCode == 403) {
          return Left(ClientFailure('Forbidden'));
        } else if (response.statusCode == 404) {
          return Left(ClientFailure('Not found'));
        } else if (response.statusCode == 500) {
          return Left(ServerFailure('Internal server error'));
        } else {
          return Left(Failure('Something went wrong'));
        }
      }
    } on SocketException {
      return Left(NetworkFailure('No internet connection'));
    } on HttpException {
      return Left(ClientFailure('Could not connect to the server'));
    } on FormatException {
      return Left(ClientFailure('Bad response format'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
