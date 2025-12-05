import 'package:common_dependencies/utils/colors.dart';
import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:micro_core/services/routing/routes.dart';
import 'package:micro_core/services/routing/routing.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import 'package:pi_mobile_app/modules/config/adapters/ui/bloc/config_bloc.dart';
import 'package:pi_mobile_app/modules/config/domain/models/config_keys.dart';
import 'package:pi_mobile_app/modules/transactions/presentation/pages/transaction_send/transaction_send_page.dart';
import 'package:base_app/presenter/home.dart';

import '../../../../core/assets.dart';
import '../../../../core/theme.dart';
import '../../../config/adapters/ui/bloc/config_event.dart';
import '../../../contacts/presentation/bloc/contact_bloc.dart';
import '../../../contacts/presentation/bloc/contact_event.dart';
import '../../../notification/presentation/pages/notification_btn_open_widget.dart';
import '../../../profile/presentation/bloc/hide_amount/hide_amount_bloc.dart';
import '../../../profile/presentation/bloc/hide_amount/hide_amount_event.dart';
import '../../../security/domain/models/connected_user.dart';
import '../../../security/presentation/bloc/login/login_bloc.dart';
import '../../../security/presentation/bloc/login/login_state.dart';
import '../../../subscription/presentation/pages/subscription_list/subscription_list_widget.dart';
import 'home_bottom_navigation_bar.dart';
import 'home_bottom_widget.dart';
import 'home_tab_compte.dart';
import 'home_toolbar_leading.dart';

class HomePage extends StatefulWidget {
  //
  const HomePage({super.key, this.selectedTab});
  final int? selectedTab;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    // Compte numéro
    // Initialize hide amount / Eye Off Listener
    context
        .read<ParametreHideAmountBloc>()
        .add(const ParametreHideAmountInitEvent());
    context
        .read<ConfigBloc>()
        .add(const ConfigChangeEvent(ConfigKey.introductionPassed, "1"));
    // Pre fetch contacts
    context.read<ContactBloc>().add(const ContactListEvent(null));
  }

  @override
  Widget build(BuildContext context) {
   //print"Into home page");   //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => current is LoginSuccessState,
      builder: (context, state) {
        //if (state is! LoginSuccessState) {  return const LoadingPage();
        //}
        return DefaultTabController(
          length: 3,
          initialIndex: widget.selectedTab ?? 0,
          child: Scaffold(
            // Pour avoir le bouton de retour
            appBar: AppBar(
              //leading: HomeToolbarLeading(user: state.user!),
              leading: HomeToolbarLeading(user: ConnectedUser.current!),
              leadingWidth: 200, // default is 56
              actions: actionsBtns(context),
              bottom: TabBar(
                splashBorderRadius: BorderRadius.circular(12.2),
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    return Colors.transparent;
                  },
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                // Le style appliquée a tous les textes du tabBar
                labelStyle: Theme.of(context).textTheme.bodySmall,
                labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                // La couleur du text de la tab selectionnée
                labelColor: Colors.white,
                // La couleur du text des tabs non sélectionnée
                unselectedLabelColor: Themer.neural04Color,
                // La largeur de la tab sélectionner
                indicatorSize: TabBarIndicatorSize.label,
                // Bordure - couleur de fond de la tab sélectionnée
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Themer.amberColor,
                ),
                //
                indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
                dividerColor: Colors.transparent,
                //
                tabs: [
                  // Compte
                  Tab(
                    child: SizedBox(
                      width: 80, // Largeur personnalisée
                      child:  Align(
                        alignment: Alignment.center,
                        child: Text(
                            traductions.homePageToolbarTabbarCompte,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                        ),
                      ),
                    )
                  ),
                  // Abonnements
                  Tab(
                    child: SizedBox(
                      width: 110, // Largeur personnalisée
                      child:  Align(
                        alignment: Alignment.center,
                        child: Text(
                            traductions.homePageToolbarTabbarAbonnement,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                        ),
                      ),
                    ),
                  ),
                  // Savings
                  Tab(
                    child: SizedBox(
                      width: 100, // Largeur personnalisée
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            traductions.homePageToolbarTabbarEconomie,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Contenu de la page principale
            body: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TabBarView(
                children: [
                  Icon(Icons.games),
                  SubscriptionListWidget(),
                  HomeTabCompte(),
                ],
              ),
            ),
            extendBody: true,
            // Barre de navigation
            //bottomNavigationBar: const HomeBottomNavigationBar(),
            bottomNavigationBar: BottomNavbar(
              currentIndex: selectedIndex,
              onTap: (index) {
                setState(() => selectedIndex = index);
              },
            ),
          ),
        );
      },
    );
  }

  /// Boutons toolbar
  List<Widget> actionsBtns(BuildContext context) {
    return [
      // Search
      IconButton(
        icon: ImageIcon(
          const AssetImage(Images.iconSearchHeaderHP, package: 'common_dependencies'),
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () {
          //
        },
      ),
      // Budgets
      IconButton(
        icon: ImageIcon(
          const AssetImage(Images.iconAnalytique, package: 'common_dependencies'),
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () {
          //
        },
      ),
      // Notifications
      const NotificationBtnOpenWidget(),
    ];
  }

}
