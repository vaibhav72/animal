import 'dart:convert';

import 'package:animal/core/api/api_call_with_error.dart';
import 'package:animal/utils/meta_strings.dart';
import 'package:dartz/dartz.dart';

import '../../core/either.dart';
import '../../core/http_client.dart';
import '../models/bear_model.dart';

class BearRepository {
  final HttpClient _httpClient;

  BearRepository(this._httpClient);

  Future<Either<Failure, List<Bear>>> getBears(int page) {
    return ApiCallWithError.call(() async {
      return await _httpClient.get("${MetaStrings.getBears}?page=$page");
    }).then((value) => value.fold((l) => Left(l), (r) {
          List<Bear> bears = [];
          for (var bear in (jsonDecode(r.body) as List)) {
            bears.add(Bear.fromJson(bear));
          }
          return Right(bears);
        }));
  }

  Future<Either<Failure, Bear>> createBear(Map<String, dynamic> bearData) {
    return ApiCallWithError.call(() async {
      return await _httpClient.post(MetaStrings.createBear, bearData);
    }).then((value) => value.fold(
        (l) => Left(l), (r) => Right(Bear.fromJson(jsonDecode(r.body)))));
  }

  Future<Either<Failure, dynamic>> updateBear(
      String bearId, Map<String, dynamic> updatedData) {
    return ApiCallWithError.call(() async {
      return await _httpClient.put(
          "${MetaStrings.updateBear}/$bearId", updatedData);
    }).then((value) => value.fold(
        (l) => Left(l), (r) => Right(Bear.fromJson(jsonDecode(r.body)))));
    ;
  }

  Future<Either<Failure, bool>> deleteBear(String bearId) {
    return ApiCallWithError.call(() async {
      return await _httpClient.delete(
        '${MetaStrings.deleteBear}/$bearId',
      );
    }).then((value) => value.fold((l) => Left(l), (r) => const Right(true)));
  }
}
