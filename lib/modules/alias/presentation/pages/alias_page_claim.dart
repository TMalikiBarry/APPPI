import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../shared/widgets/loading_page.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../domain/models/alias.dart';
import '../../domain/models/alias_error.dart';
import '../../domain/models/alias_mbno_otp_command.dart';
import '../../domain/models/alias_revendication.dart';
import '../bloc/alias_bloc.dart';
import '../bloc/alias_event.dart';
import '../bloc/alias_state.dart';
import 'alias_page_create_mbno_timer.dart';
import 'alias_page_error.dart';
import 'alias_page_otp.dart';
import 'alias_page_success.dart';

class AliasPageClaim extends StatelessWidget {
  //
  const AliasPageClaim({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    AliasBloc aliasBloc = context.read<AliasBloc>();
    AliasState state = aliasBloc.state;
    if (state is AliasExistState) {
      aliasBloc.add(AliasClaimFetchEvent(id, state.alias));
    }

    // Commencer la construction de la page
    return BlocConsumer<AliasBloc, AliasState>(
      listenWhen: (previous, current) {
        //
        return current is AliasClaimNotFoundState ||
            current is AliasClaimHandlingSuccessState ||
            current is AliasClaimHandlingErrorState;
      }, //

      listener: (context, aliasState) {
        //
        CustomLoadingDialog.hide(context);
        if (aliasState is AliasClaimNotFoundState) {
          // Show error la revendication est terminé cloturé ou archivé
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return AliasPageError(
                error: AliasError.claimNotExist,
                compte: aliasState.alias.compte,
              );
            },
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          ).then((value) {
            if (!context.mounted) return;
            AppRouter.pop(context);
          });
        } //

        else if (aliasState is AliasClaimHandlingSuccessState) {
          // Show success popup
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return AliasPageSuccess(aliasState: aliasState);
            },
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          );
        } //
        else {
          var state = aliasState as AliasClaimHandlingErrorState;
          // Show error popup
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return AliasPageError(
                error: state.error!,
                compte: state.alias.compte,
              );
            },
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          );
        }
      }, //
      buildWhen: (context, state) {
        return state is AliasExistState ||
            state is AliasClaimFetchingState ||
            state is AliasClaimHandlingState ||
            state is AliasClaimHandlingErrorState;
      }, //
      builder: (context, aliasState) {
        if (aliasState is AliasClaimHandlingState ||
                (aliasState is AliasExistState && aliasState.claim != null) ||
                aliasState is AliasClaimHandlingErrorState //
            ) {
          var state = (aliasState as dynamic);
          AliasRevendication claim = state.claim;
          Alias alias = state.alias;
          AliasError? error;
          bool rejecting = false;
          if (aliasState is AliasClaimHandlingState) {
            rejecting = aliasState.rejecting;
          } //
          if (aliasState is AliasClaimHandlingErrorState) {
            rejecting = aliasState.rejecting;
            error = aliasState.error;
          }

          if (rejecting) {
            CustomLoadingDialog.hide(context);
            // Ask OTP Code
            return MyPageContainer(
              child: _claimOtp(
                context,
                traductions,
                aliasBloc,
                alias,
                claim,
                error,
              ),
            );
          } //
          else {
            // Display Claim details
            return MyPageContainer(
              child: _claimDetails(
                context,
                traductions,
                claim,
                aliasBloc,
                alias,
              ),
            );
          }
        } else {
          return LoadingPage(bgColor: Theme.of(context).colorScheme.surface);
        }
      },
    );
  }

  Widget _claimDetails(
    BuildContext context,
    AppLocalizations traductions,
    AliasRevendication claim,
    AliasBloc aliasBloc,
    Alias alias,
  ) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Back button
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BackButton(onPressed: () {
            // AliasExis
            AppRouter.pop(context);
          }),
        ],
      ),

      // Details de la revendication
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ListView(
            children: [
              // Header: title and phone number
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      traductions.aliasClaimDetailsHeadTitle,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    // Nom du paye
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        traductions.aliasClaimDetailsHeadSubTitle,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Title
                    Text(claim.alias)
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Details: Status et dates
              _details(context, traductions, claim),

              const SizedBox(height: 10),

              // Avertissement délai de traitement
              if (claim.statut == AliasRevendicationStatut.initiee)
                _warning(context, traductions, claim)
            ],
          ),
        ),
      ),

      // Actions
      if (claim.statut == AliasRevendicationStatut.initiee)
        _actions(
          context,
          traductions,
          aliasBloc,
          alias,
          claim,
        ),
    ]);
  }

  /// Details affichés: date demande et statut
  Widget _details(
    BuildContext context,
    AppLocalizations traductions,
    AliasRevendication claim,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            // date demande
            _detail(
              context,
              title: traductions.aliasClaimDetailsDateDemande,
              subtitle: DateFormat('d MMM, HH:mm').format(claim.dateDemande),
            ),

            const SizedBox(height: 10),

            // statut
            _detail(
              context,
              title: traductions.statutLabel,
              subtitle: _statut(claim, traductions),
            ),
            const SizedBox(height: 10),

            // Date acceptation ou rejet
            if (claim.dateAction != null)
              _detail(
                context,
                title: claim.statut == AliasRevendicationStatut.acceptee
                    ? traductions.aliasClaimDetailsDateAcceptation
                    : traductions.aliasClaimDetailsDateRefus,
                subtitle: DateFormat('d MMM, HH:mm').format(claim.dateAction!),
              ),
          ],
        ),
      ),
    );
  }

  /// Affiche un detail de la revendication
  Widget _detail(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
        Expanded(
          child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Themer.neural03Color),
          ),
        ),
      ],
    );
  }

  /// Statut de la revendication
  String _statut(AliasRevendication claim, AppLocalizations traductions) {
    if (claim.statut == AliasRevendicationStatut.initiee) {
      return traductions.statutInitie;
    } else if (claim.statut == AliasRevendicationStatut.acceptee) {
      return traductions.statutAccepte;
    } else {
      return traductions.statutRejete;
    }
  }

  /// Avertissement délai de réponse
  Widget _warning(
    BuildContext context,
    AppLocalizations traductions,
    AliasRevendication claim,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 20,
        top: 2.0,
        bottom: 5.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          traductions.aliasClaimDetailsAlert(
            DateFormat('dd MMMM yyyy').format(claim.dateVerrouillage),
            DateFormat('dd MMMM yyyy').format(claim.dateCloture),
          ),
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme //
              .bodyLarge
              ?.copyWith(
                color: Themer.systemErrorColor,
              ),
        ),
      ),
    );
  }

  /// Affiche les boutons Accepter et rejeter
  Widget _actions(
    BuildContext context,
    AppLocalizations traductions,
    AliasBloc aliasBloc,
    Alias alias,
    AliasRevendication claim,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rejeter
          Expanded(
            child: FilledButton.tonal(
              onPressed: () {
                CustomLoadingDialog.show(context);
                aliasBloc.add(
                  AliasClaimRespondEvent(id, alias, claim, false, null),
                );
              },
              child: Text(traductions.btnTextReject),
            ),
          ),
          //
          const SizedBox(width: 16),
          // Confirmer
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                      title: traductions.aliasClaimAcceptDialogTitle,
                      description: traductions.aliasClaimAcceptDialogMessage(
                        claim.alias,
                      ),
                      confirmBtnText: traductions.btnTextConfirm,
                      confirmBtnAction: () {
                        AppRouter.pop(context);
                        CustomLoadingDialog.show(context);
                        aliasBloc.add(
                          AliasClaimRespondEvent(id, alias, claim, true, null),
                        );
                      },
                      cancelBtnText: traductions.btnTextCancel,
                      cancelBtnAction: () => AppRouter.pop(context),
                    );
                  },
                );
              },
              child: Text(traductions.btnTextAccept),
            ),
          ),
        ],
      ),
    );
  }

  /// Affiche champ pour saisir le code OTP
  Widget _claimOtp(
    BuildContext context,
    AppLocalizations traductions,
    AliasBloc aliasBloc,
    Alias alias,
    AliasRevendication claim,
    AliasError? error,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Back button
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BackButton(onPressed: () {
              // AliasExis
              AppRouter.pop(context);
            }),
          ],
        ),

        // Le formulaire
        Expanded(
          child: SingleChildScrollView(
            child: AliasPageOtp(
              pinLength: AliasMbnoOtpCommand.otpSize,
              title: traductions.verifyPhoneNumberPageTitle,
              subtitle: traductions.verifyPhoneNumberPageSubTitle(claim.alias),
              errorMessage:
                  error != null ? traductions.aliaMBNOInvalidOtpMessage : null,
              countdownTimer: aliasBloc.state is AliasClaimHandlingState
                  ? AliasMBNOCountdownTimer(
                      onResendOtp: (channel) => aliasBloc.add(
                        AliasClaimRespondEvent(id, alias, claim, false, null),
                      ),
                    )
                  : null,
              onOtpComplete: (otpCode, channel) {
                aliasBloc.add(
                  AliasClaimRespondEvent(
                    id,
                    alias,
                    claim,
                    false,
                    otpCode,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
