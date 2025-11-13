import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/menu_actions_widget.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../../security/presentation/bloc/login/login_bloc.dart';
import '../bloc/alias_bloc.dart';
import '../bloc/alias_event.dart';

class AliasPageCreateOptions extends StatelessWidget {
  //
  const AliasPageCreateOptions({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    AliasBloc aliasBloc = context.read<AliasBloc>();
    //
    String compte = context.read<LoginBloc>().getConnectedUser()!.reference();
    String phoneNumber = context.read<LoginBloc>().getConnectedUser()!.reference();
    return MyPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Le formulaire
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Titre de la page
                  Text(
                    traductions.aliasCreatePageTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  //
                  const SizedBox(height: 5.0),
                  // Sous titre de la page
                  Text(
                    traductions.aliasCreatePageSubTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  //
                  const SizedBox(height: 32),

                  // Bouton créer alias SHID
                  MenuActionsWiget(
                    items: [
                      // Programmer un paiement
                      MenuActionItem(
                        Images.aliasIconUser,
                        traductions.aliasCreateSHIDTitle,
                        traductions.aliasCreateSHIDSubTitle,
                        () => aliasBloc.add(CreateAliasSHIDEvent(compte)),
                        iconSize: 20,
                      ),
                    ],
                  ),

                  // Séparateur
                  const SizedBox(height: 20.0),

                  // - type MBNO
                  MenuActionsWiget(
                    items: [
                      // Programmer un paiement
                      MenuActionItem(
                        Images.aliasIconPhone,
                        traductions.aliasCreateMBNOTitle,
                        traductions.aliasCreateMBNOSubTitle,
                            () => {
                          aliasBloc.add(CreateAliasMBNOEvent(compte, )),
                        },
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
