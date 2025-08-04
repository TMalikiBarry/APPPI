import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/amount_widget.dart';
import '../../../../shared/widgets/skeleton_widget.dart';
import '../../../alias/domain/models/alias.dart';
import '../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../alias/presentation/bloc/alias_state.dart';
import '../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../config/adapters/ui/bloc/config_event.dart';
import '../../../config/adapters/ui/bloc/config_state.dart';
import '../../../config/domain/models/config_keys.dart';
import '../bloc/solde/solde_bloc.dart';
import '../bloc/solde/solde_event.dart';
import '../bloc/solde/solde_state.dart';

class SoldeWidget extends StatefulWidget {
  //
  const SoldeWidget({super.key});

  @override
  State<SoldeWidget> createState() => _SoldeWidgetState();
}

class _SoldeWidgetState extends State<SoldeWidget> {
  late CompteSoldeBloc compteSoldeBloc;

  @override
  void initState() {
    super.initState();

    // Compte numéro
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;

    // Compte solde bloc
    compteSoldeBloc = CompteSoldeBloc(Di.getCompteInputPort())
      ..add(GetSoldeCompteEvent(alias.compte));
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocProvider<CompteSoldeBloc>(
      create: (_) => compteSoldeBloc,
      child: BlocBuilder<ConfigBloc, ConfigState>(
        buildWhen: (previousState, currentState) {
          return currentState is ConfigLoadedState;
        },
        builder: (context, configState) {
          // Paramètre d'affichage de l'oeil
          String? hideEyeParam =
              configState.configParams.params[ConfigKey.hideEye.code];
          bool displayEye = hideEyeParam == "1" ? false : true;

          //
          return BlocBuilder<CompteSoldeBloc, CompteSoldeState>(
            bloc: context.read<CompteSoldeBloc>(),
            builder: (context, state) {
              //
              return InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Montant
                        if (state is CompteSoldeStateInitial) //
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: SkeletonWidget(height: 25, width: 150, isList: false),
                          ),

                        if (state is CompteSoldeDisplayState) //
                          AmountWidget(
                            montant: state.solde,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        //
                        if (displayEye) //state.eye
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: configState
                                .configParams
                                .params[ConfigKey.displayAmount.code] == "0" ? const Icon(Icons.visibility_outlined) : const Icon(Icons.visibility_off),
                            color: const Color(0xff615d52),
                            onPressed: () {
                              // Paramètre d'affichage du montant
                              String? displayAmountParam = configState
                                  .configParams
                                  .params[ConfigKey.displayAmount.code];
                              bool displayAmount =
                                  displayAmountParam == "1" ? true : false;
                              // Change param
                              context.read<ConfigBloc>().add(
                                    ConfigChangeEvent(
                                      ConfigKey.displayAmount,
                                      displayAmount ? "0" : "1",
                                    ),
                                  );
                            },
                          ),
                      ],
                    ),
                    // Titre du widget Solde
                    const SizedBox(height: 4),
                    Text(
                      traductions.homeSolde,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
