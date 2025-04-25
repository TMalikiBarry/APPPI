import 'package:flutter/material.dart';

import '../../../../../shared/widgets/skeleton_widget.dart';

class SubscriptionListLoadingWidget extends StatelessWidget {
  ///
  const SubscriptionListLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonWidget(height: 15, width: 150),
                const SkeletonWidget(width: 10, height: 10,),
              ],
            ),
          ),
          SizedBox(
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
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonWidget(height: 15, width: 150),
                const SkeletonWidget(width: 10, height: 10,),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const SkeletonWidget(radius: 20),
                  title: SkeletonWidget(height: 15, width: width),
                  subtitle: const SkeletonWidget(width: 100),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
