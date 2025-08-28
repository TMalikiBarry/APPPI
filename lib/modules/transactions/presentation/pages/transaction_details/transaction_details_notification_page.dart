import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';

import '../../../../../core/di.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/uemoa_countries.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification.dart' as my_notif;

class TransactionDetailsNotificationPage extends StatelessWidget {
  ///
  const TransactionDetailsNotificationPage({super.key, required this.notification});

  final my_notif.Notification notification;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

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
                  // Header: title and phone number
                  _header(context, traductions, notification),
                  const SizedBox(height: 20),

                  // Infos sur le transfert
                  _detailsTransfert(context, traductions, notification),

                  //const SizedBox(height: 10),

                  // Infos sur la Demande d'annulation
                  //_detailsDemande(context, traductions, tx),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    //

  }

  Widget _header(
    BuildContext context,
    AppLocalizations traductions,
    my_notif.Notification notification,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la page
          Text(
            notification.title ?? "",
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          // Sous titre Transfert reçu montant
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              notification.details != null ? notification.details!['endToEndId'] : notification.details?['guID'] ?? "",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Reference du transfert
          /*Text(
            notification.details != null ? notification.details!['endToEndId'] : notification.details?['guID'] ?? "",
            style: Theme.of(context).textTheme.displaySmall,
          ),*/
        ],
      ),
    );
  }

  /// Details sur le transfert
  Widget _detailsTransfert(
    BuildContext context,
    AppLocalizations traductions,
      my_notif.Notification notification,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            // Recu de
            if (notification.details != null && notification.details?['date'] != null) ... [
              _detail(
                context,
                title: traductions.transactionDetailsDateLabel,
                subtitle: DateFormat('d MMM, HH:mm').parse(notification.details?['date']).timeZoneName,
              ),
            ],
            const SizedBox(height: 10),

            // Recu de
            if (notification.details != null && notification.details?['clientName'] != null) ... [
              _detail(
                context,
                title: traductions.transactionDetailsPayeurLabel,
                subtitle: notification.details?['clientName'] ?? "",
              ),
            ],
            const SizedBox(height: 10),

            // Body
            SizedBox(
              width: double.infinity, // occupe toute la largeur
              child: Text(
                notification.body ?? "",
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Themer.neural03Color),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


  /// Affiche un detail
  Widget _detail(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
        Expanded(
          child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Themer.neural03Color),
          ),
        ),
      ],
    );
  }

  /// Statut de la transaction
  String _statut(TransactionStatut statut, AppLocalizations traductions) {
    if (statut == TransactionStatut.irrevocable) {
      return traductions.statutAccepte;
    } else if (statut == TransactionStatut.rejete) {
      return traductions.statutRejete;
    } else {
      return traductions.statutInitie;
    }
  }
}
