import 'package:common_dependencies/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/core/router.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../core/assets.dart';
import '../../../../core/theme.dart';
import '../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../config/domain/models/config_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';


class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavbar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  void _handleTap(int index) {
    if (widget.currentIndex == index) return;

    // Redirection personnalisée
    switch (index) {
      case 0:
        AppRouter.go(context, AppRouter.home); // ou Navigator.push(...)
        break;
      case 1:
        AppRouter.go(context, AppRouter.transactionSearch);
        break;
      case 2:
        AppRouter.go(context, AppRouter.homePage);
        break;
    }

    // Callback optionnel
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final translations = AppLocalizations.of(context)!;

    return Material(
      elevation: 2,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Color(0xFF667085),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
          ),
          unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
          ),
          onTap: _handleTap,
          items: [
            BottomNavigationBarItem(
              label: translations.bottom_bar_home,
              icon: Image.asset(
                'assets/images/home_icon.png',
                width: 29 ,
                height: 29 ,
                package: "common_dependencies",
              ),
            ),
            BottomNavigationBarItem(
              label: translations.bottom_bar_transaction,
              icon: SvgPicture.asset(
                'assets/images/ion_list.svg',
                package: 'common_dependencies',
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
            ),
            BottomNavigationBarItem(
              label: "TouchPoint",
              icon: Image.asset(
                "assets/images/touch-logo.png",
                package: "common_dependencies",
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
