import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../modules/config/adapters/ui/bloc/config_bloc.dart';
import '../../modules/config/adapters/ui/bloc/config_state.dart';
import '../../modules/config/domain/models/config_keys.dart';

/// Pour afficher les montants dans l'app
/// Avec le bon formatage selon la langue de l'utilisateur
/// Et en mode floutté ou pas
class AmountWidget extends StatelessWidget {
  ///
  const AmountWidget({
    super.key,
    required this.montant,
    this.sign,
    this.prefixText,
    this.surfixText,
    this.style,
  });

  final double? montant;
  final String? sign;
  final String? prefixText;
  final String? surfixText;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // Initialize locale based on user's preference
    final String locale = Localizations.localeOf(context).toString();
    // Format without decimals
    final NumberFormat currency = NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: 0,
    );

    //
    ConfigBloc configBloc = context.read<ConfigBloc>();
    //
    return BlocBuilder<ConfigBloc, ConfigState>(
      bloc: configBloc,
      buildWhen: (previousState, currentState) {
        return previousState is ConfigLoadedState //
            &&
            currentState is ConfigLoadedState;
      },
      builder: (context, configState) {
        // Paramètre d'affichage du montant
        String? displayAmountParam = configState
            .configParams //
            .params[ConfigKey.displayAmount.code];
        bool displayAmount =
            displayAmountParam == null || displayAmountParam == "1"
                ? true
                : false;

        return Text(
          "${prefixText ?? ''} ${sign ?? ''} "
          "${currency.format(montant)} ${surfixText ?? ''}",
          style: displayAmount ? style : getHidedStyle(style),
        );
      },
    );
  }

  /// Style quand le montant est caché
  TextStyle getHidedStyle(TextStyle? style) {
    return TextStyle(
      color: Colors.transparent,
      fontSize: style!.fontSize,
      fontFamily: style.fontFamily,
      fontWeight: style.fontWeight,
      shadows: const [
        Shadow(color: Colors.grey, blurRadius: 37.0, offset: Offset(0, 0)),
        Shadow(color: Colors.grey, blurRadius: 37.0, offset: Offset(0, 0)),
        Shadow(color: Colors.grey, blurRadius: 37.0, offset: Offset(0, 0)),
        Shadow(color: Colors.grey, blurRadius: 37.0, offset: Offset(0, 0)),
      ],
    );
  }
}
