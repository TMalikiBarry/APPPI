import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/modules/contacts/presentation/bloc/contact_bloc.dart';
import 'package:pi_mobile_app/modules/contacts/presentation/bloc/contact_state.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/notification_dialog.dart'  as notif_dialog;
import '../../../../contacts/presentation/bloc/contact_event.dart';
import '../../../../security/presentation/bloc/identification/identification_bloc.dart';
import '../../../../security/presentation/bloc/identification/identification_event.dart';
import '../../../../security/presentation/bloc/identification/identification_state.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_send/transaction_send_method.dart';
import '../../bloc/transaction_rtp/transaction_rtp_bloc.dart';
import '../../bloc/transaction_rtp/transaction_rtp_event.dart';
import 'transaction_rtp_page_actions_reject.dart';

class TransactionRtpPageActions extends StatelessWidget {
  ///
  const TransactionRtpPageActions({
    super.key,
    required this.tx,
    required this.bloc,
  });

  final Transaction tx;
  final TransactionRtpBloc bloc;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Programmer Possible si c'est 631, 401, 520
          /*if (tx.canSchedule()) ...[
            FloatingActionButton(
              onPressed: () {
                //transactionSendBloc.add(TransactionSendScheduleEvent(command));
              },
              elevation: 0,
              heroTag: "schedule",
              child: const Icon(Icons.calendar_month_outlined, size: 24),
            ),
            const SizedBox(width: 16),
          ],*/

          // Rejeter
          Expanded(
            child: FilledButton.tonal(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => BlocProvider<TransactionRtpBloc>.value(
                    value: bloc,
                    child: const TransactionRtpPageActionsReject(),
                  ),
                  isScrollControlled: true,
                );
              },
              child: Text(traductions.btnTextReject),
            ),
          ),
          //
          const SizedBox(width: 16),
          // Confirmer
          if (tx.canal == "631") ... [
            Expanded(
              child: BlocListener<ContactBloc, ContactState>(
                listenWhen: (previous, current) => previous.contacts != current.contacts,
                listener: (context, state) {
                  if (state.contacts!.isNotEmpty) {
                    bloc.add(TransactionRtpAcceptPayEvent(tx, TransactionSendMethod.rtpAcceptPay));
                  } else {
                    _showContactNotFoundDialog(context, traductions);
                  }
                },
                child: Builder(builder: (context) {
                  final state = context.watch<ContactBloc>().state;
                  return ElevatedButton(
                    onPressed: () async {
                      final contactBloc = context.read<ContactBloc>();

                      // Charger les contacts si nécessaire
                      if (contactBloc.state.contactsAll?.isEmpty ?? true) {
                        contactBloc.add(const ContactListEvent(null));
                        // Attendre que les contacts soient chargés
                        await Future.delayed(const Duration(milliseconds: 500));
                      }

                      // Puis effectuer la recherche
                      final aliasNormalise = normalizeAlias(tx.clientAlias!);
                      contactBloc.add(ContactSearchEvent(aliasNormalise));
                    },
                    child: Text(traductions.btnTextPay),
                  );
                }),
              ),
            ),
          ] else ... [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  bloc.add(TransactionRtpAcceptPayEvent(tx, TransactionSendMethod.rtpAcceptPay));
                },
                child: Text(traductions.btnTextPay),
              ),
            ),
          ]
        ],
      ),
    );
  }

  /// Show error dialog when contact is not found
  void _showContactNotFoundDialog(
      BuildContext context,
      AppLocalizations traductions,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return notif_dialog.NotificationDialog(
          type: notif_dialog.NotificationType.error,
          message: traductions.userNotExistInContactsList,
          btnText: traductions.btnTextContinue,
          btnAction: () => AppRouter.pop(context),
          btnColor: Theme
              .of(context)
              .colorScheme
              .tertiary,
        );
      },
    );
  }
}

// "  +221 77 123 45 67  " =>  "771234567"
// "00221761234567" =>   "761234567"
// "+2250123456789" =>  "0123456789"
// "550e8400-e29b-41d4-a716-446655440000")); // UUID conservé
String normalizeAlias(String input) {
  final raw = input.trim();

  // UUID (SHID) → on garde tel quel
  final patternSHID = RegExp(
    r'^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$',
  );
  if (patternSHID.hasMatch(raw)) {
    return raw;
  }

  // Supprimer espaces et caractères non numériques sauf '+'
  final normalized = raw.replaceAll(RegExp(r'\s+'), '');

  // Sénégal (local ou international)
  final regexSn = RegExp(r'^(\+221)?(77|76|70|78|75|71)\d{7}$');
  if (regexSn.hasMatch(normalized)) {
    return normalized.replaceFirst(RegExp(r'^\+221'), '');
  }

  // Autres pays
  final regexOthers = RegExp(
    r'^(?:\+225\d{10}|\+223\d{8}|\+226\d{8}|\+229\d{8}|\+228\d{8}|\+227\d{8}|\+245\d{6})$',
  );
  if (regexOthers.hasMatch(normalized)) {
    // Retirer l'indicatif (+XYZ)
    return normalized.replaceFirst(RegExp(r'^\+\d+'), '');
  }

  // Sinon → on retourne juste les digits
  return normalized.replaceAll(RegExp(r'\D'), '');
}
