import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import 'package:pi_mobile_app/modules/categorie/presentation/pages/categorie_edit_icon_btn.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../shared/widgets/input_text.dart';
import '../../domain/models/categorie.dart';
import '../../domain/models/categorie_create_command.dart';
import '../bloc/categorie_bloc.dart';
import '../bloc/categorie_event.dart';
import '../bloc/categorie_state.dart';

class CategorieAddPage extends StatelessWidget {
  ///
  const CategorieAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    final categorieBloc = context.read<CategorieBloc>();
    CategorieCreateCommand command =
        (categorieBloc.state as CategorieCreationState).command;

    return BlocConsumer<CategorieBloc, CategorieState>(
      bloc: categorieBloc,
      listener: (context, state) async {
        if (state is CategorieInitialState) {
          AppRouter.pop(context);
        }
      },
      builder: (context, state) {
        TextEditingController? controller;
        if (state is CategorieCreationState) {
          controller = TextEditingController(text: state.command.label);
          controller.selection = TextSelection.fromPosition(TextPosition(
            offset: controller.text.length,
          ));
        }

        return Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back button
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    onPressed: () {
                      context.read<CategorieBloc>().add(CategorieListEvent());
                    },
                  ),
                ],
              ),
              // Icon categorie and title
              Container(
                height: 200,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon
                    const Align(
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage(Images.categorie,package: 'common_dependencies'),
                        width: 128,
                      ),
                    ),
                    // Title and edit icon btn
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          traductions.categorieCustomAdd,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        // Edit icon
                        const CategorieEditIconBtn(),
                      ],
                    )
                  ],
                ),
              ),
              // Formulaire
              Expanded(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Input Name
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: CustomTextInput(
                            labelText: traductions.categorieFormNameLabel,
                            controller: controller,
                            // Message d'erreur à afficher
                            messageError: command.error != null
                                ? command.error ==
                                        CategorieCreateCommandError.invalid
                                    ? traductions.categorieFormNameInvalid
                                    : traductions.categorieFormNameAlready
                                : "",
                            // Quand le texte change
                            onChange: (value) {
                              command.label = value;
                              categorieBloc
                                  .add(CategorieAddValidationEvent(command));
                            },
                          ),
                        ),
                        // Suggested categories
                        Wrap(
                          spacing: 8,
                          children:
                              Categorie.suggested.map<Widget>((categorie) {
                            return ActionChip(
                              label: Text(categorie.label),
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor,
                              onPressed: () {
                                // create with name
                                command.label = categorie.label;
                                command.icon = categorie.icon;
                                command.color = categorie.bgColor;
                                categorieBloc
                                    .add(CategorieAddValidationEvent(command));
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Btn create
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    if (command.isValid()) {
                      context
                          .read<CategorieBloc>()
                          .add(CategorieCreateEvent(command));
                    }
                  },
                  child: Text(traductions.categorieFormCreateBtn),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
