import 'package:flutter/material.dart';

import '../../../../shared/widgets/skeleton_widget.dart';

class CompteDetailsLoading extends StatelessWidget {
  ///
  const CompteDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: SkeletonWidget(height: 50, width: width),
          );
        },
      ),
    );
  }
}
