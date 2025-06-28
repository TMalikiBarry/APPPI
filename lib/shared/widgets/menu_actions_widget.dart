import 'package:flutter/material.dart';

class MenuActionsWiget extends StatelessWidget {
  ///
  const MenuActionsWiget({super.key, required this.items});

  final List<MenuActionItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];

          return ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
            leading: item.buildLeading(context),
            onTap: item.onTap(),
          );
        },
      ),
    );
  }
}

class MenuActionItem {
  //
  MenuActionItem(
    this.icon,
    this.title,
    this.subtitle,
    this.action, {
    this.iconSize,
  });

  final String icon;
  final double? iconSize;

  final String title;

  final String? subtitle;

  final Function() action;

  Widget buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget? buildSubtitle(BuildContext context) {
    return subtitle != null
        ? Text(
            subtitle!,
            style: Theme.of(context).textTheme.displaySmall,
          )
        : null;
  }

  Widget buildLeading(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(14.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ImageIcon(
          AssetImage(icon,package: 'common_dependencies'),
          color: Theme.of(context).colorScheme.onSurface,
          size: iconSize ?? 30,
        ),
      ),
    );
  }

  void Function() onTap() => action;
}
