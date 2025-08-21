import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/alias/domain/exceptions/alias_retrieve_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api.dart';
import '../domain/exceptions/invalid_otp_exception.dart';
import '../domain/exceptions/not_available_exception.dart';
import '../domain/models/alias.dart';
import '../domain/models/alias_create_command.dart';
import '../domain/models/alias_revendication.dart';

class AliasOutputRemote {
  //
  static final logger = Logger();

  Future<void> envoyerOtp(String phone, String? channel) async {
    await Api.post('/customer/send-otp', data: {"phone": phone, "channel": channel});
  }

  Future<Alias?> recuperer(String compte) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final ApiResponse response = await Api.get('/alias/sync/search/$compte');
      return response.data != null ? Alias.fromJson(response.data["response"]) : null;
    } on ApiException catch (e) {
      if (e.error != ApiError.notFound && e.error != ApiError.unauthorized){
        logger.i("Retry PI-----------------------");
        try {
          final ApiResponse response = await Api.get('/alias/sync/search/$compte');
          return response.data != null ? Alias.fromJson(response.data["response"]) : null;
        } on ApiException catch (e) {
          if (e.error == ApiError.notFound) {
            throw AliasRetrieveException(error: ApiError.notFound);
          } else {
            throw AliasRetrieveException(error: e.error, cause: e);
          }
        }
      }
      //throw AliasRetrieveException(error: e.error, cause: e);
      // Si c'est un notFound (404), on retourne null
      logger.i("Exception : ApiException ${e.error}");
      if (e.error == ApiError.notFound) {
        logger.i("🔁 Throwing AliasRetrieveException with notFound");
        print("🔁 Throwing AliasRetrieveException with notFound");
        throw AliasRetrieveException(error: ApiError.notFound);
      } else {
        logger.i("🔁 Throwing AliasRetrieveException with ${e.error}");
        throw AliasRetrieveException(error: e.error, cause: e);
      }
    } catch (e) {
      throw AliasRetrieveException(error: ApiError.unknowError, cause: e);
    }
  }


  Future<Alias> creer(AliasCreateCommand alias) async {
    Map<String, dynamic> request = alias.toJson();
    request.addAll({"clientPhoneNumber": "+${alias.compte}"});
    final ApiResponse response = await Api.post('/alias/create', data: request);
    return Alias.fromJson(response.data["response"]);
  }

  Future<void> supprimer(String cle) async {
    await Api.delete('/alias/delete/$cle');
  }

  Future<Alias> confirmer(AliasCreateCommand alias, String otp, String? channel) async {
    try {
      Map<String, dynamic> request = alias.toJson();
      request.addAll({"otpCode": otp});
      if (channel != null){
        request.addAll({"channel": channel});
      }
      final ApiResponse response = await Api.post(
        '/alias/create',
        data: request,
      );
      return Alias.fromJson(response.data["response"]);
    } //
    on ApiException catch (e) {
      if (e.error == ApiError.badRequest) {
        throw AliasInvalidOtpException(cause: e);
      } //
      else if (e.error == ApiError.forbidden) {
        // Le numéro de téléphone existe déjà
        throw AliasNotAvailableException(alias: alias, cause: e);
      } //
      else {
        rethrow;
      }
    }
  }

  Future<void> revendicationInitier(
    String compte,
    AliasCreateCommandPhoneNumber phone,
  ) async {
    Map<String, dynamic> request = {
      "compte": compte,
      "alias": phone.value(),
    };
    await Api.post('/alias/revendications', data: request);
  }

  Future<AliasRevendication?> revendicationRecuperer(
    String id,
  ) async {
    final ApiResponse response = await Api.get('/alias/revendications/$id');
    return response.data != null
        ? AliasRevendication.fromJson(response.data)
        : null;
  }

  Future<AliasRevendication> revendicationRepondre(
    String id,
    bool decision,
    String? otpCode,
  ) async {
    final ApiResponse response;
    if (otpCode == null) {
      response = await Api.put(
        '/alias/revendications/$id/reponses',
        data: {
          "decision": decision,
        },
      );
    } else {
      // Confirmer revendication rejet
      response = await Api.put(
        '/alias/revendications/$id/rejets',
        data: {
          "otp": otpCode,
        },
      );
    }
    return AliasRevendication.fromJson(response.data);
  }
}
