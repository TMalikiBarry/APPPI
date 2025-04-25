import '../../../domain/contact_pi.dart';

class ContactCreateEvent {
  const ContactCreateEvent();
}

/// Lister les contacts
class ContactCreateSubmitEvent extends ContactCreateEvent {
  const ContactCreateSubmitEvent(this.contact);
  final ContactPI contact;
}
