import 'package:common_dependencies/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import 'package:pi_mobile_app/modules/config/adapters/ui/bloc/config_bloc.dart';
import 'package:pi_mobile_app/modules/config/domain/models/config_keys.dart';
import 'package:pi_mobile_app/modules/home/presentation/pages/support_page.dart';
import '../../../../core/assets.dart';
import '../../../../core/theme.dart';
import '../../../alias/domain/models/alias.dart';
import '../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../alias/presentation/bloc/alias_state.dart';
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
import 'home_bottom_navigation_bar_2.dart';
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
  var disabledTabs = <int>{ 1, 2 };  // indices des onglets à griser

  @override
  initState () {
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    if (alias.accountType == "TRAN") {
      disabledTabs = <int>{ 2 };  // indices des onglets à griser
    }
    super.initState();
  }
  int selectedIndex = 2;
  final baseWidth = 375;


  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;


    return DefaultTabController(
      length: 3,
      initialIndex: widget.selectedTab ?? 0,
      child: Builder(builder: (innerContext) {
        // On récupère ici le TabController
        final tabController = DefaultTabController.of(innerContext)!;

        return Scaffold(
          appBar: AppBar(
            leading: HomeToolbarLeading(user: ConnectedUser.current!),
            leadingWidth: 200,
            actions: actionsBtns(context),
            bottom: TabBar(
              splashBorderRadius: BorderRadius.circular(12.2),
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return Colors.transparent;
                },
              ),

              onTap: (index) {
                if (disabledTabs.contains(index)) {
                  // Empêche la navigation et affiche un message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(traductions.coming_soon, style: TextStyle(color: Themer.whiteColor),),
                      backgroundColor: Themer.primaryColor,
                    ),
                  );
                  // Remet le TabController sur l’onglet courant
                  tabController.animateTo(tabController.previousIndex);
                }
                // Sinon, laisse le DefaultTabController gérer le changement
              },
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // Le style appliquée a tous les textes du tabBar
              labelStyle: Theme.of(context).textTheme.bodySmall,
              labelPadding: const EdgeInsets.symmetric(horizontal: 2),
              labelColor: Colors.white,
              unselectedLabelColor: Themer.neural04Color,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Themer.amberColor,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
              tabs: List.generate(3, (i) {
                // Détermine le texte et la largeur selon l’index
                final label = [
                  traductions.homePageToolbarTabbarCompte,
                  traductions.homePageToolbarTabbarAbonnement,
                  traductions.homePageToolbarTabbarEconomie,
                ][i];
                final width = [80.0, 110.0, 100.0][i];
                // Opacité réduite si onglet désactivé
                final opacity = disabledTabs.contains(i) ? 0.25 : 1.0;

                return Tab(
                  child: Opacity(
                    opacity: opacity,
                    child: SizedBox(
                      width: width,
                      child: Center(
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(), // Empêche le swipe entre tabs
              children: [
                HomeTabCompte(),
                SubscriptionListWidget(),
                Icon(Icons.games),
              ],
            ),
          ),
          extendBody: true,
          bottomNavigationBar: BottomNavbar(
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() => selectedIndex = index);
            },
          ),
        );
      }),
    );
  }

  /// Boutons toolbar
  List<Widget> actionsBtns(BuildContext context) {
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
    return [
      // Search
/*      IconButton(
        icon: ImageIcon(
          const AssetImage(Images.iconSearchHeaderHP, package: 'common_dependencies'),
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () {
          //
        },
      ),*/
      // Budgets
 /*     IconButton(
        icon: ImageIcon(
          const AssetImage(Images.iconAnalytique, package: 'common_dependencies'),
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () {
          //
        },
      ),*/
      // Notifications
      const NotificationBtnOpenWidget(),

      Padding(
        padding: const EdgeInsets.only(right: 5),
        child: IconButton(
          constraints: const BoxConstraints(),
          onPressed: () {
            showSupportBottomSheet(context);
          },
          icon: SvgPicture.asset(
            "assets/images/call_customer_service.svg",
            package: 'common_dependencies',
            height: 22 * fem,
            width: 22 * fem,
          ),
        ),
      ),
    ];
  }
  void showSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35.0),
        ),
      ),
      builder: (BuildContext context) {
        return const SupportPage(fromTab: true);
      },
    );
  }
}
