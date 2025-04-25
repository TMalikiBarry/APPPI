import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/alias_pi.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../contacts/domain/contact_pi.dart';
import '../../../domain/models/transaction.dart';
import '../transaction_list_item_widget.dart';
import 'transaction_split_page_confirm.dart';

class TransactionSplitPageRepartition extends StatefulWidget {
  //
  const TransactionSplitPageRepartition({
    super.key,
    required this.transaction,
    required this.contacts,
  });

  final Transaction transaction;
  final List<Contact> contacts;
  @override
  State<TransactionSplitPageRepartition> createState() =>
      _TransactionSplitPageState();
}

class _TransactionSplitPageState
    extends State<TransactionSplitPageRepartition> {
  late List<ContactPI>? selectedItems;
  late Map<String, TextEditingController> repartition;

  String self = "SELF";

  @override
  void initState() {
    super.initState();
    selectedItems = widget.contacts
        .map(
          (e) => ContactPI(
            name: e.displayName,
            phoneNumber: (e.phones.isNotEmpty ? e.phones[0].number : ''),
            alias: _getAliasValue(e) ?? e.phones[0].normalizedNumber,
          ),
        )
        .toList();

    selectedItems!.insert(
        0,
        ContactPI(
          name: self,
          phoneNumber: "",
          alias: self,
        ));

    // Determiner la répartition par défaut
    repartition = {};
    double amount = widget.transaction.montant;
    int nombre = selectedItems!.length;
    double part = amount / nombre;
    part = part.toInt().toDouble();
    double reste = amount - part * nombre;
    for (var contact in selectedItems!) {
      repartition[contact.alias!] = TextEditingController(
        text: part.toStringAsFixed(0),
      );
    }
    repartition[self] = TextEditingController(
      text: (part + reste).toStringAsFixed(0),
    );
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
              traductions.transactionSplitRepartitionTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Details du Paiement partagé
                    Text(
                      traductions.transactionSplitRepartitionSubtitle1,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TransactionListItemWidget(
                          transaction: widget.transaction,
                        ),
                      ),
                    ),

                    // Répartir entre
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        // Répartir entre
                        Expanded(
                          child: Text(
                            traductions.transactionSplitRepartitionSubtitle2(
                              selectedItems!.length,
                            ),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        // Par montant
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                traductions
                                    .transactionSplitRepartitionParMontant,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Themer.primaryDark),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Themer.primaryDark,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            ...selectedItems!.map(
                              (c) => _contactItem(
                                context,
                                traductions,
                                c,
                                false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bouron Envoyer
            TransactionSplitPageConfirm(
              transaction: widget.transaction,
              selectedItems: selectedItems,
              repartition: repartition,
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche un contact de la liste
  Widget _contactItem(
    BuildContext context,
    AppLocalizations traductions,
    ContactPI contact,
    bool onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      // Avatar
      leading: Stack(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(Images.transactionAvatar),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: ShapeDecoration(
                color: contact.name == self ? Colors.white : Themer.brownColor,
                shape: CircleBorder(
                  side: BorderSide(width: 2, color: Colors.white),
                ),
              ),
              child: contact.name == self
                  ? Icon(Icons.check_circle, size: 18, color: Colors.green)
                  : Image.asset(Images.iconsPiBadge),
            ),
          ),
        ],
      ),
      // Contact name
      title: Text(
        contact.name == self
            ? traductions.transactionSplitRepartitionSelf
            : contact.name,
        style: Theme.of(context).textTheme.headlineSmall,
        overflow: TextOverflow.ellipsis,
      ),
      // Part réglée, Vous doit
      subtitle: Text(
        contact.name == self
            ? traductions.transactionSplitRepartitionPartRegle
            : traductions.transactionSplitRepartitionPartDoit,
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(color: Themer.neural04Color),
      ),
      trailing: SizedBox(
        height: 40,
        width: 90,
        child: IgnorePointer(
          // Solution clé : Permet au TextField de recevoir les gestures
          ignoring: false,
          child: TextField(
              controller: repartition[contact.alias!],
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: [
                // Empêche les valeurs négatives et limite les décimales
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                // Style minimal avec seulement un border bottom
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 1.0, // Épaisseur du trait
                  ),
                ),
                // Style quand le champ est sélectionné
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                // Supprime le label et le padding inutile
                isDense: true,
                contentPadding:
                    EdgeInsets.only(bottom: 8), // Alignement vertical
              ),
              onChanged: (value) {
                setState(() {});
              }),
        ),
      ),
    );
  }

  /// Récupère la valeur de l'alias
  String? _getAliasValue(Contact contact) {
    try {
      var aliasRecord = contact.phones
          .where((phone) =>
              phone.label == PhoneLabel.custom &&
              phone.customLabel == AliasPI.label)
          .first;
      return aliasRecord.number;
    } catch (e) {
      // No item found
      return null;
    }
  }
}
