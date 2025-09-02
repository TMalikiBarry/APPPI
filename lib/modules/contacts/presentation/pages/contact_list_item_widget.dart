import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:logger/logger.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/theme.dart';
import '../../../../shared/models/alias_pi.dart';

class ContactListItemWidget extends StatelessWidget {
  //
  const ContactListItemWidget({
    super.key,
    required this.contact,
    this.onSelect,
    this.showCheckbox = false,
    this.isSelected = false,
  });

  /// Pour écrire des logs
  static final logger = Logger();
  final Contact contact;
  final Function(Contact contact, String? alias, bool? isSelected)? onSelect;
  final bool? showCheckbox;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    //
    String? alias = _getAliasValue(contact);
    if (showCheckbox != null && showCheckbox == true) {
      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        value: isSelected ?? false,
        onChanged: (bool? value) => {
          if (onSelect != null) onSelect!(contact, alias, value),
        },
        title: _listTile(context, alias, false),
      );
    } else {
      return _listTile(context, alias, true);
    }
  }

  /// Affiche le widget ListTile
  Widget _listTile(BuildContext context, String? alias, bool onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      // Avatar
      leading: Stack(
        children: [
          /*const CircleAvatar(
            backgroundImage: AssetImage(Images.transactionAvatar,package: 'common_dependencies'),
          ),*/
          CircleAvatar(
            backgroundColor: _generateColorFromString(contact.displayName),
            child: Text(
              _getInitials(contact.displayName),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (alias != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: const ShapeDecoration(
                  color: Themer.brownColor,
                  shape: CircleBorder(
                    side: BorderSide(width: 2, color: Colors.white),
                  ),
                ),
                child: Image.asset(Images.iconsPiBadge,
                    package: 'common_dependencies'),
              ),
            ),
        ],
      ),
      // Contact name
      title: Text(
        contact.displayName,
        style: Theme.of(context).textTheme.headlineSmall,
        overflow: TextOverflow.ellipsis,
      ),
      // Phone number or alias
      subtitle: Text(
        alias ?? (contact.phones.isNotEmpty ? contact.phones[0].number : ''),
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            . //
            copyWith(color: Themer.neural04Color),
      ),
      onTap: onTap
          ? () {
              if (onSelect != null) onSelect!(contact, alias, null);
            }
          : null,
    );
  }

  /// Récupère la valeur de l'alias
  String? _getAliasValue(Contact contact) {
    // TODO remove after test IOS
    // List<SocialMedia> socialMedias = contact.socialMedias;
    // for (var element in socialMedias) {
    //   if (element.label == SocialMediaLabel.custom &&
    //       element.customLabel == _label &&
    //       element.userName.isNotEmpty) {
    //     return element.userName;
    //   }
    // }
    // return null;

    try {
      var aliasRecord = contact.phones
          .where((phone) =>
              phone.label == PhoneLabel.custom &&
              phone.customLabel == AliasPI.label)
          .first;
      return aliasRecord.number;
    } catch (e) {
      // No item found
      return null;
    }
  }


  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
  }

  Color _generateColorFromString(String input) {
    final hash = input.runes.fold(0, (prev, code) => prev + code);
    // Tu choisis un ensemble de couleurs prédéfinies
    const palette = [
      Color(0xE6E57373),
      Color(0xE6BA68C8),
      Color(0xE664B5F6),
      Color(0xE699EDB1),
      Color(0xE6FFD54F),
      Color(0xE6A1887F),
      Color(0xE6204093),
      Color(0xE6DC1A36),
      Color(0xE657050F),
      Color(0xE60BEA14),
      Color(0xFF603942),
      Color(0xE6836503),
      Color(0xFF5C0A4E),
      Color(0xE6BD7F0C),
      Color(0xE60A8DF6),
      Color(0xE6047E0A),
      Color(0xE6011423),
      Color(0xE65A349F),
    ];
    return palette[hash % palette.length];
  }
}
