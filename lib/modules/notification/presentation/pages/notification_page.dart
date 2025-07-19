import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../alias/domain/models/alias.dart';
import '../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../alias/presentation/bloc/alias_state.dart';
import '../../domain/models/notification_search_command.dart';
import '../../domain/models/notification_search_filter.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import 'notification_page_liste.dart';

class NotificationPage extends StatelessWidget {
  ///
  const NotificationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    context.read<NotificationBloc>()
    .add(NotificationListEvent(
      NotificationSearchCommand(
        compte: alias.compte,
        filters: NotificationSearchFilter(),
      ),
    ));

    return MyPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Page bar
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButton(
                onPressed: () => AppRouter.push(context, AppRouter.home),
              ),
            ],
          ),
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 15),
            child: Text(
              traductions.notificationPageTitle,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 26
              ),
            ),
          ),
          // // barre de filtre: dates
          // const NotificationSearchPageInput(),
          const SizedBox(
            height: 10,
          ),
          // Page body
          const NotificationPageListe(),
        ],
      ),
    );
  }
}
