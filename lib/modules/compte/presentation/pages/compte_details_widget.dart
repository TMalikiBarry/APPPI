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

class CompteDetailsWidget extends StatelessWidget {
  const CompteDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    final aliasBloc = context.read<AliasBloc>();
    Alias alias = (aliasBloc.state as AliasExistState).alias;
    CompteDetailsBloc compteDetailsBloc = CompteDetailsBloc(
      Di.getCompteInputPort(),
    )..add(GetDetailsCompteEvent(alias.compte));
    return BlocProvider<CompteDetailsBloc>(
      create: (_) => compteDetailsBloc,
      child: BlocBuilder<CompteDetailsBloc, CompteDetailsState>(
        builder: (context, state) {
          //
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titm
              Text(
                traductions.compteDetailsPageTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),

              //
              const SizedBox(
                height: 24.0,
              ),

              if (state is GetCompteDetailsSuccessState)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type compte
                    CustomTextInput(
                      labelText: traductions.compteDetailsPageListeTypeComTitle,
                      controller: TextEditingController(
                        text: state.compteDetails.compte.type,
                      ),
                      readOnly: true,
                    ),

                    //
                    const SizedBox(height: 16),

                    // Numéro compte
                    CustomTextInput(
                      labelText: traductions.compteDetailsPageListeNumCompTitle,
                      controller: TextEditingController(
                        text: state.compteDetails.compte.numero,
                      ),
                      readOnly: true,
                    ),

                    //
                    const SizedBox(height: 16),

                    // Alias
                    CustomTextInput(
                      labelText: traductions.compteDetailsPageListeAliasTitle,
                      controller: TextEditingController(
                        text: state.compteDetails.alias.cle,
                      ),
                      readOnly: true,
                    ),

                    // Si SHID
                    if (state.compteDetails.alias.shid != null) ...[
                      const SizedBox(height: 16),
                      CustomTextInput(
                        labelText: traductions.compteDetailsPageListeAliasTitle,
                        controller: TextEditingController(
                          text: state.compteDetails.alias.shid,
                        ),
                        readOnly: true,
                      ),
                    ]
                  ],
                ),

              if (state is GetCompteDetailsLoadingState)
                const CompteDetailsLoading()
            ],
          );
        },
      ),
    );
  }
}
