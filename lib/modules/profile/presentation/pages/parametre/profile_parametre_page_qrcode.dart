import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';

class ProfileParametrePageQRcode extends StatelessWidget {
  const ProfileParametrePageQRcode({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocBuilder<ConfigBloc, ConfigState>(
      buildWhen: (previousState, currentState) {
        return currentState is ConfigLoadedState &&
            currentState.updatedKey == ConfigKey.showQRcode;
      },
      builder: (context, configState) {
        //
        String? currentValue =
            configState.configParams.params[ConfigKey.showQRcode.code];
        bool showQRcode = currentValue != null && currentValue == "1";
        //
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
              minWidth: MediaQuery.of(context).size.width),
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
                      traductions.appSettingPageMenuQrCodeTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    // Séparateur
                    const SizedBox(height: 8.0),

                    // Sous titre de la page
                    Text(
                      showQRcode
                          ? traductions.appSettingPageMenuQrCodeDeselectTitle
                          : traductions.appSettingPageMenuQrCodeSelectTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    //
                    const SizedBox(height: 15),
                    //
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: _leading(context, Images.homeFooterQrcode),
                          title: _title(context,
                              traductions.appSettingPageMenuQrCodeTitle),
                          trailing: Switch(
                            value: showQRcode,
                            onChanged: (value) =>
                                context.read<ConfigBloc>().add(
                                      ConfigChangeEvent(
                                        ConfigKey.showQRcode,
                                        showQRcode ? "0" : "1",
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _leading(BuildContext context, String icon) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(14.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ImageIcon(
          AssetImage(icon,package: 'common_dependencies'),
          color: Theme.of(context).colorScheme.onSurface,
          size: 30,
        ),
      ),
    );
  }

  Text _title(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
