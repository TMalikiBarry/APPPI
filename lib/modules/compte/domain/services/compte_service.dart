import '../../ports/input/compte_input_port.dart';
import '../../ports/output/compte_output_port.dart';
import '../models/compte_details.dart';

class CompteService implements CompteInputPort {
  //
  /// Constructeur
  const CompteService(this.compteOutputPort);

  /// Port d'acces aux données des comptes
  final CompteOutputPort compteOutputPort;

  @override
  Future<double?> getSolde(String id) async {
    return compteOutputPort.getSolde(id);
  }

  @override
  Future<CompteDetails?> getDetails(String compte) async {
    return await compteOutputPort.getDetails(compte);
  }
}
