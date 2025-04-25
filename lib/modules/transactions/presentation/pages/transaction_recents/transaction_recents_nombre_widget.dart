import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/number_inc_widget.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/domain/models/config_keys.dart';


class TransactionRecentsNombreWidget extends StatefulWidget {
  const TransactionRecentsNombreWidget({
    super.key,
  });
  @override
  State<TransactionRecentsNombreWidget> createState() =>
      _TransactionRecentsWidgetState();
}

class _TransactionRecentsWidgetState 
  extends State<TransactionRecentsNombreWidget> {
  
  late ConfigBloc configBloc;
  late int updatedNbItems;
  late int nbItems;

  @override
  void initState() {
    super.initState();
    configBloc = context.read<ConfigBloc>();
    String? nbItemsParam = configBloc.getParamValue(
      ConfigKey.transactionsRecentNbItems
    );
    //
    nbItems = nbItemsParam != null ? int.parse(nbItemsParam) : 3;
    //
    updatedNbItems = nbItems;
  }

  @override
  Widget build(BuildContext context) {

    AppLocalizations traductions = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:  MediaQuery.of(context).size.height * 0.5,
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  traductions.homeTransactionsRecentsNombreTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                //
                const SizedBox(height: 10,),
                /// Sous titre
                Text(
                  traductions.homeTransactionsRecentsNombreSubTitle,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                //
                const SizedBox(height: 32.0,),
                /// Bouton reduire et augmenter
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 15),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //
                        Expanded(
                          child: Text(
                            traductions.homeTransactions,
                            style: Theme.of(context)
                              .textTheme.headlineSmall,
                          ),
                        ),
                        //
                        NumberIncWidget(
                          min: 3,
                          max: 10,
                          number: updatedNbItems,
                          onChange: (value) => setState(() {
                            updatedNbItems = value;
                          }),
                        ),
                      ],
                    ),
                  ),
                ),

                //
                const SizedBox(height: 24.0,),

                /// Enregistrer
                ElevatedButton(
                  onPressed: updatedNbItems != nbItems ?
                  () {
                    configBloc.add(ConfigChangeEvent(
                      ConfigKey.transactionsRecentNbItems, 
                      updatedNbItems.toString()
                    ));
                    AppRouter.pop(context);
                  }
                  : null,
                  child: Text(
                    traductions.homeTransactionsRecentsNombreBtnSave,)
                ),

                const SizedBox(height: 10.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}