import 'package:flutter_contacts/flutter_contacts.dart';

class ContactCreateState {
  final Contact? contact;

  ///
  const ContactCreateState(this.contact);
}

class ContactCreateLoadingState extends ContactCreateState {
  ///
  const ContactCreateLoadingState(super.contact);
}

class ContactCreateSuccessState extends ContactCreateState {
  ///
  const ContactCreateSuccessState(super.contact);
}

class ContactCreateErrorState extends ContactCreateState {
  final String? error;

  ///
  const ContactCreateErrorState(super.contact, this.error);
}
