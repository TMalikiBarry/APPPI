import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common_dependencies/components/emvqrcode.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../core/di.dart';
import '../../../../core/router.dart';
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

class SoldeWidget_OLD extends StatefulWidget {
  const SoldeWidget_OLD({super.key});

  @override
  State<SoldeWidget_OLD> createState() => _SoldeWidget_OLDState();
}

class _SoldeWidget_OLDState extends State<SoldeWidget_OLD> {
  late CompteSoldeBloc compteSoldeBloc;
  String? _qrData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Initialisation du CompteSoldeBloc
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    compteSoldeBloc = CompteSoldeBloc(Di.getCompteInputPort())
      ..add(GetSoldeCompteEvent(alias.compte));

    // Génération QR initiale
    _generateQr();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _generateQr());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _generateQr() async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String encodedTs = base64Encode(utf8.encode(timestamp));
    final qrData = await CPMService().generateQr(encodedTs, "123456");
    setState(() => _qrData = qrData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompteSoldeBloc>.value(
      value: compteSoldeBloc,
      child: BlocBuilder<ConfigBloc, ConfigState>(
        buildWhen: (previous, current) => current is ConfigLoadedState,
        builder: (context, configState) {
          // Lecture du paramètre de visibilité du solde
          final displayAmount = configState.configParams.params[ConfigKey.displayAmount.code] == "1";
          final hideEye = configState.configParams.params[ConfigKey.hideEye.code] == "1";

          return BlocBuilder<CompteSoldeBloc, CompteSoldeState>(
            builder: (context, state) {
              Widget montantWidget;

              if (!displayAmount) {
                montantWidget = Text(
                  "••••••",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              } else if (state is CompteSoldeDisplayState) {
                final formatted = NumberFormat.currency(
                  locale: 'fr_SN',
                  symbol: 'F',
                  decimalDigits: 0,
                ).format(state.solde);

                montantWidget = Text(
                  formatted,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              } else {
                montantWidget = const SkeletonWidget(height: 28, width: 100);
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/figma_hp_banderole.png',
                      package: 'common_dependencies',
                    ),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Zone gauche : Texte et solde
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.homeSolde,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              montantWidget,
                              if (!hideEye)
                                IconButton(
                                  icon: Icon(
                                    displayAmount
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  onPressed: () {
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
                        ],
                      ),
                    ),

                    // Zone droite : QR Code cliquable
                    InkWell(
                      onTap: () {
                        final currentValue = configState
                            .configParams.params[ConfigKey.showQRcode.code];
                        AppRouter.push(
                          context,
                          (currentValue != null && currentValue == "1")
                              ? AppRouter.qrcodeShow
                              : AppRouter.qrcodeScan,
                        );
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _qrData != null
                            ? PrettyQr(
                          data: _qrData!,
                          size: 56,
                          roundEdges: true,
                          elementColor:
                          Theme.of(context).colorScheme.primary,
                        )
                            : const SizedBox(),
                      ),
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

/*class SoldeWidget extends StatefulWidget {
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
                            child: SkeletonWidget(height: 25, width: 150),
                          ),

                        if (state is CompteSoldeDisplayState) //
                          AmountWidget(
                            montant: state.solde,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        //
                        if (displayEye) //state.eye
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined),
                            //size: 18,
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
}*/
