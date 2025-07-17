import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../alias/presentation/bloc/alias_state.dart';
import '../../../security/domain/models/connected_user.dart';
import '../../../security/presentation/bloc/login/login_bloc.dart';

class ProfilePageAvatar extends StatelessWidget {
  //
  const ProfilePageAvatar({super.key});

  ///
  final double avatarDimension = 64;

  @override
  Widget build(BuildContext context) {
    // Pour récuperer les informations de l'utilisateur
    final loginBloc = context.read<LoginBloc>();
    final ConnectedUser user = loginBloc.getConnectedUser()!;

    // Pour récuperer l'alias
    final aliasBloc = context.read<AliasBloc>();
    final AliasExistState aliasState = aliasBloc.state as AliasExistState;

    // Si l'image de l'avatar n'est pas fourni, utiliser les initiales du nom
    ShapeDecoration boxDecoration;
    RoundedRectangleBorder border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(avatarDimension / 2),
    );
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
    // Retourne l'avatar et le nom
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Nom et alias
        SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom
              Text(
                "${user.firstName} ${user.lastName}",
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
              //
              const SizedBox(
                height: 12,
              ),
              Text(
                aliasState.alias.cle,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    . //
                    copyWith(color: Themer.neural03Color),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        /// Avatar
        Container(
          width: avatarDimension,
          height: avatarDimension,
          decoration: boxDecoration,
          child: child,
        ),
      ],
    );
  }
}
