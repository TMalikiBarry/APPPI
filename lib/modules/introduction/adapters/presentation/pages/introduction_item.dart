/// Un element de l'introduction contient une vidéo et un titre
class IntroductionItem {
  //
  // Constructor
  const IntroductionItem(this.video, this.legende, this.titre, this.position);

  // Chemin url de la vidéo
  final String video;

  // Titre de la vidéo
  final String legende;

  // Titre de la vidéo
  final String titre;

  // Position de la page de l'introduction
  final int position;
}
