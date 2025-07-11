import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../alias/domain/models/alias.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import '../../bloc/transaction_send/transaction_send_state.dart';
import 'transaction_send_page_contacts.dart';
import 'transaction_send_page_input.dart';
import 'transaction_send_page_options.dart';
import 'transaction_send_page_recents.dart';

class TransactionSendPage extends StatefulWidget {
  ///
  const TransactionSendPage({super.key, required this.action, this.canal});
  // send_now, receive_now, send_schedule
  final String action;
  // Canal de communication
  final String? canal;
  @override
  State<TransactionSendPage> createState() => _TransactionSendPageState();
}

class _TransactionSendPageState extends State<TransactionSendPage> {
  late TransactionSendBloc transactionSendBloc;

  @override
  void initState() {
    super.initState();
    // Compte numéro
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    // Bloc send transaction
    transactionSendBloc = context.read<TransactionSendBloc>();
    transactionSendBloc.add(TransactionSendListRecentsEvent(alias.compte));
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocBuilder<TransactionSendBloc, TransactionSendState>(
      bloc: transactionSendBloc,
      buildWhen: (previous, current) =>
          current is TransactionSendInitialState ||
          current is TransactionSendSearchState,
      builder: (context, state) {
        return MyPageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    onPressed: () {
                      AppRouter.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListView(
                    children: [
                      // Title when scheduling transfer
                      if (widget.action ==
                          TransactionSendCommand.actionSendSchedule) ...[
                        Text(
                          traductions.transactionsSendScheduleTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Input de recherche d'un contact et btn qrcode
                      TransactionSendPageInput(
                        action: widget.action,
                      ),

                      if (state is TransactionSendInitialState) ...[
                        // Boutons d'actions pour faire la transaction
                        const SizedBox(height: 24),
                        Text(
                          widget.action !=
                                  TransactionSendCommand.actionReceiveNow
                              ? traductions.transactionsSendTitleTransfert
                              : traductions.transactionsSendTitleRequest2Pay,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall! //
                              .copyWith(color: Themer.neural05Color),
                        ),
                        const SizedBox(height: 17),
                        TransactionSendPageOptions(action: widget.action),
                        // Transferts recents
                        const SizedBox(height: 32),
                        TransactionSendPageRecents(
                          transactions: state.transactions,
                          action: widget.action,
                        ),
                      ],

                      // Contacts
                      const SizedBox(height: 32),
                      TransactionSendPageContacts(
                          action: widget.action,
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
