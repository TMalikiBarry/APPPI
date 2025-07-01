import 'package:flutter/material.dart';
import '../../core/assets.dart';
import '../../core/router.dart';

/// Page Loading de l'app
class LoadingPage extends StatelessWidget {
  //
  final Color? bgColor;

  const LoadingPage({super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: bgColor ?? Colors.transparent,
      child: Center(
        child: Image.asset(
          Images.gifLogoLoading,
          width: 100,
          height: 100,
          package: 'common_dependencies'
        ),
      ),
    );
  }
}

class CustomLoadingDialog {
  /// Affiche le loader
  static void show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const LoadingPage();
      },
    );
  }

  /// Cache le loader
  static void hide(BuildContext context) {
    AppRouter.pop(context);
  }
}
