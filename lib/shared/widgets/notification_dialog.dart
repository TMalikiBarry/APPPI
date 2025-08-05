import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/assets.dart';
import '../../core/router.dart';

/// Affichage des dialogues de notifications de succes ou erreur
enum NotificationType { success, error, info, other }

class NotificationBtn {
  final String btnText;
  final Color? btnColor;
  final Function()? btnAction;

  NotificationBtn({
    this.btnAction,
    this.btnColor,
    required this.btnText,
  });
}

class NotificationDialog extends StatelessWidget {
  //
  final NotificationType type;
  final String? message;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? btnText;
  final Color? btnColor;
  final Function()? btnAction;
  final List<NotificationBtn>? btns;
  final bool isFullScreen;

  const NotificationDialog({
    super.key,
    required this.type,
    this.message,
    this.title,
    this.subtitle,
    this.description,
    this.btnText,
    this.btnAction,
    this.btnColor,
    this.btns,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).copyWith().size;
    String? image;
    if (type == NotificationType.success) {
      image = Images.success;
    } else if (type == NotificationType.error) {
      image = Images.error;
    } else if (type == NotificationType.info) {
      image = Images.info;
    }
    var height = isFullScreen ? size.height : (description != null ? size.height * 0.6 : size.height * 0.4);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35.0),
        ),
      ),
      padding: const EdgeInsets.all(16),
      height: height,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (image != null)
                Center(
                  child: Image.asset(
                      image,
                      width: 100,
                      height: 100,
                      package: 'common_dependencies'
                  ),
                ),
              if (image != null) const SizedBox(height: 32),
              // Text message
              if (message != null) ...[
                Center(
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Title message
              if (title != null) ...[
                Center(
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 15),
              ],

              // Subtitle message
              if (subtitle != null) ...[
                Center(
                  child: Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 15),
              ],

              // Description
              if (description != null) ...[
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: isFullScreen ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 24),
              ],

              // Continue btn
              if (btnText != null)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(btnColor),
                  ),
                  onPressed: btnAction ??
                          () {
                        AppRouter.pop(context);
                      },
                  child: Text(btnText!),
                ),

              // Btns d'action
              if (btns != null)
                for (var btn in btns!)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStatePropertyAll(btn.btnColor),
                      ),
                      onPressed: btn.btnAction ??
                              () {
                            AppRouter.pop(context);
                          },
                      child: Text(btn.btnText),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}