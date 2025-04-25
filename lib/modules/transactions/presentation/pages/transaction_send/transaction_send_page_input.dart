import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../contacts/presentation/bloc/contact_bloc.dart';
import '../../../../contacts/presentation/bloc/contact_event.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionSendPageInput extends StatelessWidget {
  ///
  const TransactionSendPageInput({super.key,this.action});
  final String? action; // send_now, send_receive, send_schedule
  static final logger = Logger();

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    final contactBloc = context.read<ContactBloc>();
    final transactionSendBloc = context.read<TransactionSendBloc>();

    return Card(
      child: SizedBox(
        height: 36,
        child: TextField(
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.displayLarge,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Themer.neural03Color),
            suffixIcon: IconButton(
              icon: const ImageIcon(
                AssetImage(Images.homeFooterQrcode),
                color: Themer.neural03Color,
                size: 18,
              ),
              onPressed: () => AppRouter.pushReplacement(
                context, 
                AppRouter.qrcodeScan,
                params: action
              ),
            ),
            filled: true,
            border: InputBorder.none,
            hintText: traductions.transactionsSendInputHint,
            hintStyle: Theme.of(context)
                .textTheme
                .displayMedium! //
                .copyWith(color: Themer.neural03Color),
          ),
          onChanged: (value) {
            contactBloc.add(ContactSearchEvent(value));
            // Pour modifier l'affichage quand on recherche un contact
            transactionSendBloc.add(TransactionSendSearchContactsEvent(value));
          },
          onSubmitted: (value) {
            logger.i('search $value');
          },
        ),
      ),
    );
  }
}
