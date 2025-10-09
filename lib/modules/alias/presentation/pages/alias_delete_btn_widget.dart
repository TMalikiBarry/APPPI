import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../shared/widgets/loading_page.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../../../shared/widgets/notification_dialog.dart';
import '../../domain/models/alias.dart';
import '../bloc/alias_bloc.dart';
import '../bloc/alias_event.dart';
import '../bloc/alias_state.dart';

class AliasDeleteBtnWidget extends StatelessWidget {
  const AliasDeleteBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    final aliasBloc = context.read<AliasBloc>();
    // Pour récuperer l'alias
    //
    Alias alias = (aliasBloc.state as AliasExistState).alias;
    return BlocListener<AliasBloc, AliasState>(
      listenWhen: (context, state) {
        return state is AliasDeletingState ||
            state is AliasDeleteErrorState ||
            state is AliasNotExistState;
      },
      listener: (context, state) {
        // En cours de suppression
        if (state is AliasDeletingState) {
          // AppRouter.pop(context);
          CustomLoadingDialog.show(context);
          // Navigator.of(context).pop();
        }
        // Supprimé
        else if (state is AliasNotExistState) {
          // AliasDeleteSuccessState
          CustomLoadingDialog.hide(context);
          AppRouter.go(
            context,
            AppRouter.home,
          );
          //AppRouter.pushReplacement(
          //  context,
          //  AppRouter.home,
          //);
        }
        // Erreur de suppression
        else if (state is AliasDeleteErrorState) {
          CustomLoadingDialog.hide(context);
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return NotificationDialog(
                type: NotificationType.error,
                message: traductions.compteDetailsPagePopupDeleteAliasErrorMsg,
                btnText: "Ok",
              );
            },
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          ).then((value) => {});
        }
      },
      /*child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: MyPageContainer(
          child: ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).secondaryHeaderColor,
                  ),
                ),
            onPressed: () => _askConfirmationBeforeDelete(
              context,
              aliasBloc,
              alias,
              traductions,
            ),
            child: Text(traductions.compteDetailsPageBtnSupprimer),
          ),
        ),
      ),*/
      child:  Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _askConfirmationBeforeDelete(
                context,
                aliasBloc,
                alias,
                traductions,
              ),
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF93832), width: 2),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                  traductions.compteDetailsPageBtnSupprimer,
                style: TextStyle(color: Color(0xFFF93832)),
              ),
            ),
          ),
        ),
      ),

    );
  }

  /// Confirmation demandée avant de supprimer alias

  /*void _askConfirmationBeforeDelete(
      BuildContext context,
      AliasBloc aliasBloc,
      Alias alias,
      AppLocalizations traductions,
      ) {
    bool alreadyTapped = false;
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        title: traductions.compteDetailsPagePopupDeleteAliasTitle, é
        description: traductions.compteDetailsPagePopupDeleteAliasSubTitle,
        confirmBtnText: traductions.compteDetailsPagePopupDeleteAliasBtnConfirmer,
        confirmBtnAction: () {
          if (alreadyTapped) return;

          alreadyTapped = true;
          // 1) on ferme *immédiatement* le dialog de confirmation
          Navigator.of(context).pop();

          // 2) puis on envoie l’évènement au bloc
          aliasBloc.add(AliasDeleteEvent(alias.cle));
        },
        cancelBtnText: traductions.compteDetailsPagePopupDeleteAliasBtnAnnuler,
        cancelBtnAction: () => Navigator.of(context).pop(),
      ),
    );
  }*/

 void _askConfirmationBeforeDelete(
    context,
    AliasBloc aliasBloc,
    Alias alias,
    AppLocalizations traductions,
  ) {
  bool alreadyTapped = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: traductions.compteDetailsPagePopupDeleteAliasTitle,
          description: traductions.compteDetailsPagePopupDeleteAliasSubTitle,
          confirmBtnText:
              traductions.compteDetailsPagePopupDeleteAliasBtnConfirmer,
          confirmBtnAction: () {
           if (alreadyTapped) return;

          alreadyTapped = true;
            aliasBloc.add(AliasDeleteEvent(alias.cle));
          },
          cancelBtnText:
              traductions.compteDetailsPagePopupDeleteAliasBtnAnnuler,
          cancelBtnAction: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
