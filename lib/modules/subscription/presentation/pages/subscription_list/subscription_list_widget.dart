import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../alias/domain/models/alias.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../domain/models/subscription.dart';
import '../../bloc/subscription_list/subscription_list_bloc.dart';
import '../../bloc/subscription_list/subscription_list_event.dart';
import '../../bloc/subscription_list/subscription_list_state.dart';
import 'subscription_list_empty_widget.dart';
import 'subscription_list_item_widget.dart';
import 'subscription_list_loading_widget.dart';

class SubscriptionListWidget extends StatefulWidget {
  ///
  const SubscriptionListWidget({super.key});

  ///
  @override
  State<SubscriptionListWidget> createState() => _SubscriptionListWidgetState();
}

class _SubscriptionListWidgetState extends State<SubscriptionListWidget> {
  ///
  late SubscriptionListBloc transactionsBloc;

  @override
  void initState() {
    super.initState();
    // Recents transactions bloc
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    transactionsBloc = SubscriptionListBloc(Di.getSubscriptionInputPort())
      ..add(SubscriptionListFetchEvent(alias.compte));
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocProvider<SubscriptionListBloc>(
      create: (_) => transactionsBloc,
      child: BlocBuilder<SubscriptionListBloc, SubscriptionListState>(
        bloc: transactionsBloc,
        buildWhen: (previous, current) =>
            current is SubscriptionListLoadingState ||
            current is SubscriptionListDisplayState,
        builder: (context, state) {
          // Skeleton
          if (state is SubscriptionListLoadingState) {
            return const SubscriptionListLoadingWidget();
          }
          // Liste ou présentation
          else {
            List<Subscription> transactions = state.subscriptions;
            // Liste vide => affiche la présentation de la fonctionnalité
            if (transactions.isEmpty) {
              return SubscriptionListEmptyWidget();
            }
            // Liste par type: sans frequence et avec fréquence
            else {
              List<Subscription> withFrequence =
                  transactions.where((t) => t.frequence != null).toList();
              // TODO sort prochain nextPaymentDate plus recent
              List<Subscription> withoutFrequence =
                  transactions.where((t) => t.frequence == null).toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Paiements programmés
                    if (withoutFrequence.isNotEmpty) ...[
                      _section(
                        context,
                        traductions.subscriptionListOnceTitle,
                        withoutFrequence,
                        () => AppRouter.push(
                          context,
                          AppRouter.subscriptionSchedule,
                        ),
                      ),
                    ],
                    // Abonnements
                    if (withFrequence.isNotEmpty) ...[
                      _section(
                        context,
                        traductions.subscriptionListFrequenceTitle,
                        withFrequence,
                        () => AppRouter.push(
                          context,
                          AppRouter.subscriptionSubscribe,
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    List<Subscription> liste,
    Function() createFn,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Type de subscription
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Themer.neural05Color),
              ),
              // add btn
              IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.add),
                  onPressed: () => createFn()),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Liste des transactions
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: liste.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => SubscriptionListItemWidget(
                subscription: liste[index],
                detailsBackRoute: AppRouter.home,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
