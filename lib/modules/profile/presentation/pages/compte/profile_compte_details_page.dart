import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../alias/presentation/pages/alias_delete_btn_widget.dart';
import '../../../../compte/presentation/pages/compte_details_widget.dart';

class ProfileCompteDetailsPage extends StatefulWidget {
  ///
  const ProfileCompteDetailsPage({super.key});

  @override
  State<ProfileCompteDetailsPage> createState() => _ProfileCompteDetailsPageState();
}

class _ProfileCompteDetailsPageState extends State<ProfileCompteDetailsPage> {
  String? whichCountry;
  bool isLoading = true;

  init() async {
    var pref = await SharedPreferences.getInstance();
    whichCountry = pref.getString('countryCode') ?? "SN";
    print("whichCountry : $whichCountry");
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

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
      bottomNavigationBar: isLoading ? null : whichCountry == "CI"
        ? null
        : const AliasDeleteBtnWidget(),
    );
  }
}
