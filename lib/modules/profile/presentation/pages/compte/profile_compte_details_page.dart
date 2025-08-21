import 'package:flutter/material.dart';

import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../alias/presentation/pages/alias_delete_btn_widget.dart';
import '../../../../compte/presentation/pages/compte_details_widget.dart';

class ProfileCompteDetailsPage extends StatelessWidget {
  ///
  const ProfileCompteDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),
      // Contenu de la page de connexion
      body: const MyPageContainer(
        child: CompteDetailsWidget(),
      ),

      // Boutton supprimer alias
      //bottomNavigationBar: const AliasDeleteBtnWidget(),
    );
  }
}
