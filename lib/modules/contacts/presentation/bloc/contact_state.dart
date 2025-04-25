import 'package:flutter_contacts/flutter_contacts.dart';

class ContactState {
  /// Liste des dernières transactions affichées
  final List<Contact>? contactsAll;

  /// Liste
  final List<Contact>? contacts;

  /// Index où on s'est arrete
  final int index;

  final Contact? inserted;

  ///
  const ContactState(
    this.contactsAll,
    this.contacts,
    this.index, [
    this.inserted,
  ]);
}
