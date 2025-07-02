import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../../core/api.dart';
import '../domain/exceptions/unknow_account_exception.dart';
import '../domain/models/compte_details.dart';

class CompteOutputRemote {
  //
  CompteOutputRemote();

  static final logger = Logger();

  Future<double> getSolde(String compteId) async {
    try {
      final Response response =
          await Api.client.get('/customer/compte');
      return response.data["response"]["balance"]["balance"] + 0.0;
    } //
    on ApiException catch (e) {
      if (e.error == ApiError.notFound) {
        throw UnknowAccountException(id: compteId, cause: e);
      } //
      else {
        rethrow;
      }
    }
  }

  Future<CompteDetails> getCompte(String compteId) async {
    try {
      final Response response =
          await Api.client.get('/comptes/$compteId/details');
      logger.i(response.data);
      return CompteDetails.fromJson(response.data);
    } //
    on ApiException catch (e) {
      logger.i(e);
      if (e.error == ApiError.notFound) {
        throw UnknowAccountException(id: compteId, cause: e);
      } //
      else {
        rethrow;
      }
    }
  }
}
