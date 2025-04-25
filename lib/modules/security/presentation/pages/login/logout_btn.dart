import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/custom_alert_dialog.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';

class LogoutBtn extends StatelessWidget {
  //
  const LogoutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocConsumer<LoginBloc, LoginState>(
      // Build form
      builder: (context, loginState) {
        // recuperer la lgoique de gestion du formulaire
        LoginBloc loginBloc = context.read<LoginBloc>();
        return Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Images.iconsLogout, width: 20, height: 20),
                  const SizedBox(width: 15),
                  Text(
                    traductions.profilePageBtnDeconnexion,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?. //
                        copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            ),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  title: traductions.securityLogoutTitle,
                  description: traductions.securityLogoutSubTitle,
                  confirmBtnText: traductions.securityLogoutBtnConfirmer,
                  confirmBtnAction: () {
                    loginBloc.add(const DeconnexionEvent());
                  },
                  cancelBtnText: traductions.securityLogoutBtnAnnuler,
                );
              },
            ),
          ),
        );
      },
      listener: (context, state) {
        // Si challenge,
        if (state is LoginFormState) {
          AppRouter.go(context, AppRouter.login);
        }
      },
    );
  }
}
