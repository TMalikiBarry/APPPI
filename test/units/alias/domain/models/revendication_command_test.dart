import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_revendication.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_type.dart';

void main() {

  group('AliasRevendicationStatut', () {
    test('valid statut initiee test', () {
     
      final statutInitie = AliasRevendicationStatut.get("INITIEE");

      expect(statutInitie, AliasRevendicationStatut.initiee);
    });

    test('valid statut acceptee test', () {
     
      final statutAccepte = AliasRevendicationStatut.get("ACCEPTEE");

      expect(statutAccepte, AliasRevendicationStatut.acceptee);
    });

    test('valid statut rejetee test', () {
     
      final statutRejete = AliasRevendicationStatut.get("REJETEE");

      expect(statutRejete, AliasRevendicationStatut.rejetee);
    });

    test('invalid statut test', () {
     
      expect(() => AliasRevendicationStatut.get("INCONNUE"), throwsA(isA<ArgumentError>()));
      
    });
    
  });


  group('RevendicationCommand', () {
    test('valid revendication test', () {
     
      final aliasRevendication = AliasRevendication(
        
        id: "1234",
        alias: "+221775177023",
        statut: AliasRevendicationStatut.initiee,
        dateDemande: DateTime.now(),
        dateAction: DateTime.now(), 
        dateVerrouillage: DateTime.now(),
        dateCloture: DateTime.now()
      );

      expect(aliasRevendication.statut.value, "INITIEE");
    });
    
    test('valid revendication fromJson with dateAction test', () {
     
      final aliasRevendication = AliasRevendication.fromJson({
        "id": "1234",
        "alias": "+221775177023",
        "statut": "INITIEE",
        "dateDemande": DateTime.now().toString(),
        "dateAction": DateTime.now().toString(),
        "dateVerrouillage": DateTime.now().toString(),
        "dateCloture": DateTime.now().toString(),
        "shid": {
            'cle': "se2344ddcdcsxsxsdscc",
            'type': 'MBNO',
            'compte': 'CI123456789',
            'pays': 'SN'
          }
      });
      
      expect(aliasRevendication.statut, AliasRevendicationStatut.initiee);
    });

    test('valid revendication fromJson without dateAction and shid test', () {
     
      Map<dynamic, dynamic> json = {
        "id": "1234",
        "alias": "+221775177023",
        "statut": "INITIEE",
        "dateDemande": DateTime.now().toString(),
        "dateVerrouillage": DateTime.now().toString(),
        "dateCloture": DateTime.now().toString(),
        };
      
      final aliasRevendication = AliasRevendication.fromJson(json);
      expect(aliasRevendication.dateAction, null);
      expect(aliasRevendication.shid, null);
    });

    test('revendication to Json test', () {
     
      final aliasRevendication = AliasRevendication(
        id: "1234",
        alias: "+221775177023",
        statut: AliasRevendicationStatut.initiee,
        dateDemande: DateTime.now(),
        dateAction: DateTime.now(),
        dateVerrouillage: DateTime.now(),
        dateCloture: DateTime.now(),
        shid: Alias(
          cle: "se2344ddcdcsxsxsdscc",
          type: AliasType.shid,
          compte: 'CI123456789',
          pays: "SN"
        )
      );

      Map<dynamic, dynamic> revendicationJson = aliasRevendication.toJson();
      expect(revendicationJson["statut"], AliasRevendicationStatut.initiee.name);
    });
  });

 }
