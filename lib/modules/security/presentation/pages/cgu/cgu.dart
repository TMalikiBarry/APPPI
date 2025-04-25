import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/my_page_container.dart';

/// Page d'affichage des conditions générales d'utilisation
class CguPage extends StatelessWidget {
  //
  const CguPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      "Conditions d'utilisation",
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
                    //
                    Text(
                      '''Les présentes conditions générales régissent votre utilisation de nos services. En accédant à nos services, vous acceptez de vous conformer à ces conditions.''',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    // Liste des conditions
                    for (var conditions in getConditions(context)) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${conditions['id']}.\t\t",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: Text(
                              "${conditions['message']}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
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
        "id": 1,
        "message":
            '''Services : Nous fournissons {décrivez les services que vous proposez}.''',
      },
      {
        "id": 2,
        "message":
            '''Comportement de l'utilisateur : Vous acceptez de n'utiliser nos services qu'à des fins légales et d'une manière qui ne porte pas atteinte aux droits d'un tiers, ni ne restreint ou empêche l'utilisation et la jouissance de nos services par un tiers.''',
      },
      {
        "id": 3,
        "message":
            '''Propriété intellectuelle : Tous les droits de propriété intellectuelle relatifs à nos services et au contenu fourni sur nos services nous appartiennent ou appartiennent à nos concédants de licence.''',
      },
      {
        "id": 4,
        "message":
            '''Exclusion de garantie : Nous ne garantissons pas que nos services seront ininterrompus ou exempts d'erreurs.''',
      },
      {
        "id": 5,
        "message":
            '''Limitation de responsabilité : Nous ne serons pas responsables des dommages résultant de l'utilisation de nos services ou liés à celle-ci.''',
      },
      {
        "id": 6,
        "message":
            '''Indemnisation : Vous acceptez de nous indemniser et de nous tenir à l'écart de toute réclamation, action, poursuite ou procédure, ainsi que de toute perte, responsabilité, dommage, coût et dépense (y compris les honoraires raisonnables d'avocat) découlant de votre utilisation de nos services ou en rapport avec celle-ci.''',
      },
      {
        "id": 7,
        "message":
            '''Modification des conditions : Nous nous réservons le droit de modifier les présentes conditions à tout moment.''',
      },
      {
        "id": 8,
        "message":
            '''Droit applicable : Les présentes conditions générales sont régies et interprétées conformément aux lois de {insérer la juridiction compétente}.''',
      }
    ];
  }
}
