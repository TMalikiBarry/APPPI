import 'package:flutter/material.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../../../shared/widgets/my_page_container.dart';

class SubscriptionDetailsPageNoteSheet extends StatefulWidget {
  const SubscriptionDetailsPageNoteSheet({super.key, this.note});

  final String? note;

  @override
  SubscriptionDetailsPageNoteSheetState createState() =>
      SubscriptionDetailsPageNoteSheetState();
}

class SubscriptionDetailsPageNoteSheetState
    extends State<SubscriptionDetailsPageNoteSheet> {
  late double maxHeight;
  double minHeight = 0.0;

  TextEditingController noteCtrl = TextEditingController();

  FocusNode noteFocus = FocusNode();

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) noteCtrl.text = widget.note!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maxHeight = MediaQuery.of(context).size.height * 0.7;
    noteFocus.addListener(() {
      setState(() {
        minHeight = noteFocus.hasFocus ? maxHeight : 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: maxHeight,
          minHeight: minHeight,
          minWidth: MediaQuery.of(context).size.width),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MyPageContainer(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      traductions.transactionFormMotifLabel,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    //
                    const SizedBox(height: 15),
                    //
                    CustomTextInput(
                      controller: noteCtrl,
                      focus: noteFocus,
                      labelText: traductions.transactionFormMotifHint,
                      // Message d'erreur à afficher
                      messageError: null,
                      // Quand le texte change
                      onChange: (value) {
                        setState(() {
                          isFormValid = noteCtrl.text.isNotEmpty &&
                              noteCtrl.text != widget.note;
                        });
                      },
                    ),
                    // Btn
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed:
                            isFormValid ? () => _saveNote(noteCtrl.text) : null,
                        child: Text(traductions.btnTextSave),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveNote(String note) {
    AppRouter.pop(context, value: note);
  }
}
