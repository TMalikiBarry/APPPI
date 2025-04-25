import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/assets.dart';
import '../../domain/models/categorie.dart';
import '../../domain/models/categorie_create_command.dart';
import '../../domain/models/categorie_update_command.dart';
import '../../ports/input/categorie_input_port.dart';
import 'categorie_event.dart';
import 'categorie_state.dart';

class CategorieBloc extends Bloc<CategorieEvent, CategorieState> {
  //
  final logger = Logger();

  /// Service
  final CategorieInputPort categorieInputPort;

  CategorieBloc(this.categorieInputPort) : super(CategorieInitialState([])) {
    // Pour recuperer la liste
    on<CategorieListEvent>(_onCategorieListEvent);
    on<CategorieListUpdatedEvent>(_onCategorieListUpdatedEvent);
    // Quand on veut ajouter une catégorie
    on<CategorieAddEvent>(_onCategorieAddEvent);
    // Quand on saisit le nom de la categorie à créer
    on<CategorieAddValidationEvent>(_onCategorieAddValidationEvent);
    //
    on<CategorieCreateEvent>(_onCategorieCreateEvent);
    //
    on<CategorieEditEvent>(_onCategorieEditEvent);
    on<CategorieEditValidationEvent>(_onCategorieEditValidationEvent);
    on<CategorieUpdateEvent>(_onCategorieUpdateEvent);
  }

  /// Recupere la lsite des categories personnalisées
  Future<void> _onCategorieListEvent(
    CategorieListEvent event,
    Emitter<CategorieState> emit,
  ) async {
    // Recupere la liste
    List<Categorie> categories = await categorieInputPort.list();
    emit(CategorieInitialState(categories));

    // Ecoute sur les MAj de la liste
    // Stream<List<Categorie>> stream = await categorieInputPort.stream();
    // stream.listen((data) {
    //   emit(CategorieInitialState(data));
    // });
  }

  /// A chaque fois que la liste des catégories est mise à jour
  Future<void> _onCategorieListUpdatedEvent(
    CategorieListUpdatedEvent event,
    Emitter<CategorieState> emit,
  ) async {
    emit(CategorieInitialState(event.categories));
  }

  /// Quand le nom de la catégorie est changée
  Future<void> _onCategorieAddEvent(
    CategorieAddEvent event,
    Emitter<CategorieState> emit,
  ) async {
    emit(CategorieCreationState(
      state.categories,
      CategorieCreateCommand(
        liste: state.categories,
        icon: Images.iconsAutre,
        color: 0xFFF9EBC2,
      ),
    ));
  }

  /// Quand le nom de la catégorie est changée
  Future<void> _onCategorieAddValidationEvent(
    CategorieAddValidationEvent event,
    Emitter<CategorieState> emit,
  ) async {
    CategorieCreateCommand form = event.command;
    form.isValid();
    emit(CategorieCreationState(state.categories, form));
  }

  /// Pour créer la categorie
  Future<void> _onCategorieCreateEvent(
    CategorieCreateEvent event,
    Emitter<CategorieState> emit,
  ) async {
    CategorieCreateCommand command = event.command;
    if (command.isValid()) {
      await categorieInputPort.create(command);
      add(CategorieListEvent());
    }
  }

  /// Quand on veut modifier une catégorie
  Future<void> _onCategorieEditEvent(
    CategorieEditEvent event,
    Emitter<CategorieState> emit,
  ) async {
    emit(CategorieEditState(
      state.categories,
      event.categorie,
      CategorieUpdateCommand(
        id: event.categorie.id,
        label: event.categorie.label,
        icon: event.categorie.icon,
        color: event.categorie.bgColor,
      ),
    ));
  }

  /// Quand le nom de la catégorie est changée
  Future<void> _onCategorieEditValidationEvent(
    CategorieEditValidationEvent event,
    Emitter<CategorieState> emit,
  ) async {
    CategorieUpdateCommand form = event.command;
    form.isValid();
    emit(CategorieEditState(state.categories, event.categorie, form));
  }

  /// Pour enregistrer la categorie
  Future<void> _onCategorieUpdateEvent(
    CategorieUpdateEvent event,
    Emitter<CategorieState> emit,
  ) async {
    CategorieUpdateCommand command = event.command;
    if (command.isValid()) {
      Categorie categorie = event.categorie;
      categorie.label = command.label!;
      categorie.icon = command.icon!;
      categorie.bgColor = command.color!;
      await categorieInputPort.update(categorie);
      add(CategorieListEvent());
    }
  }
}
