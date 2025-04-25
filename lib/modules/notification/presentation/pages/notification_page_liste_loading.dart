import 'package:flutter/material.dart';

import '../../../../shared/widgets/skeleton_widget.dart';

class NotificationPageListeLoading extends StatelessWidget {
  ///
  const NotificationPageListeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const SkeletonWidget(radius: 20),
            title: SkeletonWidget(height: 15, width: width),
            subtitle: const SkeletonWidget(width: 100),
          );
        },
      ),
    );
  }
}
