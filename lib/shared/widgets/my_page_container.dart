import 'package:flutter/widgets.dart';

/// Conteneur personnalisé utilisé pour les pages
class MyPageContainer extends StatelessWidget {
  final Widget child;

  /// Le padding est le même pour toutes les pages
  const MyPageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }
}
