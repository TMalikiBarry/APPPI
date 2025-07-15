import 'package:common_dependencies/models/user/account/account.dart';
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
          await Api.client.get('/customer/account');
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
      /*final Response response =
          await Api.client.get('/comptes/$compteId/details');
      return CompteDetails.fromJson(response.data);*/
      final resp = await Api.client.get('/customer/account');
      logger.i("###### INFOS CONNECTED USER ${resp.data}");

      final wrapped = ResponseModel.fromJson(resp.data as Map<String, dynamic>);
      return wrapped.response.toCompteDetails();

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
