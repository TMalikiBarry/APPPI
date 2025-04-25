import 'package:flutter/material.dart';

import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../compte/presentation/pages/compte_client_widget.dart';

class ProfileCompteClientPage extends StatelessWidget {
  //
  const ProfileCompteClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),
      // Contenu de la page de connexion
      body: const MyPageContainer(
        child: CompteClientWidget(),
      ),
    );
  }
}
