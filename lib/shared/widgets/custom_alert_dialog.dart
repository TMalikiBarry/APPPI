import 'package:flutter/material.dart';
import '../../core/router.dart';
import '../../core/theme.dart';

/// Affichage d'une demande de confirmation
/// quand l'utilisateur veut effectuer une action sensible
/// Par exemple Déconnexion
class CustomAlertDialog extends StatelessWidget {
  //
  final String title;
  final String description;
  final String confirmBtnText;
  final Function() confirmBtnAction;
  final String? cancelBtnText;
  final Function()? cancelBtnAction;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmBtnText,
    required this.confirmBtnAction,
    this.cancelBtnText,
    this.cancelBtnAction,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
      insetPadding: const EdgeInsets.fromLTRB(55.0, 0.0, 55.0, 00.0),
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // title
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 15),

            // description
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  . //
                  copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),

            const Divider(),

            // Confirm btn
            TextButton(
              onPressed: confirmBtnAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              ),
              child: Text(
                confirmBtnText,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?. //
                    copyWith(
                      color: Themer.systemErrorColor,
                    ),
              ),
            ),

            if (cancelBtnText != null) const Divider(),

            if (cancelBtnText != null)
              // Cancel btn
              TextButton(
                onPressed: cancelBtnAction ??
                    () {
                      AppRouter.pop(context);
                    },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                ),
                child: Text(
                  cancelBtnText!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Themer.systemBlueColor,
                      ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
