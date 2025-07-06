import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../config/adapters/ui/bloc/config_state.dart';
import '../../../config/domain/models/config_keys.dart';
import 'package:micro_core/micro_core.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  ///
  const HomeBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Themer.get(
      context.read<ConfigBloc>().getParamValue(ConfigKey.preferedTheme)
    );

    return Container(
      width: 100,
      padding: const EdgeInsets.only(bottom: 20),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            height: 56,
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              shadows: [
                BoxShadow(
                  color: theme.brightness == Brightness.light 
                      ? const Color(0xFFF0F0EC)
                      : const Color(0xEF202020),
                  blurRadius: 8.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: const Offset(
                    8.0, // Move to right 5  horizontally
                    0, // Move to bottom 5 Vertically
                  ), // Shadow position
                ),
              ],
            ),
            child: Row(
              children: [
                // Home
                FloatingActionButton.small(
                  onPressed: () => AppRouter.go(context, AppRouter.home),
                  elevation: 0,
                  heroTag: "home",
                  child: SvgPicture.asset(
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onPrimary,
                      BlendMode.srcIn,
                    ),
                    Images.homeFooterHome,
                    width: 24,
                    height: 24,
                    package: 'common_dependencies',
                  ),
                ),
                // QR Code
                FloatingActionButton.small(
                  onPressed: () {
                    ConfigState configState =
                        context.read<ConfigBloc>().state;
                    String? currentValue = configState
                        .configParams.params[ConfigKey.showQRcode.code];
                    AppRouter.push(
                        context,
                        currentValue != null && currentValue == "1"
                            ? AppRouter.qrcodeShow
                            : AppRouter.qrcodeScan);
                  },
                  elevation: 0,
                  heroTag: "qrcode",
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: ImageIcon(
                    const AssetImage(Images.homeFooterQrcode,package: 'common_dependencies'),
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                // Send transfer
                FloatingActionButton.small(
                  onPressed: () =>
                      AppRouter.push(context, AppRouter.transactionSend),
                  elevation: 0,
                  heroTag: "transfer",
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: ImageIcon(
                    const AssetImage(Images.homeFooterTransfer,package: 'common_dependencies'),
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                FloatingActionButton.small(
                  onPressed: () {
                    // Redirection vers la page principale
                    AppRouter.go(context, AppRouter.homePage);
                  },
                  elevation: 0,
                  heroTag: "customer App",
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: Image.asset(
                    "assets/images/touch-logo.png",
                    package: 'common_dependencies',
                    width: 24,  // Ajusté pour correspondre aux autres icônes
                    height: 24, // Ajusté pour correspondre aux autres icônes
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
