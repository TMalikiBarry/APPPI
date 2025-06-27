import 'package:flutter/material.dart';

import '../../core/theme.dart';

class CtaWidget extends StatelessWidget {
  ///
  const CtaWidget({
    super.key,
    required this.label,
    required this.action,
    this.icon,
    this.image,
    this.disabled,
  });

  final String label;
  final Function()? action;
  final Icon? icon;
  final String? image;
  final bool? disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: disabled != null && disabled == true ? null : action,
          elevation: 0,
          heroTag: label,
          backgroundColor: disabled != null && disabled == true
              ? Themer.gray
              : Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rayon souhaité
          ),
          child: icon ??
              ImageIcon(
                AssetImage(image!),
                color: disabled != null && disabled == true
                    ? Themer.blackColor
                    : Theme.of(context).colorScheme.onPrimary,
                size: 30,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
