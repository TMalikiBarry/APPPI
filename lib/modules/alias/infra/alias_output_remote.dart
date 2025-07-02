import 'package:logger/logger.dart';

import '../../../core/api.dart';
import '../domain/exceptions/invalid_otp_exception.dart';
import '../domain/exceptions/not_available_exception.dart';
import '../domain/models/alias.dart';
import '../domain/models/alias_create_command.dart';
import '../domain/models/alias_revendication.dart';

class AliasOutputRemote {
  //
  static final logger = Logger();

  Future<void> envoyerOtp(String phone) async {
    await Api.post('/customer/send-otp', data: {"phone": phone});
  }

  Future<Alias?> recuperer(String compte) async {
    try {
      final ApiResponse response = await Api.get('/alias/sync/search/+$compte');
      return response.data != null ? Alias.fromJson(response.data["response"]) : null;
    } //
    catch (e) {
      // Si l'api retourne 404 c'est qu'il y'a pas d'alias
      if (e is ApiException && e.error == ApiError.notFound) {
        return null;
      } // Sinon  c'est une erreur imprévisible qu'il faut notifier
      else {
        rethrow;
      }
    }
  }

  Future<Alias> creer(AliasCreateCommand alias) async {
    Map<String, dynamic> request = alias.toJson();
    request.addAll({"clientPhoneNumber": "+${alias.compte}"});
    final ApiResponse response = await Api.post('/alias/create', data: request);
    return Alias.fromJson(response.data["response"]);
  }

  Future<void> supprimer(String cle) async {
    await Api.delete('/alias/$cle');
  }

  Future<Alias> confirmer(AliasCreateCommand alias, String otp) async {
    try {
      Map<String, dynamic> request = alias.toJson();
      request.addAll({"otpCode": otp});
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
