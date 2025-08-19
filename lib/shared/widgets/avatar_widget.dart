import 'package:flutter/material.dart';


class AvatarWidget extends StatelessWidget {
  ///
  const AvatarWidget({
    super.key,
    required this.nom,
    this.photo,
    required this.rounded,
  });

  final String nom;
  final String? photo;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    // Si l'image de l'avatar n'est pas fourni, utiliser les initiales du nom
    ShapeDecoration boxDecoration;
    RoundedRectangleBorder border = rounded
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          )
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          );

    Widget? child;
    if (photo != null) {
      boxDecoration = ShapeDecoration(
        color: Colors.transparent,
        shape: border,
        image: DecorationImage(
          image: NetworkImage(photo!),
          fit: BoxFit.fill,
        ),
      );
      // Affiche que l'image
      child = null;
    } else {
      boxDecoration = ShapeDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: border,
      );
      // Affiche les initiales
      child = Center(child: Text(getInitials(nom)));
    }
    // Retourne l'avatar
    return Container(
      width: 64,
      height: 64,
      decoration: boxDecoration,
      child: child,
    );
  }

  String getInitials(String fullName) {
    List<String> names = fullName.split(" ");
    String initials = "";

    if (names.isNotEmpty && names[0].isNotEmpty) {
      // Prend la première lettre de chaque mot dans le nom
      initials += names[0][0].toUpperCase();

      if (names.length > 1) {
        // Ajoute la première lettre du dernier mot si le nom a plus d'un mot
        initials += names.last[0].toUpperCase();
      }
    }

    return initials;
  }
}
