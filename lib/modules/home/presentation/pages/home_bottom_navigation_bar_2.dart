import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../config/adapters/ui/bloc/config_state.dart';
import '../../../config/domain/models/config_keys.dart';
import 'package:micro_core/micro_core.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Themer.get(
      context.read<ConfigBloc>().getParamValue(ConfigKey.preferedTheme),
    );

    return Container(
      padding: const EdgeInsets.only(top: 25),
      color: Colors.transparent,
      child: Stack(
        children: [
          // Shadow on top only
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.light
                        ? const Color(0x33000000)
                        : const Color(0x66000000),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  context,
                  label: "Accueil",
                  icon: const Icon(Icons.home_outlined, color: Themer.secondaryColor, weight: 29,),
                  onTap: () => AppRouter.go(context, AppRouter.home),
                ),
                _buildTabItem(
                  context,
                  label: "Transfert",
                  icon: ImageIcon(
                    const AssetImage(
                      Images.homeFooterTransfer,
                      package: 'common_dependencies',
                    ),
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 29,
                  ),
                  onTap: () =>
                      AppRouter.push(context, AppRouter.transactionSend),
                ),
                _buildTabItem(
                  context,
                  label: "TouchPoint",
                  icon: Image.asset(
                    "assets/images/touch-logo.png",
                    package: 'common_dependencies',
                    width: 29,
                    height: 29,
                    fit: BoxFit.contain,
                  ),
                  onTap: () => AppRouter.go(context, AppRouter.homePage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context,
      {required Widget icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
