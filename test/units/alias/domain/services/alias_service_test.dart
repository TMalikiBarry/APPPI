import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_create_command.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_mbno_otp_command.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_revendication.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_type.dart';
import 'package:pi_mobile_app/modules/alias/domain/services/alias_service.dart';
import 'package:pi_mobile_app/modules/alias/ports/input/alias_input_port.dart';
import 'package:pi_mobile_app/shared/models/uemoa_countries.dart';

import '../infra/alias_output_mock.dart';

void main() {
  group('AliasService - cas succès', () {
    AliasInputPort service = AliasService(MockAliasOutputPort());

    test("Recuperer - L'utilisateur n'a pas d'alias", () async {
      expect(
          (await service.recuperer("CI12334002B"))!.toJson(),
          Alias(
                  cle: "+221775177023",
                  type: AliasType.mbno,
                  compte: 'CI123456789',
                  pays: 'SN')
              .toJson());
    });

    test("Creer - création d'alias shid", () async {
      expect(
          (await service.creer(AliasCreateCommand(
                  type: AliasType.shid, compte: "CI123456789")))
              .toJson(),
          Alias.fromJson({
            "cle": "d2d3d3ae-87e1-4440-9c3f-39fdd232a308",
            "type": AliasType.shid.code,
            "compte": 'CI123456789',
            "pays": "SN"
          }).toJson());
    });

    test("Confirmer - création d'alias mbno", () async {
      final pays = UEMOACountry(
          iso: "BJ", name: "Benin", phoneCode: "+229", flag: "🇧🇯");
      expect(
          (await service.confirmer(
            AliasMbnoOtpCommand([0, 1, 2, 3, 4, 5]),
            AliasCreateCommand(
              compte: "CI123456789",
              type: AliasType.mbno,
              phoneNumber: AliasCreateCommandPhoneNumber(
                indicatif: pays.phoneCode,
                phone: "775177023",
              ),
            ),
          ))
              .toJson(),
          Alias(
                  cle: "+221775177023",
                  type: AliasType.mbno,
                  compte: 'CI123456789',
                  pays: UEMOACountry.get("SN")!.iso)
              .toJson());
    });

    test("Recuperer - catch got null", () async {
      AliasInputPort serviceErreur = AliasService(MockAliasErrorOutputPort());
      try {
        await serviceErreur.recuperer("CI12334002B");
      } catch (e) {
        expect(e.toString(), ErrorDescription("Erreur inconnue").toString());
      }
    });
    test("supprimer ", () async {
      expect(service.supprimer("CI12334002B"), isA<void>());
    });
  });

  group('Revendication - cas succès', () {
    AliasInputPort service = AliasService(MockAliasOutputPort());

    test("Recuperer ", () async {

      var revendication = await service.recupererRevendication("1234");
      expect( revendication?.alias, "+221775177023");
    });

    test("Initier ", () async {
      final pays = UEMOACountry(
          iso: "BJ", name: "Benin", phoneCode: "+229", flag: "🇧🇯");
      var result = await service.revendiquer(
        "CI123456789",
          AliasCreateCommandPhoneNumber(
          indicatif: pays.phoneCode,
          phone: "775177023",
        ));
      expect(() => result, isA<void>());
    });

    test("Repondre ", () async {
     
      final result =  await service.repondreRevendication("1234", true, "12345");

      expect(result.id, "1234");
    });

  });

}
