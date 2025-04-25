import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/config/domain/models/config_params.dart';
import 'package:pi_mobile_app/modules/config/domain/services/config_service.dart';

import '../infra/config_output_mock.dart';

void main() {
  group('ConfigService - cas succès', () {
    ConfigService service = ConfigService(MockConfigOutputPort());

    test("Recuperer - les parametres ", () async {
      expect(
          (service.recuperer().toString()),
          const ConfigParams({"montant": '123.2', "sens": "credit"})
              .toString());
    });
    test("Modifier - les parametres", () async {
      expect((service.modifier("sens", "credit")), isA<void>());
    });
  });
}
