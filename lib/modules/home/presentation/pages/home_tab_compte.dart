import 'package:common_dependencies/utils/colors.dart';
import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/cta_widget.dart';
import '../../../alias/domain/models/alias.dart';
import '../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../alias/presentation/bloc/alias_state.dart';
import '../../../compte/presentation/pages/solde_widget_card.dart';
import '../../../transactions/presentation/pages/transaction_recents/transaction_recents_widget.dart';
import 'home_tab_compte_more_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
class HomeTabCompte extends StatefulWidget {
  const HomeTabCompte({super.key});

  @override
  State<HomeTabCompte> createState() => _HomeTabCompteState();
}

class _HomeTabCompteState extends State<HomeTabCompte> {
  // Clé unique pour forcer le rebuilt des enfants
  UniqueKey _refreshKey = UniqueKey();
  bool isTran = false;
  String kyc="";
  @override
  initState () {
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    if (alias.accountType == "TRAN") {
      isTran = true;  // indices des onglets à griser
    }
    getKYC();
    super.initState();
  }


  Future<void> _handleRefresh() async {
    setState(() {
      _refreshKey = UniqueKey(); // Nouvelle clé => rebuilt forcé
    });
  }
getKYC () async {
  var pref = await SharedPreferences.getInstance();
  kyc=pref.getString('kycStatus')!;
}
  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color(0xFF282C5D),
      onRefresh: _handleRefresh,
      child: ListView(
        key: _refreshKey,
        children: [
          // Home Page Fixed Design
          Card(
            //color: Themer.backgroundPiProgramme,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Affiche le widget solde
                    //const SoldeWidget(),
                    const SoldeWidgetCard(),
                    // Séparateur
                    const SizedBox(height: 15),
                    // Principales actions: Envoyer, Recevoir, Plus
                    Padding(
                      //padding: const EdgeInsets.only(right: 70,),
                      //padding: const EdgeInsets.only(right: 86,),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      //padding: const EdgeInsets.all(20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Envoyer
                          CtaWidget(
                            image: Images.iconMoneySendHeaderHPHomePage,
                            label: traductions.homeActionSend,
                            action: () => AppRouter.push(
                              context,
                              AppRouter.transactionSend,
                            ),
                          ),

                          // Recevoir
                          CtaWidget(
                            image: Images.iconMoneyReceiveHeaderHPHomePage,
                            label: traductions.homeActionRequest,
                            disabled: kyc=="VERIFIED",
                            action: () =>
                             AppRouter.push(
                              context,
                              AppRouter.transactionReceive,
                            ),
                          ),
                          // Plus
                          CtaWidget(
                            // icon: const Icon(Icons.more_horiz, size: 30),
                            image: Images.iconMoreActionHeaderHPHomePage,
                            label: traductions.homeActionMore,
                            disabled: kyc=="VERIFIED",
                              action: ()=> showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const HomeTabCompteMoreMenu();
                                    },
                                    isScrollControlled: true,
                                  ),
                          ),
                          ]
                      ),
                    ),
                    const SizedBox(height: 15),

                  ],
                ),
              ),
            ),
          ),
          // Séparateur
          // Liste des dernières transactions
          const Padding(padding: EdgeInsets.only(left: 15,right: 15),
          child: TransactionRecentsWidget(),),
          // Separateur
          const SizedBox(height: 10),
          // Home Page Widgets
          // Version
        ],
      ),
    );
  }

}
