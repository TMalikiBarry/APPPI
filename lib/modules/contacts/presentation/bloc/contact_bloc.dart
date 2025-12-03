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
    // Récupérer la liste complète des contacts
    List<Contact> contactsAll = state.contactsAll!;
    //logger.i("contactsAll count ${contactsAll.length}");
    //logger.i("event.keyword ${event.keyword}");


    // Si la liste est vide, charger les contacts depuis le device
    if (contactsAll.isEmpty) {
      if (await FlutterContacts.requestPermission()) {
        contactsAll = await FlutterContacts.getContacts(
          withProperties: true,
          withThumbnail: true,
          withAccounts: false,
          sorted: true,
          deduplicateProperties: false,
        );
      } else {
        // Permission refusée, émettre un état vide
        emit(const ContactState([], [], 0));
        return;
      }
    }
    logger.i("contactsAll event.keyword ${event.keyword}");
    // Effectuer la recherche
    if (event.keyword != null && event.keyword!.isNotEmpty) {
      //logger.i("contactsAll event.keyword ${event.keyword}");
      List<Contact> contacts = contactsAll.where((element) {
        final name = element.displayName.toLowerCase();
        final keyword = event.keyword!.toLowerCase();

        final matchName = name.contains(keyword);

        final matchPhone = element.phones.any(
              (phone) => phone.number.replaceAll(' ', '').contains(keyword),
        );
        logger.i("matchName || matchPhone ${matchName || matchPhone}");

        return matchName || matchPhone;
      }).toList();
      emit(ContactState(contactsAll, contacts, 0));
    } else {
      emit(const ContactState([], [], 0));
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

      // Recharger tous les contacts depuis le device
      List<Contact> contactsAll = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
        withAccounts: false,
        sorted: true,
        deduplicateProperties: false,
      );

      // Maintenir l'état actuel de recherche ou liste complète
      if (state.contacts!.length < contactsAll.length) {
        // Si on était en mode recherche, garder les résultats filtrés mis à jour
        emit(ContactState(contactsAll, state.contacts, state.index));
      } else {
        // Si on affichait la liste complète, afficher les 20 premiers
        int total = contactsAll.length;
        int limit = min(total, 20);
        emit(ContactState(contactsAll, contactsAll.take(limit).toList(), 20));
      }
    } catch (e) {
      logger.e(e);
    }
  }
}
