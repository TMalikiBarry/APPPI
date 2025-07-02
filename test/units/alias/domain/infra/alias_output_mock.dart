import 'package:flutter/foundation.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_create_command.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_revendication.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_type.dart';
import 'package:pi_mobile_app/modules/alias/ports/output/alias_output_port.dart';

class MockAliasOutputPort implements AliasOutputPort {
  @override
  Future<Alias> confirmer(AliasCreateCommand alias, String otp) async {
    return Alias(
        cle: "+221775177023",
        type: AliasType.mbno,
        compte: 'CI123456789',
        pays: 'SN');
  }

  @override
  Future<Alias> creer(AliasCreateCommand alias) async {
    return Alias(
        cle: "d2d3d3ae-87e1-4440-9c3f-39fdd232a308",
        type: AliasType.shid,
        compte: 'CI123456789',
        pays: 'SN');
  }

  @override
  Future<Alias?> recuperer(String compte) async {
    return Alias(
        cle: "+221775177023",
        type: AliasType.mbno,
        compte: 'CI123456789',
        pays: 'SN');
  }

  @override
  Future<void> supprimer(String cle) async {
    //
  }
  
  @override
  Future<void> revendicationInitier(String compte, AliasCreateCommandPhoneNumber phone) async {
     //
  }
  
  @override
  Future<AliasRevendication?> revendicationRecuperer(String id) async {
    return AliasRevendication(
      id: "1234",
      alias: "+221775177023",
      statut: AliasRevendicationStatut.initiee,
      dateDemande: DateTime.now(),
      dateAction: DateTime.now(),
      dateVerrouillage: DateTime.now(),
      dateCloture: DateTime.now()
    );
  }
  
  @override
  Future<AliasRevendication> revendicationRepondre(String id, bool decision, String? otpCode) async {
    return AliasRevendication(
        id: "1234",
        alias: "+221775177023",
        statut: AliasRevendicationStatut.initiee,
        dateDemande: DateTime.now(),
        dateAction: DateTime.now(),
        dateVerrouillage: DateTime.now(),
        dateCloture: DateTime.now()
      );
  }

  @override
  Future<void> envoyerOtp(String phone) async {
    //
  }
}

class MockAliasErrorOutputPort implements AliasOutputPort {
  @override
  Future<Alias> confirmer(AliasCreateCommand alias, String otp) async {
    return Alias(
        cle: "+221775177023",
        type: AliasType.mbno,
        compte: 'CI123456789',
        pays: 'CI');
  }

  @override
  Future<Alias> creer(AliasCreateCommand alias) async {
    return Alias(
        cle: "d2d3d3ae-87e1-4440-9c3f-39fdd232a308",
        type: AliasType.shid,
        compte: 'CI123456789',
        pays: 'CI');
  }

  @override
  Future<Alias?> recuperer(String compte) async {
    throw ErrorDescription("Erreur inconnue");
  }

  @override
  Future<void> supprimer(String cle) async {
    //
  }

  @override
  Future<void> revendicationInitier(String compte, AliasCreateCommandPhoneNumber phone) async {
    
  }

  @override
  Future<AliasRevendication?> revendicationRecuperer(String id) async {
     return AliasRevendication(
        id: "1234",
        alias: "+221775177023",
        statut: AliasRevendicationStatut.initiee,
        dateDemande: DateTime.now(),
        dateAction: DateTime.now(),
        dateVerrouillage: DateTime.now(),
        dateCloture: DateTime.now()
      );
  }
  
  @override
  Future<AliasRevendication> revendicationRepondre(String id, bool decision, String? otpCode) {
    // TODO: implement revendicationRepondre
    throw UnimplementedError();
  }

  @override
  Future<void> envoyerOtp(String phone) async {
    //
  }
}
