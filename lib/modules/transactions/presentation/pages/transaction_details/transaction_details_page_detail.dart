import 'package:flutter/material.dart';
import 'package:pi_mobile_app/core/theme.dart';

class TransactionDetailsPageDetail extends StatelessWidget {
  ///
  const TransactionDetailsPageDetail({
    super.key,
    required this.label,
    this.description,
    this.actionText,
    this.actionIcon,
    this.actionFunction,
    this.action,
  });

  final String label;
  final String? description;
  // Action
  final String? actionText;
  final Widget? actionIcon;
  final Function()? actionFunction;
  // Action tout court
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // label
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),

            // Description
            if (description != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    description!,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Themer.neural03Color),
                  ),
                ),
              ),

            // Action
            if (actionText != null && actionIcon != null)
              TextButton.icon(
                onPressed: actionFunction,
                icon: actionIcon!,
                label: Text(actionText!),
              ),

            if (action != null) action!
          ],
        ),
      ),
    );
  }
}
