import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/domain/models/config_keys.dart';
import 'introduction_item.dart';

class IntroductionFooter extends StatelessWidget {
  //
  final IntroductionItem item;
  final int pageSize;
  final AppLocalizations traductions;

  ///
  const IntroductionFooter({
    super.key, //
    required this.item, //
    required this.pageSize, //
    required this.traductions, //
  });

  ///
  @override
  Widget build(BuildContext context) {
    if (item.position == pageSize - 1) {
      return ElevatedButton(
        onPressed: () {
          context
              .read<ConfigBloc>()
              .add(const ConfigChangeEvent(ConfigKey.introductionPassed, "1"));
          AppRouter.pushReplacement(context, AppRouter.login);
        },
        child: SizedBox(
          height: 60,
          child: Center(
            child: Text(
              traductions.introductionLogin,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            traductions.introductionFooterTitle,
            style: Theme.of(context)
                .textTheme //
                .bodyLarge
                ?.copyWith(
                  color: Themer.whiteColor,
                ),
          ),
          const SizedBox(height: 5.0),
          Text(
            traductions.introductionFooterSubtitle,
            style: Theme.of(context)
                .textTheme //
                .bodyLarge
                ?.copyWith(
                  color: Themer.amberColor,
                ),
          )
        ],
      );
    }
  }
}
