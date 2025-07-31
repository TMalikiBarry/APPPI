import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/uemoa_countries.dart';
import '../../../../shared/widgets/input_text.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../../security/domain/models/connected_user.dart';
import '../../../security/presentation/bloc/login/login_bloc.dart';
import '../../domain/models/alias_create_command.dart';
import '../bloc/alias_bloc.dart';
import '../bloc/alias_event.dart';
import '../bloc/alias_state.dart';

class AliasPageCreateMBNOForm extends StatelessWidget {
  //
  const AliasPageCreateMBNOForm({
    super.key,
    required this.aliasState,
  });
  final AliasState aliasState;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations localisation = AppLocalizations.of(context)!;
    // Récupération du bloc de sécurité
    final loginBloc = context.read<LoginBloc>();
    ConnectedUser user = loginBloc.getConnectedUser()!;

    //
    AliasCreateCommand aliasValue =
        (aliasState as AliasMBNOCreationState).values;

    // Valeur par défaut de l'indicatif
    if (aliasValue.phoneNumber == null ||
        aliasValue.phoneNumber?.indicatif == null) {
      aliasValue.phoneNumber = AliasCreateCommandPhoneNumber(
        indicatif: aliasValue.phoneNumber?.indicatif ??
            UEMOACountry.liste
                .firstWhere((c) => c.iso == user.country)
                .phoneCode,
        phone: aliasValue.phoneNumber?.phone,
      );
    }
    // Commencer la construction de la page
    return MyPageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de la page
              Text(
                localisation.addPhoneNumberPageTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              //
              const SizedBox(height: 8.0),
              // Sous titre de la page
              Text(
                localisation.addPhoneNumberPageSubTitle,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              //
              const SizedBox(height: 32),
              // Formulaire: champs et boutons

              // Select indicatif - Champ numéro de téléphone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // - champ indicatif
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: ShapeDecoration(
                      color: Theme.of(context).cardTheme.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        minWidth: 100,
                        child: DropdownButton<String>(
                          // Valeur par défaut pays de l'utilisateur selectionné
                          value: aliasValue.phoneNumber?.indicatif,
                          // Taille du texte
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(decorationThickness: 0),
                          // Ne pas afficher l'icone de dropdown
                          icon: const SizedBox.shrink(),
                          onChanged: (String? value) {
                            aliasValue.phoneNumber =
                                AliasCreateCommandPhoneNumber(
                              indicatif: value,
                              phone: aliasValue.phoneNumber?.phone,
                            );
                            context.read<AliasBloc>().add(
                                CreateAliasMBNOValidationEvent(aliasValue));
                          },
                          items: UEMOACountry.liste
                              .map<DropdownMenuItem<String>>(
                                  (UEMOACountry value) {
                            return DropdownMenuItem<String>(
                              value: value.phoneCode,
                              child: Text("${value.flag} ${value.phoneCode}"),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  //
                  const SizedBox(width: 8),

                  // - champ numéro de téléphone
                  Expanded(
                    child: CustomTextInput(
                      hintText: localisation.addPhoneNumberFormHint,
                      //inputFormatters:
                      // [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      // Message d'erreur à afficher
                      messageError: aliasValue.phoneNumber != null &&
                              aliasValue.phoneNumber!.error != null
                          ? getPhoneNumberErrorMessage(
                              aliasValue.phoneNumber!.error!,
                              localisation,
                            )
                          : null,
                      // Quand le texte change
                      onChange: (value) {
                        aliasValue.phoneNumber = AliasCreateCommandPhoneNumber(
                          indicatif: aliasValue.phoneNumber?.indicatif,
                          phone: value,
                        );
                        context
                            .read<AliasBloc>()
                            .add(CreateAliasMBNOValidationEvent(aliasValue));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Bouton continuer
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                if (aliasValue.isValid()) {
                  context
                      .read<AliasBloc>()
                      .add(AskPhoneNumberVerificationEvent(aliasValue, null));
                }
              },
              child: Text(localisation.loginFormBtnConnexion),
            ),
          )
        ],
      ),
    );
  }

  String? getPhoneNumberErrorMessage(
    AliasCreateCommandPhoneNumberError error,
    AppLocalizations traductions,
  ) {
    // Empty
    if (error == AliasCreateCommandPhoneNumberError.empty) {
      return traductions.addPhoneNumberFormErrorEmpty;
    }
    // Invalid
    else if (error == AliasCreateCommandPhoneNumberError.invalid) {
      return traductions.addPhoneNumberFormErrorInvalid;
    }
    return null;
  }
}
