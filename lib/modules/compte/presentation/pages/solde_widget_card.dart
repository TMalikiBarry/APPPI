import 'dart:async';
import 'dart:convert';

import 'package:common_dependencies/components/emvqrcode.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/core/router.dart';

import '../../../../core/di.dart';
import '../../../../core/theme.dart';
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

class SoldeWidgetCard extends StatefulWidget {
  const SoldeWidgetCard({super.key});

  @override
  State<SoldeWidgetCard> createState() => _SoldeWidgetCardState();
}

class _SoldeWidgetCardState extends State<SoldeWidgetCard> {
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
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocProvider<CompteSoldeBloc>.value(
      value: compteSoldeBloc,
      child: BlocBuilder<ConfigBloc, ConfigState>(
        buildWhen: (previousState, currentState) =>
        currentState is ConfigLoadedState,
        builder: (context, configState) {
          String? hideEyeParam =
          configState.configParams.params[ConfigKey.hideEye.code];
          bool displayEye = hideEyeParam != "1";

          return BlocBuilder<CompteSoldeBloc, CompteSoldeState>(
            builder: (context, state) {
              return Container(
                //margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F296A),
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/figma_hp_banderole.png',
                    package: 'common_dependencies'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              traductions.homeSolde,
                              style: const TextStyle(color: Colors.white70),
                            ),),
                            //const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (state is CompteSoldeStateInitial)
                                  const SkeletonWidget(height: 25, width: 150),
                                if (state is CompteSoldeDisplayState)
                                  AmountWidget(
                                    montant: state.solde,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                if (displayEye)
                                  IconButton(
                                    icon: const Icon(Icons.visibility_outlined),
                                    color: Colors.white70,
                                    onPressed: () {
                                      String? displayAmountParam = configState
                                          .configParams
                                          .params[ConfigKey.displayAmount.code];
                                      bool displayAmount =
                                          displayAmountParam == "1";
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
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xffbbc0fb),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: GestureDetector(
                            child:  _qrData != null
                                ? PrettyQr(
                              data: _qrData!,
                              size: 56,
                              roundEdges: true,
                              elementColor: Themer.brownColor,
                            )
                                : Image.asset(
                              "assets/images/qr_home.png",
                              package: 'common_dependencies',
                              width: 45,  // Ajusté pour correspondre aux autres icônes
                              height: 45, // Ajusté pour correspondre aux autres icônes
                              fit: BoxFit.contain,
                            ),
                            onTap: () {
                              ConfigState configState = context.read<ConfigBloc>().state;
                              String? currentValue = configState.configParams
                                  .params[ConfigKey.showQRcode.code];
                              AppRouter.push(
                                context,
                                currentValue != null && currentValue == "1"
                                    ? AppRouter.qrcodeScan
                                    : AppRouter.qrcodeShow,
                              );
                            },
                          )
                        ),
                      ],
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
