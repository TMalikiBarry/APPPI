import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../config/domain/models/config_keys.dart';
import '../../../security/domain/models/connected_user.dart';

class HomeToolbarLeading extends StatelessWidget {
  //
  const HomeToolbarLeading({super.key, required this.user});

  final ConnectedUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Themer.get(
        context.read<ConfigBloc>().getParamValue(ConfigKey.preferedTheme)
    );
    RoundedRectangleBorder border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40 / 3),
    );
    ShapeDecoration boxDecoration;
    Widget? child;
    if (user.avatar != null && user.avatar!.isNotEmpty) {
      boxDecoration = ShapeDecoration(
        color: Colors.transparent,
        shape: border,
        image: DecorationImage(
          image: NetworkImage(user.avatar!),
          fit: BoxFit.fill,
        ),
      );
      // Affiche que l'image
      child = null;
    } else {
      boxDecoration = ShapeDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: border,
      );
      // Affiche les initiales
      child = Center(child: Text(user.initiales()));
    }
    return InkWell(
      onTap: () => AppRouter.push(
        context,
        AppRouter.profile,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar bouton profil
            Container(
              width: 40,
              height: 40,
              decoration: boxDecoration,
              child: child,
            ),
            // Logo SPI
            const SizedBox(width: 10),
            Container(
              height: 24,
              width: 71.98,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      theme.brightness == Brightness.light  ?
                      Images.logoSpiDark : Images.logoSpiLight, package: 'common_dependencies'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
