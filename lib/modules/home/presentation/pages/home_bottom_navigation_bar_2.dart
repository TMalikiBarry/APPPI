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
      child: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2F296A),
    items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
    BottomNavigationBarItem(icon: Icon(Icons.swap_vert), label: 'Transactions'),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: 'TouchPoint'),
    ],
    currentIndex: 0,
    onTap: (index) {
    // gestion des tabs
    },
    ),
    );
  }
}
