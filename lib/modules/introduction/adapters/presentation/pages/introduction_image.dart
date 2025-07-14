import 'package:common_dependencies/utils/colors.dart' as Colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme.dart';
import 'introduction_item_img.dart';

class IntroductionImage extends StatelessWidget {
  final IntroductionItem item;

  const IntroductionImage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive text sizing left unchanged
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 350, height: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Image.asset(
              item.assetPath,
              package: 'common_dependencies',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(item.legende, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Themer.primaryLight)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(item.titre,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: Themer.primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }
}