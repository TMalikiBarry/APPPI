import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pi_mobile_app/core/router.dart';
import 'package:pi_mobile_app/shared/widgets/avatar_circle_widget.dart';

import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../contacts/presentation/bloc/contact_bloc.dart';
import '../../../../contacts/presentation/bloc/contact_event.dart';
import '../../../../contacts/presentation/pages/contact_list_item_actions_widget.dart';
import '../../../../contacts/presentation/pages/contact_list_widget.dart';
import '../../../domain/models/transaction.dart';

class TransactionSplitPage extends StatefulWidget {
  //
  const TransactionSplitPage({super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<TransactionSplitPage> createState() => _TransactionSplitPageState();
}

class _TransactionSplitPageState extends State<TransactionSplitPage> {
  late List<Contact>? selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = [];
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),

      // Body
      body: MyPageContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre de la page
            Text(
              traductions.transactionSplitTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),

            // Input de recherche d'un contact
            _contactSearchWidget(context, traductions),
            const SizedBox(height: 10),

            // Selected contacts
            if (selectedItems != null && selectedItems!.isNotEmpty) ...[
              _selectedContactsWidget(context, traductions),
              const SizedBox(height: 10),
            ],

            // Contacts
            Expanded(
              child: SingleChildScrollView(child: _contactsListWidget(context)),
            ),

            // Bouton continuer et créer un groupe
          ],
        ),
      ),


      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed:  (selectedItems != null && selectedItems!.isNotEmpty)
            ? () async {
              AppRouter.push(
                context,
                AppRouter.transactionSplitPaymentRepartition,
                params: {
                  "tx": widget.transaction,
                  "contacts": selectedItems!,
                },
              );
            } : null,
          child: Text(traductions.btnTextContinue),
        ),
      ),
    );
  }

  /// Affiche le input de recherche de contact
  Widget _contactSearchWidget(
    BuildContext context,
    AppLocalizations traductions,
  ) {
    return Card(
      child: SizedBox(
        height: 36,
        child: TextField(
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.displayLarge,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Themer.neural03Color),
            filled: true,
            border: InputBorder.none,
            hintText: traductions.transactionsSendInputHint,
            hintStyle: Theme.of(context)
                .textTheme
                .displayMedium! //
                .copyWith(color: Themer.neural03Color),
          ),
          onChanged: (value) {
            context.read<ContactBloc>().add(ContactSearchEvent(value));
          },
        ),
      ),
    );
  }

  /// Affiche la liste des contacts
  Widget _contactsListWidget(BuildContext context) {
    return ContactListWidget(
      hideTitle: true,
      selectedItems: selectedItems,
      onSelect: (contact, alias, isSelected) {
        if (isSelected != null && !isSelected) {
          setState(() {
            selectedItems!.remove(contact);
          });
        } else {
          // Passer le type de formulaire à afficher
          if (alias != null) {
            setState(() {
              selectedItems!.add(contact);
            });
          }
          // Le contact n'a pas d'alias
          else {
            // Show dialog select phone number to do
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return ContactListItemActionsWidget(
                  disableOther: true,
                  contact: contact,
                  onClick: (useAsAlias, phoneNumber) {
                    if (useAsAlias) {
                      setState(() {
                        selectedItems!.add(contact);
                        AppRouter.pop(context);
                      });
                    }
                  },
                );
              },
              isScrollControlled: true,
            );
          }
        }
      },
    );
  }

  // Contacts selectionnés
  Widget _selectedContactsWidget(
    BuildContext context,
    AppLocalizations traductions,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.12,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 1,
            children: selectedItems!
                .map<Widget>(
                  (contact) => Column(
                    children: [
                      Stack(
                        children: [
                          AvatarCircleWidget(
                            nom: contact.displayName,
                            rounded: true,
                            radius: 20,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                selectedItems!.remove(contact);
                              }),
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: ShapeDecoration(
                                  color: Themer.systemErrorColor,
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      width: 2,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        contact.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
