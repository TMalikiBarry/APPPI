import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';

void main() {
  group('AliasCreateCommand', () {
    test('isValid should return true for +223773242452', () {
      final json = {
        "id": "123",
        "sub": "12547852",
        "username": "06946",
        "firstName": "Khady",
        "lastName": "Diop",
        "country": "SN",
        "address": "nord foire",
        "telephone": "+221773242452"
      };
      ConnectedUser user = ConnectedUser.fromJson(json);
      expect(user.nomComplet(), "Khady Diop");
      expect(user.reference(), "06946");
      expect(user.initiales(), "KD");
    });

    test('isValid should return true for +223773242452', () {
      final json = {
        "id": "123",
        "sub": "12547852",
        "username": "06946",
        "firstName": "Khady",
        "lastName": "Diop",
        "country": "SN",
        "address": "nord foire",
        "telephone": "+221773242452"
      };
      final expected = {
        "sub": "12547852",
        "username": "06946",
        "firstName": "Khady",
        "lastName": "Diop",
        "country": "SN",
        "address": "nord foire",
        "telephone": "+221773242452",
        'email': null,
        'avatar': null
      };
      ConnectedUser user = ConnectedUser.fromJson(json);
      expect(user.toJson(user), expected);
    });
  });
}
