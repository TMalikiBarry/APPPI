import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/my_page_container.dart';

/// Page d'affichage de la politique de confidentialité
class PocPage extends StatelessWidget {
  //
  const PocPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return MyPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButton(
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Politique de confidentialité",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Dernière mise à jour, 27-04-2022",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    //
                    Text(
                      '''Nous nous engageons à protéger la vie privée de nos utilisateurs. La présente politique de confidentialité décrit les types d'informations personnelles que nous recueillons, l'usage que nous en faisons et la manière dont nous les protégeons.''',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    // Liste des politiques
                    for (var conditions in getConditions(context)) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${conditions['title']}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "${conditions['message']}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                    const SizedBox(
                      height: 27,
                    ),

                    // Boutton confimer
                    ElevatedButton(
                      onPressed: () {
                        context.pop({"confirmation": true});
                      },
                      child: const Text("Confirmer"),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> getConditions(context) {
    return [
      {
        "title": "Informations que nous collectons",
        "message":
            '''Nous recueillons des informations personnelles, telles que le nom et l'adresse électronique, lorsque vous nous les fournissez volontairement.''',
      },
      {
        "title": "Comment nous utilisons vos informations",
        "message":
            '''Nous utilisons vos informations personnelles pour communiquer avec vous au sujet de nos produits et services, et pour améliorer notre application et l'expérience des utilisateurs.''',
      },
      {
        "title": "Comment nous protégeons vos informations",
        "message":
            '''Nous prenons des mesures raisonnables pour protéger vos informations personnelles contre tout accès non autorisé, toute divulgation ou toute utilisation abusive.''',
      },
      {
        "title": "Divulgation à des tiers",
        "message":
            '''Nous ne vendons pas, n'échangeons pas et ne transférons pas vos informations personnelles à des tiers.''',
      },
      {
        "title": "Contactez nous",
        "message":
            '''Si vous avez des questions ou des préoccupations concernant notre politique de protection de la vie privée, veuillez nous contacter.''',
      },
    ];
  }
}
