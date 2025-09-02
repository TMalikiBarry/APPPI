import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/contact_event.dart';
import '../bloc/contact_state.dart';
import 'contact_list_item_widget.dart';

class ContactList {
  final String header;
  final List<Contact> contacts;

  ContactList({required this.header, required this.contacts});
}

class ContactListWidget extends StatefulWidget {
  //
  const ContactListWidget({
    super.key,
    this.onSelect,
    this.hideTitle,
    this.selectedItems,
  });
  final Function(Contact contact, String? alias, bool? isSelected)? onSelect;
  final List<Contact>? selectedItems;
  final bool? hideTitle;

  @override
  State<ContactListWidget> createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  late ScrollController scrollController;
  late List<Contact> contacts;
  late int index;

  @override
  void initState() {
    super.initState();
    contacts = [];
    index = 1;
    context.read<ContactBloc>().add(ContactListEvent(null));
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          index++;
          context.read<ContactBloc>().add(ContactMoreEvent(contacts, index));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        contacts = state.contacts ?? [];
        if (contacts.isNotEmpty) {
          List<ContactList> contactGroups = groupContacts(contacts);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hideTitle == null || !widget.hideTitle!) ...[
                Text(
                  traductions.transactionsSendTitleContacts,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall! //
                      .copyWith(color: Themer.neural05Color),
                ),
                const SizedBox(height: 17),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: MediaQuery.of(context).size.height * 0.65,
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: contactGroups.length,
                  itemBuilder: (context, index) {
                    ContactList contactGroup = contactGroups[index];
                    return _buildContactSection(context, contactGroup);
                  },
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildContactSection(BuildContext context, ContactList contactGroup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          contactGroup.header,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Themer.neural03Color),
        ),
        const SizedBox(height: 8),
        // Contacts in the section
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contactGroup.contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contactGroup.contacts[index];
                final isSelected =
                    widget.selectedItems?.any((t) => t.id == contact.id) ??
                        false;
                return ContactListItemWidget(
                  contact: contact,
                  onSelect: widget.onSelect,
                  showCheckbox: widget.selectedItems != null,
                  isSelected: isSelected,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  List<ContactList> groupContacts(List<Contact> contacts) {
    Map<String, List<Contact>> groupedContacts = {};
    for (Contact contact in contacts) {
      String firstLetter = contact.displayName.substring(0, 1).toUpperCase();
      groupedContacts[firstLetter] = groupedContacts[firstLetter] ?? [];
      groupedContacts[firstLetter]!.add(contact);
    }

    List<ContactList> result = [];
    for (var entry in groupedContacts.entries) {
      result.add(ContactList(header: entry.key, contacts: entry.value));
    }

    // Sort the result list based on the header (alphabetically)
    result.sort((a, b) => a.header.compareTo(b.header));

    return result;
  }
}
