import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../../contacts/presentation/pages/contact_list_item_actions_widget.dart';
import '../../../../contacts/presentation/pages/contact_list_widget.dart';
import '../../../domain/models/transaction_canal.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_alias.dart';
import '../../../domain/models/transaction_send/transaction_send_command_othr.dart';
import '../../../domain/models/transaction_send/transaction_send_method.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionSendPageContacts extends StatelessWidget {
  //
  const TransactionSendPageContacts({
    super.key,
    required this.action,
    this.hideTitle,
  });

  /// send_now, receive_now, send_schedule
  final String action;
  final bool? hideTitle;

  @override
  Widget build(BuildContext context) {
    //
    return ContactListWidget(
      hideTitle: hideTitle,
      onSelect: (contact, alias, isSelected) {
        // Pour récuperer l'alias
        final aliasBloc = context.read<AliasBloc>();
        final AliasExistState aliasState = aliasBloc.state as AliasExistState;
        final String compte = aliasState.alias.compte;

        // Passer le type de formulaire à afficher
        if (alias != null) {
          _displayForm(context, alias, null, compte);
        }
        // Le contact n'a pas d'alias
        else {
          // Show dialog select phone number to do
          // - an other transfer
          // - alias phone number transfer
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return ContactListItemActionsWidget(
                disableOther: action == TransactionSendCommand.actionReceiveNow,
                contact: contact,
                onClick: (useAsAlias, phoneNumber) {
                  if (useAsAlias) {
                    _displayForm(context, phoneNumber, null, compte);
                  } else {
                    _displayForm(context, null, phoneNumber, compte);
                  }
                },
              );
            },
            isScrollControlled: true,
          );
        }
      },
    );
  }

  /// Action effectuée quand on clique sur un option de transaction
  void _displayForm(
    BuildContext context,
    String? alias,
    String? phone,
    String compte,
  ) {
    context
        .read<TransactionSendBloc>()
        .add(TransactionSendDisplayFormEvent(TransactionSendCommand(
          action: action,
          method: alias != null
              ? TransactionSendMethod.alias
              : TransactionSendMethod.othr,
          compte: compte,
          canal: action == TransactionSendCommand.actionReceiveNow
              ? TransactionCanal.transfertParRequestToPay.code
              : TransactionCanal.defaultCanal.code,
          alias:
              alias != null ? TransactionSendCommandAlias(value: alias) : null,
          othr: phone != null ? TransactionSendCommandOthr(value: phone) : null,
        )));

    // Naviguer sur le formulaire de transaction
    AppRouter.push(context, AppRouter.transactionFormPage);
  }
}
