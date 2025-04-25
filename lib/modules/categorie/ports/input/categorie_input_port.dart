import '../../domain/models/categorie.dart';
import '../../domain/models/categorie_create_command.dart';

abstract class CategorieInputPort {
  /// Lister des categories
  Future<List<Categorie>> list();

  /// Ecouter sur les MAJ de la liste des categories
  Future<Stream<List<Categorie>>> stream();

  /// Créer une categorie
  Future<Categorie> create(CategorieCreateCommand categorie);

  /// Modifier une categorie
  Future<Categorie> update(Categorie categorie);
}
