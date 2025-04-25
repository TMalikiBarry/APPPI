import '../../domain/models/categorie.dart';

abstract class CategorieOutputPort {
  /// Lister les categories
  Future<List<Categorie>> list();

  /// Lister les categories
  Future<Stream<List<Categorie>>> stream();

  /// Enregistrer une categorie
  Future<void> save(Categorie categorie);
}
