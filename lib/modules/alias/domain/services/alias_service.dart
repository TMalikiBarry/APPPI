import '../../ports/input/alias_input_port.dart';
import '../../ports/output/alias_output_port.dart';
import '../models/alias.dart';
import '../models/alias_create_command.dart';
import '../models/alias_mbno_otp_command.dart';
import '../models/alias_revendication.dart';

/// Service contenant la logique de gestion des alias
class AliasService implements AliasInputPort {
  //
  final AliasOutputPort aliasOutputPort;

  /// Le service a besoin de [aliasOutputPort]
  const AliasService(this.aliasOutputPort);

  @override
  Future<void> envoyerOtp(String phone, String? channel) {
    return aliasOutputPort.envoyerOtp(phone, channel);
  }

  @override
  Future<Alias> creer(AliasCreateCommand aliasCommand) {
    return aliasOutputPort.creer(aliasCommand);
  }

  @override
  Future<Alias?> recuperer(String compte) async {
    return await aliasOutputPort.recuperer(compte);
  }

  @override
  Future<Alias> confirmer(AliasMbnoOtpCommand otp, AliasCreateCommand alias, String? channel) {
    String otpCode = otp.value.join();
    return aliasOutputPort.confirmer(alias, otpCode, channel);
  }

  @override
  Future<void> supprimer(String cle) async {
    return await aliasOutputPort.supprimer(cle);
  }

  @override
  Future<void> revendiquer(
    String compte,
    AliasCreateCommandPhoneNumber phone,
  ) async {
    await aliasOutputPort.revendicationInitier(compte, phone);
  }

  @override
  Future<AliasRevendication?> recupererRevendication(String id) async {
    return await aliasOutputPort.revendicationRecuperer(id);
  }

  @override
  Future<AliasRevendication> repondreRevendication(
    String id,
    bool decision,
    String? otpCode,
  ) async {
    return await aliasOutputPort.revendicationRepondre(id, decision, otpCode);
  }
}
