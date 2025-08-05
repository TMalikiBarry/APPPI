import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router.dart';
import '../../../../shared/widgets/loading_page.dart';
import '../../../security/domain/models/connected_user.dart';
import '../../../security/presentation/bloc/login/login_bloc.dart';
import '../../domain/models/alias_error.dart';
import '../bloc/alias_bloc.dart';
import '../bloc/alias_event.dart';
import '../bloc/alias_state.dart';
import 'alias_page_create_mbno_form.dart';
import 'alias_page_create_mbno_otp.dart';
import 'alias_page_create_options.dart';
import 'alias_page_error.dart';
import 'alias_page_success.dart';

class AliasPage extends StatelessWidget {
  //
  const AliasPage({super.key});

  @override
  Widget build(BuildContext context) {
    AliasBloc aliasBloc = context.read<AliasBloc>();
    // Récupération des infors de l'utilisateur
    // NOus considérons que l'utiliosateur n'a qu'un seul compte principal
    // dont la référence est enregistrée dans les données utilisateur
    final loginBloc = context.read<LoginBloc>();
    ConnectedUser user = loginBloc.getConnectedUser()!;
    String compte = user.reference();

    // Commencer la construction de la page
    return BlocConsumer<AliasBloc, AliasState>(listenWhen: (previous, current) {
      //
      return (current is AliasExistState &&
              (previous is AliasInitialState ||
                  previous is AliasCreatingState)) ||
          //(current is AliasVerifExistState &&
          //  previous is AliasLoadingState) ||
          current is AliasCreationErrorState ||
          current is AliasClaimAskingState ||
          current is AliasClaimAskingSuccessState ||
          current is AliasClaimAskingErrorState;
    }, //
        listener: (context, aliasState) {
          logger.i("alias_page aliasState listener : $aliasState");
      //
      if (aliasState is AliasExistState) {
        // Show success popup creation alias
        if (aliasState.claim == null) {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return AliasPageSuccess(aliasState: aliasState);
            },
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          ).then((value) {
            if (!context.mounted) return;
            AppRouter.go(context, AppRouter.home);
          });
        }
      } else if (aliasState is AliasClaimAskingSuccessState) {
        // Show success popup revendication
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return AliasPageSuccess(aliasState: aliasState);
          },
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
      }
      // Erreur
      else if (aliasState is AliasCreationErrorState ||
          aliasState is AliasClaimAskingErrorState) {
        AliasError error = (aliasState as dynamic).error!;
        // Show error popup creation alias
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return AliasPageError(error: error, compte: compte);
          },
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
      } //
      else if (aliasState is AliasClaimAskingState) {
        // Close Bottom Sheet revendiquer alias
        AppRouter.pop(context);
      }
    }, //
        buildWhen: (context, state) {
      return state is AliasInitialState ||
          //state is AliasLoadingState ||
          state is AliasNotExistState ||
          (state is AliasExistState && state.claim == null) ||
          state is AliasCreatingState ||
          state is AliasLoadingState ||
          state is AliasMBNOCreationState ||
          state is AliasMBNOVerificationState ||
          state is AliasCreationErrorState ||
          state is AliasClaimAskingState ||
          state is AliasClaimAskingSuccessState ||
          state is AliasClaimAskingErrorState;
    }, //
        builder: (context, aliasState) {
      logger.i("alias_page aliasState buildWhen : $aliasState");
      if (aliasState is AliasExistState) {
        AppRouter.go(context, AppRouter.home);
      }
      return Scaffold(
        // Pour avoir le bouton de retour
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              if (aliasState is AliasMBNOCreationState) {
                aliasBloc.add(FetchAliasEvent(compte));
              } //
              else if (aliasState is AliasMBNOVerificationState) {
                aliasBloc.add(CreateAliasMBNOEvent(compte));
              } //
              else {
                AppRouter.pushReplacement(
                    context,
                    // AppRouter.introduction
                    AppRouter.homePage
                );
              }
            },
          ),
        ),
        // Contenu de la page de connexion
        body: SafeArea(
          child: _getPage(context, aliasState),
        ),
      );
    });
  }

  /// Determine la page à afficher en fonction de l'état
  Widget _getPage(
    BuildContext context,
    AliasState aliasState,
  ) {
    if (aliasState is AliasNotExistState ||
            aliasState is AliasCreationErrorState ||
            aliasState is AliasClaimAskingSuccessState ||
            aliasState is AliasClaimAskingErrorState //
        ) {
      return const AliasPageCreateOptions();
    } //
    else if (aliasState is AliasMBNOCreationState) {
      return AliasPageCreateMBNOForm(aliasState: aliasState);
    } //
    else if (aliasState is AliasMBNOVerificationState) {
      return AliasPageCreateMBNOOtp(aliasState: aliasState);
    } //
    else {
      return LoadingPage(
        bgColor: Theme.of(context).colorScheme.surface,
      );
    } //
  }
}