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
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
      insetPadding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 00.0),
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

            //const Divider(),
            const SizedBox(height: 15),
            // Confirm btn
            ElevatedButton(
              onPressed: confirmBtnAction,
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF93832), width: 2),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                confirmBtnText,
                style: TextStyle(color: Color(0xFFF93832)),
              ),
            ),
            SizedBox(height: 10),

            if (cancelBtnText != null)
            // Cancel btn
            ElevatedButton(
              onPressed: cancelBtnAction ??
                      () {
                    AppRouter.pop(context);
                  },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD0D5DD), width: 2),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                cancelBtnText!,
                style: TextStyle(color: Color(0xFF344054)),
              ),
            ),

           // if (cancelBtnText != null) const Divider(),
          ],
        ),
      ],
    );
  }
}
