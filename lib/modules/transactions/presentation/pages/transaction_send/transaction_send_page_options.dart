import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/menu_actions_widget.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../domain/models/transaction_canal.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_alias.dart';
import '../../../domain/models/transaction_send/transaction_send_method.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionSendPageOptions extends StatelessWidget {
  ///
  const TransactionSendPageOptions({super.key, required this.action});

  /// send_now, receive_now, send_schedule
  final String action;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return Column(
      children: [
        // 3 premieres options: alias , iban, other
        MenuActionsWiget(
          items: [
            // Send by alias
            MenuActionItem(
              Images.iconTransactionSendByAlias,
              traductions.transactionsSendOptionAliasTitle,
              traductions.transactionsSendOptionAliasSubtitle,
              () {
                if (action == "receive_now") {
                  _displayForm(context, TransactionSendMethod.aliasRtb);
                } else {
                _displayForm(context, TransactionSendMethod.alias);
                }
              },
              iconSize: 20,
            ),
            // Pour un RTP, les options IBAN et OTHR sont désactivées
            if (action != TransactionSendCommand.actionReceiveNow)
              // Send by IBAN
              MenuActionItem(
                Images.iconTransactionSendByIban,
                traductions.transactionsSendOptionIbanTitle,
                traductions.transactionsSendOptionIbanSubtitle,
                () => _displayForm(context, TransactionSendMethod.iban),
                iconSize: 20,
              ),
            if (action != TransactionSendCommand.actionReceiveNow)
              // Send by  Other
              MenuActionItem(
                Images.iconTransactionSendByOthr,
                traductions.transactionsSendOptionOthrTitle,
                traductions.transactionsSendOptionOthrSubtitle,
                () => _displayForm(context, TransactionSendMethod.othr),
                iconSize: 20,
              ),
          ],
        ),

        // Séparateur
        const SizedBox(height: 20),

        // Nouveau contact
        /*
        MenuActionsWiget(
          items: [
            MenuActionItem(
              Images.iconTransactionSendByNewContact,
              traductions.transactionsSendOptionNewContactTitle,
              traductions.transactionsSendOptionNewContactSubtitle,
              () => AppRouter.push(
                context,
                AppRouter.contactCreate,
                params: {
                  "afterCreate": (contact) {
                    TransactionSendBloc sendBloc =
                        context.read<TransactionSendBloc>();
                    // Pour récuperer l'alias
                    final aliasBloc = context.read<AliasBloc>();
                    final AliasExistState aliasState =
                        aliasBloc.state as AliasExistState;
                    // Passer le type de formulaire à afficher
                    sendBloc.add(
                        TransactionSendDisplayFormEvent(TransactionSendCommand(
                      action: action,
                      method: TransactionSendMethod.alias,
                      compte: aliasState.alias.compte,
                      canal: action == TransactionSendCommand.actionReceiveNow
                          ? TransactionCanal.transfertParRequestToPay.code
                          : TransactionCanal.defaultCanal.code,
                      alias: TransactionSendCommandAlias(value: contact.alias),
                    )));
                    return {"route": AppRouter.transactionFormPage};
                  },
                },
              ),
            ),
          ],
        ),
         */
      ],
    );
  }

  /// Action effectuée quand on clique sur un option de transaction
  void _displayForm(
    BuildContext context,
    TransactionSendMethod method, [
    String? alias,
  ]) {
    // Recuperer le bloc de gestion des transactions
    TransactionSendBloc sendBloc = context.read<TransactionSendBloc>();
    //     // Pour récuperer l'alias
    final aliasBloc = context.read<AliasBloc>();
    final AliasExistState aliasState = aliasBloc.state as AliasExistState;
    // Passer le type de formulaire à afficher
    sendBloc.add(TransactionSendDisplayFormEvent(TransactionSendCommand(
      action: action,
      method: method,
      compte: aliasState.alias.compte,
      canal: action == TransactionSendCommand.actionReceiveNow
          ? TransactionCanal.transfertParRequestToPay.code
          : TransactionCanal.defaultCanal.code,
      alias: alias != null ? TransactionSendCommandAlias(value: alias) : null,
    )));
    // Naviguer sur le formulaire de transaction
    AppRouter.push(context, AppRouter.transactionFormPage);
  }
}
