import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../core/di.dart';
import '../../../../shared/widgets/input_text.dart';
import '../../../alias/domain/models/alias.dart';
import '../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../alias/presentation/bloc/alias_state.dart';
import '../bloc/details/details_bloc.dart';
import '../bloc/details/details_event.dart';
import '../bloc/details/details_state.dart';
import 'compte_details_loading.dart';

class CompteClientWidget extends StatelessWidget {
  const CompteClientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    // recuper l'alias
    final aliasBloc = context.read<AliasBloc>();
    Alias alias = (aliasBloc.state as AliasExistState).alias;

    // Recuperer details du compte
    CompteDetailsBloc compteDetailsBloc = CompteDetailsBloc(
      Di.getCompteInputPort(),
    )..add(GetDetailsCompteEvent(alias.compte));

    return BlocProvider<CompteDetailsBloc>(
      create: (_) => compteDetailsBloc,
      child: BlocBuilder<CompteDetailsBloc, CompteDetailsState>(
        builder: (context, compteDetailsState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Text(
                traductions.comptePersonnelPageTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),

              //
              const SizedBox(height: 24),

              if (compteDetailsState is GetCompteDetailsSuccessState)
                //
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom et prénom
                    CustomTextInput(
                      labelText: traductions.comptePersonnelPageListeNomTitle,
                      controller: TextEditingController(
                        text: compteDetailsState.compteDetails.client.nom,
                      ),
                      readOnly: true,
                    ),

                    //
                    const SizedBox(height: 16),

                    // Telephone
                    CustomTextInput(
                      labelText:
                          traductions.comptePersonnelPageListeTelephoneTitle,
                      controller: TextEditingController(
                        text: compteDetailsState.compteDetails.client.telephone,
                      ),
                      readOnly: true,
                    ),
                    //
                    const SizedBox(height: 16),

                    // Pays de résidence
                    CustomTextInput(
                      labelText: traductions.comptePersonnelPageListePaysTitle,
                      controller: TextEditingController(
                        text: compteDetailsState
                            .compteDetails.client.paysResidence,
                      ),
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),
                    // Adresse
                    if (compteDetailsState.compteDetails.client.adresse != null)
                      CustomTextInput(
                        labelText:
                            traductions.comptePersonnelPageListeAdresseTitle,
                        controller: TextEditingController(
                          text: compteDetailsState.compteDetails.client.adresse,
                        ),
                        readOnly: true,
                      ),
                  ],
                ),
            
              if (compteDetailsState is GetCompteDetailsLoadingState)
                const CompteDetailsLoading()
            ],
          );
        },
      ),
    );
  }
}
