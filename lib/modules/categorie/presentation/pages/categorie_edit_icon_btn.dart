import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../shared/widgets/menu_actions_widget.dart';
import '../../domain/models/categorie.dart';
import '../../domain/models/categorie_create_command.dart';
import '../../domain/models/categorie_update_command.dart';
import '../bloc/categorie_bloc.dart';
import '../bloc/categorie_event.dart';
import '../bloc/categorie_state.dart';
import 'categorie_edit_icon_emoji.dart';

class CategorieEditIconBtn extends StatelessWidget {
  const CategorieEditIconBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      heroTag: "icon",
      child: Image.asset(
        Images.categorieImageSelect,
        width: 24,
        height: 24,
        package: 'common_dependencies'
      ),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return const CategorieEditIconOptions();
          },
          isScrollControlled: true,
        );
      },
    );
  }
}

/// Bottom Sheet Options Edit Icon
class CategorieEditIconOptions extends StatelessWidget {
  const CategorieEditIconOptions({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    final categorieBloc = context.read<CategorieBloc>();

    CategorieCreationState? creationState =
        categorieBloc.state is CategorieCreationState
            ? (categorieBloc.state as CategorieCreationState)
            : null;
    CategorieEditState? editState = categorieBloc.state is CategorieEditState
        ? (categorieBloc.state as CategorieEditState)
        : null;
    //
    return SizedBox(
      height: 224, // 296,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              //
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  traductions.categorieFormIconSheetTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              //
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuActionsWiget(
                      items: [
                        // Emoji
                        MenuActionItem(
                          Images.categorieIconEmoji,
                          traductions.categorieFormIconSheetEmojiTitle,
                          null,
                          () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return CategorieEditIconEmoji(
                                  icon: creationState != null
                                      ? creationState.command.icon!
                                      : editState!.command.icon!,
                                  color: creationState != null
                                      ? creationState.command.color!
                                      : editState!.command.color!,
                                );
                              },
                              isScrollControlled: true,
                            ).then((value) {
                              if (value != null && creationState != null) {
                                CategorieCreateCommand command =
                                    creationState.command;
                                command.iconType = CategorieIconType.emoji;
                                command.icon = value["emoji"];
                                command.color = value["color"];
                                categorieBloc.add(CategorieAddValidationEvent(
                                  command,
                                ));
                                AppRouter.pop(context);
                              }
                              if (value != null && editState != null) {
                                CategorieUpdateCommand command =
                                    editState.command;
                                command.iconType = CategorieIconType.emoji;
                                command.icon = value["emoji"];
                                command.color = value["color"];
                                categorieBloc.add(CategorieEditValidationEvent(
                                  command,
                                  editState.categorie,
                                ));
                                AppRouter.pop(context);
                              }
                            });
                          },
                          iconSize: 20,
                        ),
                        // Chosir dans la Galerie
                        MenuActionItem(
                          Images.categorieImageSelect,
                          traductions.categorieFormIconSheetGalleryTitle,
                          null,
                          () => "",
                          iconSize: 20,
                        ),
                        // Prendre une Photo
                        // MenuActionItem(
                        //   Images.categorieIconPhoto,
                        //   traductions.categorieFormIconSheetPhotoTitle,
                        //   null,
                        //   () => "",
                        //   iconSize: 20,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
