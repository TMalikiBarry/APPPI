import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../shared/widgets/menu_actions_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/notification_dialog.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/contact_event.dart';

class ContactListItemActionsWidget extends StatelessWidget {
  const ContactListItemActionsWidget({
    super.key,
    required this.contact,
    required this.onClick,
    this.disableOther = false,
  });
  final Contact contact;
  final bool? disableOther;
  final Function(bool useAsAlias, String phoneNumber) onClick;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    final screenHeight = MediaQuery.of(context).size.height;

    if (contact.phones.isEmpty) {
      return NotificationDialog(
        type: NotificationType.error,
        title: traductions.serverErrorTitle,
        description: traductions.contactWithNoPhoneNumber,
        btnColor: Theme.of(context).colorScheme.tertiary,
        btnText: traductions.btnTextContinue,
        btnAction: () => {AppRouter.pop(context)},
      );
    }
    // On peut plus tard lui proposer de choisir un s'il y'en a plusieurs
    String phoneNumber = contact.phones[0].normalizedNumber;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.4, // Set max height as 40% of screen height
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  traductions.contactActionsTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                //
                const SizedBox(height: 20),
                //
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MenuActionsWiget(
                        items: [
                          // Utiliser comme alias de compte
                          MenuActionItem(
                            Images.aliasIcon,
                            traductions.aliasFormLabel,
                            traductions.contactPhoneAsAccountAlias(
                              phoneNumber,
                            ),
                            () {
                              // Save in contact as alias
                              context
                                  .read<ContactBloc>()
                                  .add(ContactUpdateEvent(
                                    contact,
                                    phoneNumber,
                                  ));
                              // Continue
                              onClick(true, phoneNumber);
                            },
                            iconSize: 20,
                          ),
                          // Utiliser comme numéro de compte
                          if (disableOther == false)
                            MenuActionItem(
                              Images.iconTransactionSendByOthr,
                              traductions.transactionFormOthrLabel,
                              traductions.contactPhoneAsAccountNumber(
                                phoneNumber,
                              ),
                              () => onClick(false, phoneNumber),
                              iconSize: 20,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
