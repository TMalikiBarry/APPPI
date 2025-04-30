import 'package:flutter/material.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/cta_widget.dart';
import '../../../compte/presentation/pages/solde_widget.dart';
import '../../../transactions/presentation/pages/transaction_recents/transaction_recents_widget.dart';
import 'home_tab_compte_more_menu.dart';

class HomeTabCompte extends StatefulWidget {
  const HomeTabCompte({super.key});

  @override
  State<HomeTabCompte> createState() => _HomeTabCompteState();
}

class _HomeTabCompteState extends State<HomeTabCompte> {
  // Clé unique pour forcer le rebuilt des enfants
  UniqueKey _refreshKey = UniqueKey();

  Future<void> _handleRefresh() async {
    setState(() {
      _refreshKey = UniqueKey(); // Nouvelle clé => rebuilt forcé
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color(0xFF282C5D),
      onRefresh: _handleRefresh,
      child: ListView(
        key: _refreshKey,
        children: [
          // Home Page Fixed Design
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Affiche le widget solde
                    const SoldeWidget(),
                    // Séparateur
                    const SizedBox(height: 20),
                    // Principales actions: Envoyer, Recevoir, Plus
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Envoyer
                          CtaWidget(
                            image: Images.arrowUp,
                            label: traductions.homeActionSend,
                            action: () => AppRouter.push(
                              context,
                              AppRouter.transactionSend,
                            ),
                          ),

                          // Recevoir
                          CtaWidget(
                            image: Images.arrowDown,
                            label: traductions.homeActionRequest,
                            action: () => AppRouter.push(
                              context,
                              AppRouter.transactionReceive,
                            ),
                          ),

                          // Plus
                          CtaWidget(
                            icon: const Icon(Icons.more_horiz, size: 30),
                            label: traductions.homeActionMore,
                            action: () => {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return const HomeTabCompteMoreMenu();
                                },
                                isScrollControlled: true,
                              )
                            },
                          ),
                        ],
                      ),
                    ),
                    // Séparateur
                    const SizedBox(height: 24),
                    // Liste des dernières transactions
                    const TransactionRecentsWidget(),
                  ],
                ),
              ),
            ),
          ),
          // Separateur
          const SizedBox(height: 10),
          // Home Page Widgets
          // Version
        ],
      ),
    );
  }
}
