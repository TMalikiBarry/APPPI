import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:logger/logger.dart';

import '../../../../shared/models/alias_pi.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ///
  final logger = Logger();

  ContactBloc() : super(const ContactState([], [], 0)) {
    // Pour obtenir la liste des contacts
    on<ContactListEvent>(_onContactListEvent);
    // Quand on scroll down la liste des contacts
    on<ContactMoreEvent>(_onContactMoreEvent);
    // Quand on recherche dans les contacts
    on<ContactSearchEvent>(_onContactSearchEvent);
    // Quand on met à jour un contact
    on<ContactUpdateEvent>(_onContactUpdateEvent);
  }

  /// Pour obtenir la liste des contacts
  void _onContactListEvent(
    ContactListEvent event,
    Emitter<ContactState> emit,
  ) async {
    // Check permission before
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
        withAccounts: false,
        sorted: true,
        deduplicateProperties: false,
      );
      // Retourner une partie de la liste
      int total = contacts.length;
      int limit = min(total, 20);
      emit(ContactState(contacts, contacts.take(limit).toList(), 20));
    }
  }

  /// Pour obtenir la liste des contacts
  void _onContactMoreEvent(
    ContactMoreEvent event,
    Emitter<ContactState> emit,
  ) async {
    // en fonction de là ou on se trouves
    List<Contact> contactsAll = state.contactsAll!;

    // Récuperer les 20 suivants, l'ajouter sur la liste
    // Si après ajout ne retourne pas plus de 50 pour afficher
    List<Contact> contacts = event.contacts;
    int size = contactsAll.length >= 20 ? 20 : contactsAll.length;
    final start = (event.index - 1) * size;
    int rawEnd = event.index * size;
    final end = rawEnd.clamp(0, contactsAll.length);
    if (end <= contactsAll.length) {
      contacts.addAll(contactsAll.getRange(
        start,
        end,
      ));
    } else if (start < contactsAll.length) {
      contacts.addAll(contactsAll.getRange(
        start,
        contactsAll.length,
      ));
    }
    //
    emit(
      ContactState(
        contactsAll,
        contacts,
        event.index + 1,
      ),
    );
  }

  void _onContactSearchEvent(
    ContactSearchEvent event,
    Emitter<ContactState> emit,
  ) async {
    // en fonction de là ou on se trouves
    List<Contact> contactsAll = state.contactsAll!;
    // logger.i("contactsAll $contactsAll");
    if (state.contactsAll!.isEmpty) {
      // logger.i("contactsAll isEmpty $contactsAll");
      contactsAll = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
        withAccounts: false,
        sorted: true,
        deduplicateProperties: false,
      );
    }
    //logger.i("contactsAll2 $contactsAll");
    if (event.keyword != null && event.keyword!.isNotEmpty) {
      //logger.i("contactsAll event.keyword ${event.keyword}");
      List<Contact> contacts = contactsAll.where((element) {
        final name = element.displayName.toLowerCase();
        final keyword = event.keyword!.toLowerCase();

        final matchName = name.contains(keyword);

        final matchPhone = element.phones.any(
              (phone) => phone.number.replaceAll(' ', '').contains(keyword),
        );

        return matchName || matchPhone;
      }).toList();
      emit(ContactState(contactsAll, contacts, 0));
    } else {
      add(const ContactListEvent(null));
    }
  }

  void _onContactUpdateEvent(
    ContactUpdateEvent event,
    Emitter<ContactState> emit,
  ) async {
    //
    Contact? contact = await FlutterContacts.getContact(
      event.contact.id,
      withProperties: true,
      withAccounts: true,
      deduplicateProperties: false,
    );
    try {
      contact!.phones.add(Phone(
        event.alias,
        label: PhoneLabel.custom,
        customLabel: AliasPI.label,
      ));
      await contact.update();
      add(const ContactListEvent(null));
    } catch (e) {
      logger.e(e);
    }
  }
}
