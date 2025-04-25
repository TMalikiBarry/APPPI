import '../../../core/storage.dart';
import '../domain/models/categorie.dart';

class CategorieOutputLocal {
  ///
  const CategorieOutputLocal();

  ///
  static const String collectionId = "categories";

  /// Ecoute sur les changements de la liste des categories
  Future<Stream<List<Categorie>>> stream() async {
    return await AppStorage.streamList(
      collectionId,
      Categorie.fromJson,
    );
  }

  /// Lister les categories à partir des données en local
  Future<List<Categorie>> list() async {
    //
    return await AppStorage.list<Categorie>(
      collectionId,
      (json) => Categorie.fromJson(json),
    );
  }

  /// Enregistre une categorie dans la base locale
  Future<void> save(Categorie categorie) async {
    await AppStorage.save(
      collectionId,
      categorie.id,
      categorie.toJson(),
    );
  }
}
