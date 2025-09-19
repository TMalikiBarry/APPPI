import 'package:flutter/material.dart';

class AvatarCircleWidget extends StatelessWidget {
  ///
  const AvatarCircleWidget({
    super.key,
    required this.nom,
    this.photo,
    this.radius,
    required this.rounded,
  });

  final String nom;
  final String? photo;
  final double? radius;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    if (photo != null) {
      return CircleAvatar(
        backgroundImage: photo!.startsWith("http")
            ? NetworkImage(photo!)
            : AssetImage(photo!,package: 'common_dependencies') as ImageProvider,
        radius: radius ?? 22,
      );
    } //
    else {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        radius: radius ?? 22,
        child: Text(
          getInitials(nom),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }
  }

  String getInitials(String fullName) {
    List<String> names = fullName.split(" ");
    String initials = "";

    if (names.isNotEmpty && names[0].isNotEmpty) {
      // Prend la première lettre de chaque mot dans le nom
      initials += names[0][0].toUpperCase();

      if (names.length > 1) {
        // Ajoute la première lettre du dernier mot si le nom a plus d'un mot
        initials += names.last.isNotEmpty ? names.last[0].toUpperCase() : "";
      }
    }

    return initials;
  }
}
