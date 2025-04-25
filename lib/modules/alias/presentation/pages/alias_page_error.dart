import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/notification_dialog.dart';
import '../../domain/models/alias_error.dart';
import '../bloc/alias_bloc.dart';
import '../bloc/alias_event.dart';
import '../bloc/alias_state.dart';

class AliasPageError extends StatelessWidget {
  //
  const AliasPageError({
    super.key,
    required this.error,
    required this.compte,
  });
  final AliasError error;
  final String compte;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localisation = AppLocalizations.of(context)!;
    // Affiche l'erreur
    return NotificationDialog(
      type: NotificationType.error,
      title: localisation.aliaErrorPageTitle,
      subtitle: _getSubtitle(localisation),
      description: _getDescription(localisation),
      btns: _getBtns(localisation, context),
    );
  }

  String? _getSubtitle(AppLocalizations localisation) {
    if (error == AliasError.aliasAlreadyExist) {
      return localisation.aliaErrorPageSubTitle;
    } //
    else if (error == AliasError.aliasNotExist) {
      return localisation.aliaErrorClaimNotFoundPageSubTitle;
    } //
    else if (error == AliasError.claimNotExist) {
      return localisation.aliaErrorClaimNotExistPageSubTitle;
    } //
    else {
      return null;
    }
  }

  String _getDescription(AppLocalizations localisation) {
    if (error == AliasError.aliasAlreadyExist) {
      return localisation.aliaErrorPageDescription;
    } else if (error == AliasError.connection) {
      return localisation.internetErrorSubtitle;
    } else if (error == AliasError.unknow) {
      return localisation.serverErrorSubtitle;
    } else if (error == AliasError.claimNotExist) {
      return localisation.aliaErrorClaimNotExistPageDescription;
    } else if (error == AliasError.aliasLocked) {
      return localisation.aliaErrorClaimLockedPageSubTitle;
    } else {
      return localisation.serverErrorSubtitle;
    }
  }

  List<NotificationBtn> _getBtns(
    AppLocalizations localisation,
    BuildContext context,
  ) {
    if (error == AliasError.aliasAlreadyExist) {
      return [
        NotificationBtn(
          btnText: localisation.aliaErrorPageReclamationBtnText,
          btnAction: () {
            AliasBloc aliasBloc = context.read<AliasBloc>();
            AliasCreationErrorState state =
                aliasBloc.state as AliasCreationErrorState;
            aliasBloc.add(AliasClaimAskEvent(
              compte: compte,
              phoneNumber: state.values.phoneNumber!,
            ));
          },
        ),
        NotificationBtn(
          btnText: localisation.aliaErrorPageChoisisserBtnText,
          btnAction: () => AppRouter.pop(context),
        ),
      ];
    } //
    else if (error == AliasError.claimNotExist ||
        error == AliasError.aliasLocked) {
      return [
        NotificationBtn(
          btnText: localisation.aliaSuccessPageBtnText,
          btnColor: Theme.of(context).colorScheme.tertiary,
          btnAction: () => AppRouter.pop(context),
        ),
      ];
    }
    //
    else {
      return [
        // NotificationBtn(btnText: localisation.reessayer),
      ];
    }
  }
}
