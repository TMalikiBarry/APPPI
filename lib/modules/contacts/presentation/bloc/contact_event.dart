import 'package:flutter_contacts/flutter_contacts.dart';

class ContactEvent {
  const ContactEvent();
}

/// Lister les contacts
class ContactListEvent extends ContactEvent {
  const ContactListEvent(this.keyword);
  final String? keyword;
}

/// Plus de contacts on Scroll
class ContactMoreEvent extends ContactEvent {
  ///
  const ContactMoreEvent(this.contacts, this.index);

  // Liste actuelle
  final List<Contact> contacts;

  /// Index où on s'est arrete
  final int index;
}

/// Rechercher dans les contacts
class ContactSearchEvent extends ContactEvent {
  const ContactSearchEvent(this.keyword);
  final String? keyword;
}

class ContactUpdateEvent extends ContactEvent {
  const ContactUpdateEvent(this.contact, this.alias);
  final Contact contact;
  final String alias;
}
