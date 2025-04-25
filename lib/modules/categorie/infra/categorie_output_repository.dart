import '../domain/models/categorie.dart';
import '../ports/output/categorie_output_port.dart';
import 'categorie_output_local.dart';

/// Offline repository only
class CategorieOutputRepository implements CategorieOutputPort {
  final CategorieOutputLocal repoLocal = const CategorieOutputLocal();

  @override
  Future<List<Categorie>> list() {
    return repoLocal.list();
  }

  @override
  Future<Stream<List<Categorie>>> stream() async {
    return await repoLocal.stream();
  }

  @override
  Future<void> save(Categorie categorie) async {
    await repoLocal.save(categorie);
  }
}
