import 'package:flutter/material.dart';
import '../../../../core/router.dart';

class ProfilePageMenu extends StatelessWidget {
  //
  const ProfilePageMenu({super.key, required this.items});

  final List<ProfileItem> items;

  @override
  Widget build(BuildContext context) {
    //
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (ProfileItem item in items)
            ListTile(
              onTap: () {
                if (item.page != null) {
                  AppRouter.push(context, item.page!);
                }
                // Wanna open sheet
                else if (item.sheet != null) {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return item.sheet!;
                    },
                    isScrollControlled: true,
                  );
                }
              },
              leading: Image.asset(
                color: Theme.of(context).colorScheme.onSurface,
                item.icon, 
                width: 24, 
                height: 24,
                  package: 'common_dependencies'
              ),
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: item.subtitle != null
                  ? Text(
                      item.subtitle!,
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  : null,
              trailing: item.action != null && item.value != null
                  ? Switch(
                      value: item.value!,
                      onChanged: item.action!,
                    )
                  : null,
            ),
        ],
      ),
    );
  }
}

class ProfileItem {
  //
  ProfileItem(
    this.icon,
    this.title,
    this.page, {
    this.subtitle,
    this.value,
    this.action,
    this.sheet,
  });

  final String icon;

  final String title;

  final String? page;

  final String? subtitle;

  final bool? value;
  final Function(bool)? action;

  //
  final Widget? sheet;
}
