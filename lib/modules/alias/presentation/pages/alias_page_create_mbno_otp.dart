import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../domain/models/alias_mbno_otp_command.dart';
import '../bloc/alias_bloc.dart';
import '../bloc/alias_event.dart';
import '../bloc/alias_state.dart';
import 'alias_page_create_mbno_timer.dart';
import 'alias_page_otp.dart';

class AliasPageCreateMBNOOtp extends StatelessWidget {
  //
  const AliasPageCreateMBNOOtp({
    super.key,
    required this.aliasState,
  });
  final AliasMBNOVerificationState aliasState;

  // Nombre de chiffres du code PIN
  final int pinLength = AliasMbnoOtpCommand.otpSize;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations localisation = AppLocalizations.of(context)!;
    String phoneNumber = aliasState.values.phoneNumber!.value()!;

    return MyPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Le formulaire
          Expanded(
            child: SingleChildScrollView(
              child: AliasPageOtp(
                pinLength: pinLength,
                title: localisation.verifyPhoneNumberPageTitle,
                subtitle:
                    localisation.verifyPhoneNumberPageSubTitle(phoneNumber),
                errorMessage: aliasState.error != null
                    ? localisation.aliaMBNOInvalidOtpMessage
                    : null,
                countdownTimer: AliasMBNOCountdownTimer(
                  onResendOtp: (channel) => context
                      .read<AliasBloc>()
                      .add(AskPhoneNumberVerificationEvent(aliasState.values, channel)),
                ),
                onOtpComplete: (otpCode) {
                  context
                      .read<AliasBloc>()
                      .add(CheckPhoneNumberVerificationEvent(
                        aliasState.values,
                        otpCode.last,
                        pinLength - 1,
                        AliasMbnoOtpCommand(otpCode),
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
