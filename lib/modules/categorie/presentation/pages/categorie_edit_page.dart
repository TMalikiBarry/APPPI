import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../core/router.dart';
import '../../../../shared/widgets/input_text.dart';
import '../../domain/models/categorie.dart';
import '../../domain/models/categorie_update_command.dart';
import '../bloc/categorie_bloc.dart';
import '../bloc/categorie_event.dart';
import '../bloc/categorie_state.dart';
import 'categorie_edit_icon_btn.dart';

class CategorieEditPage extends StatelessWidget {
  ///
  const CategorieEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    final categorieBloc = context.read<CategorieBloc>();
    CategorieEditState editState = (categorieBloc.state as CategorieEditState);
    Categorie categorie = editState.categorie;
    CategorieUpdateCommand command = editState.command;

    return BlocConsumer<CategorieBloc, CategorieState>(
      bloc: categorieBloc,
      listener: (context, state) async {
        if (state is CategorieInitialState) {
          AppRouter.pop(context);
        }
      },
      builder: (context, state) {
        TextEditingController? controller = TextEditingController(
          text: command.label,
        );
        controller.selection = TextSelection.fromPosition(TextPosition(
          offset: controller.text.length,
        ));

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
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(command.color!),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: command.icon!.startsWith("assets")
                            ? Image(
                                image: AssetImage(command.icon!),
                                width: 96,
                              )
                            : Text(
                                command.icon!,
                                style: const TextStyle(fontSize: 64),
                              ),
                      ),

                      // child: Image(
                      //   image: AssetImage(categorie.icon),
                      //   width: 128,
                      // ),
                    ),
                    // Title and edit icon btn
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categorie.label,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
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
                            messageError: command.error != null &&
                                    command.error ==
                                        CategorieUpdateCommandError.invalid
                                ? traductions.categorieFormNameInvalid
                                : "",
                            // Quand le texte change
                            onChange: (value) {
                              command.label = value;
                              categorieBloc.add(CategorieEditValidationEvent(
                                command,
                                editState.categorie,
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Btn update
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    if (command.isValid()) {
                      context
                          .read<CategorieBloc>()
                          .add(CategorieUpdateEvent(command, categorie));
                    }
                  },
                  child: Text(traductions.categorieFormSaveBtn),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
