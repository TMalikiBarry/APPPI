import '../../ports/input/categorie_input_port.dart';
import '../../ports/output/categorie_output_port.dart';
import '../models/categorie.dart';
import '../models/categorie_create_command.dart';

class CategorieService implements CategorieInputPort {
  //
  final CategorieOutputPort categorieOutputPort;

  ///
  CategorieService(this.categorieOutputPort);

  @override
  Future<Categorie> create(CategorieCreateCommand command) async {
    // define Id
    String id = command.label!.replaceAll(RegExp(r"\s+"), "");

    //
    Categorie categorie = Categorie(
      id: id,
      label: command.label!,
      icon: command.icon!,
      bgColor: command.color,
    );
    //
    await categorieOutputPort.save(categorie);
    return categorie;
  }

  @override
  Future<Stream<List<Categorie>>> stream() async {
    Stream<List<Categorie>> result = await categorieOutputPort.stream();
    return result.map((categories) {
      // Trier par le nom
      categories.sort((a, b) => b.label.compareTo(a.label));
      return categories;
    });
  }

  @override
  Future<List<Categorie>> list() async {
    List<Categorie> categories = await categorieOutputPort.list();
    categories.sort((a, b) => b.label.compareTo(a.label));
    return categories;
  }

  @override
  Future<Categorie> update(Categorie categorie) async {
    await categorieOutputPort.save(categorie);
    return categorie;
  }
}
