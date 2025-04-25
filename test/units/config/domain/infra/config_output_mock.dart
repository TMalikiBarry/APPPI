import 'package:pi_mobile_app/modules/config/domain/models/config_params.dart';
import 'package:pi_mobile_app/modules/config/ports/output/config_output_port.dart';

class MockConfigOutputPort implements ConfigOutputPort {
  @override
  Future<void> modifier(String key, String value) async {
    //
  }

  @override
  ConfigParams recuperer(List<String> keys) {
    // Accept
    final params = {"montant": '123.2', "sens": "credit"};
    return ConfigParams(params);
  }
}
