import 'package:flutter/material.dart';

class QrcodeSwitchBtn extends StatelessWidget {
  final Color? cardBgColor;
  final List<QrcodeBtnItem> items;

  ///
  const QrcodeSwitchBtn({Key? key, required this.items, this.cardBgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return Card(
      color: cardBgColor,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (QrcodeBtnItem item in items)
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(height: 64),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: item.btnColor,
                    ),
                    onPressed: () =>
                        item.action != null ? item.action!() : null,
                    child: Center(
                      child: Text(
                        item.text,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?. //
                            copyWith(
                              color: item.textColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QrcodeBtnItem {
  //
  QrcodeBtnItem({
    required this.text,
    required this.textColor,
    required this.btnColor,
    this.action,
  });
  final String text;
  final Color textColor;
  final Color btnColor;
  final Function()? action;
}
