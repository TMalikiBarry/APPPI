import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:logger/logger.dart';

import '../../../../../shared/models/alias_pi.dart';
import 'contact_create_event.dart';
import 'contact_create_state.dart';

class ContactCreateBloc extends Bloc<ContactCreateEvent, ContactCreateState> {
  ///
  final logger = Logger();

  ContactCreateBloc() : super(const ContactCreateState(null)) {
    // Pour creer le contact
    on<ContactCreateSubmitEvent>(_onContactCreateSubmitEvent);
  }

  void _onContactCreateSubmitEvent(
    ContactCreateSubmitEvent event,
    Emitter<ContactCreateState> emit,
  ) async {
    final newContact = Contact()
      ..name.first = event.contact.name
      ..phones = [
        Phone(
          event.contact.alias!,
          label: PhoneLabel.custom,
          customLabel: AliasPI.label,
        )
      ];
    await newContact.insert();
    logger.i("Contact crée avec succès");

    emit(ContactCreateSuccessState(newContact));
  }
}
