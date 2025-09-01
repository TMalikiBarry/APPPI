import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../core/router.dart';
import '../../../../../shared/models/alias_pi.dart';
import '../../../../../shared/widgets/input_alias_widget.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../domain/contact_pi.dart';
import '../../bloc/create/contact_create_bloc.dart';
import '../../bloc/create/contact_create_event.dart';
import '../../bloc/create/contact_create_state.dart';

class ContactCreatePage extends StatefulWidget {
  ///
  const ContactCreatePage({super.key, required this.afterCreate});

  final Function(ContactPI contact) afterCreate;

  @override
  State<ContactCreatePage> createState() => _ContactCreatePageState();
}

class _ContactCreatePageState extends State<ContactCreatePage> {
  late ContactPI contact;
  late AliasPI aliasCommand;

  @override
  void initState() {
    super.initState();
    contact = ContactPI(name: "", phoneNumber: "");
    aliasCommand = AliasPI(value: null);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    ContactCreateBloc contactBloc = ContactCreateBloc();

    return BlocProvider<ContactCreateBloc>(
      create: (_) => contactBloc,
      child: BlocConsumer<ContactCreateBloc, ContactCreateState>(
        bloc: contactBloc,
        listener: (context, state) {
          if (state is ContactCreateSuccessState) {
            CustomLoadingDialog.hide(context);
            var redirect = widget.afterCreate(contact);
            AppRouter.go(context, redirect["route"]);
          }
          // Show error
          else {}
        },
        builder: (context, state) {
          if (state is ContactCreateLoadingState) {
            return const Scaffold(
              body: LoadingPage(),
            );
          } else {
            return Scaffold(
              // Pour avoir le bouton de retour
              appBar: AppBar(),
              // Contenu de la page
              body: MyPageContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Titre de la page
                          Text(
                            traductions.contactCreateTitle,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),

                          //
                          const SizedBox(height: 5.0),

                          // Sous titre de la page
                          Text(
                            traductions.contactCreateSubtitle,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),

                          //
                          const SizedBox(height: 32),

                          // Champ Nom du contact
                          CustomTextInput(
                            labelText: traductions.contactCreateNameLabel,
                            // Message d'erreur à afficher
                            messageError: contact.name.isEmpty
                                ? traductions.contactCreateNameErrorEmpty
                                : "",
                            // Quand le texte change
                            onChange: (value) {
                              setState(() {
                                contact.name = value;
                              });
                            },
                          ),

                          // Espacement de 16 pixels
                          const SizedBox(height: 16),

                          // Champ Alias
                          InputAliasWidget(
                            command: aliasCommand,
                            onChange: (value) {
                              setState(() {
                                contact.alias = value;
                              });
                            },
                          ),
                        ],
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed:
                            contact.name.isNotEmpty && aliasCommand.isValid()
                                ? () {
                                    // creer
                                    //CustomLoadingDialog.show(context);
                                    contactBloc
                                        .add(ContactCreateSubmitEvent(contact));
                                  }
                                : null,
                        child: Text(traductions.contactBtnSave),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
