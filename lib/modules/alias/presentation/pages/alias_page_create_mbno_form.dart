import 'package:common_dependencies/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/uemoa_countries.dart';
import '../../../../shared/widgets/input_text.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../../security/domain/models/connected_user.dart';
import '../../../security/presentation/bloc/login/login_bloc.dart';
import '../../domain/models/alias_create_command.dart';
import '../../domain/models/alias_type.dart';
import '../bloc/alias_bloc.dart';
import '../bloc/alias_event.dart';
import '../bloc/alias_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AliasPageCreateMBNOForm extends StatefulWidget {
  final AliasState aliasState;

  const AliasPageCreateMBNOForm({super.key, required this.aliasState});

  @override
  State<AliasPageCreateMBNOForm> createState() => _AliasPageCreateMBNOFormState();
}

class _AliasPageCreateMBNOFormState extends State<AliasPageCreateMBNOForm> {
  final TextEditingController phoneController = TextEditingController();
  late String selectedIndicatif;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    final loginBloc = context.read<LoginBloc>();
    ConnectedUser user = loginBloc.getConnectedUser()!;

    // Indicatif par défaut
    String defaultIndicatif = UEMOACountry.liste
        .firstWhere((c) => c.iso == user.country)
        .phoneCode;

    final pref = await SharedPreferences.getInstance();
    String? telephone = pref.getString("phone_number");

    if (telephone != null && telephone.length > 4) {
      // Extraire l'indicatif et le numéro depuis SharedPreferences
      String savedIndicatif = telephone.substring(0, 4);
      String savedPhone = telephone.substring(4);

      // Vérifier si l'indicatif sauvegardé est valide
      bool isValidIndicatif = UEMOACountry.liste
          .any((c) => c.phoneCode == savedIndicatif);

      selectedIndicatif = isValidIndicatif ? savedIndicatif : defaultIndicatif;
      phoneController.text = savedPhone;
    } else {
      selectedIndicatif = defaultIndicatif;
    }

    // Mettre à jour l'état du bloc avec les valeurs initiales
    AliasCreateCommand aliasValue = (widget.aliasState as AliasMBNOCreationState).values;
    aliasValue.phoneNumber = AliasCreateCommandPhoneNumber(
      indicatif: selectedIndicatif,
      phone: phoneController.text,
    );

    context.read<AliasBloc>().add(CreateAliasMBNOValidationEvent(aliasValue));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: LoadingAnimationWidget.flickr(
        leftDotColor: primaryColor,
        rightDotColor: secondaryColor,
        size: 25,
      ));
    }

    AppLocalizations localisation = AppLocalizations.of(context)!;
    AliasCreateCommand aliasValue = (widget.aliasState as AliasMBNOCreationState).values;

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
              const SizedBox(height: 8.0),
              // Sous titre de la page
              Text(
                localisation.addPhoneNumberPageSubTitle,
                style: Theme.of(context).textTheme.displaySmall,
              ),
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
                          value: selectedIndicatif,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            decorationThickness: 0,
                          ),
                          icon: const SizedBox.shrink(),
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                selectedIndicatif = value;
                              });

                              aliasValue.phoneNumber = AliasCreateCommandPhoneNumber(
                                indicatif: value,
                                phone: phoneController.text,
                              );
                              context.read<AliasBloc>().add(
                                CreateAliasMBNOValidationEvent(aliasValue),
                              );
                            }
                          },
                          items: UEMOACountry.liste
                              .map<DropdownMenuItem<String>>((UEMOACountry value) {
                            return DropdownMenuItem<String>(
                              value: value.phoneCode,
                              child: Text("${value.flag} ${value.phoneCode}"),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // - champ numéro de téléphone
                  Expanded(
                    child: CustomTextInput(
                      controller: phoneController,
                      hintText: localisation.addPhoneNumberFormHint,
                      keyboardType: TextInputType.phone,
                      messageError: aliasValue.phoneNumber != null &&
                          aliasValue.phoneNumber!.error != null
                          ? getPhoneNumberErrorMessage(
                        aliasValue.phoneNumber!.error!,
                        localisation,
                      )
                          : null,
                      onChange: (value) {
                        aliasValue.phoneNumber = AliasCreateCommandPhoneNumber(
                          indicatif: selectedIndicatif,
                          phone: value,
                        );
                        context.read<AliasBloc>().add(
                          CreateAliasMBNOValidationEvent(aliasValue),
                        );
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
                  context.read<AliasBloc>().add(
                    AskPhoneNumberVerificationEvent(aliasValue, null),
                  );
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
    if (error == AliasCreateCommandPhoneNumberError.empty) {
      return traductions.addPhoneNumberFormErrorEmpty;
    } else if (error == AliasCreateCommandPhoneNumberError.invalid) {
      return traductions.addPhoneNumberFormErrorInvalid;
    }
    return null;
  }
}