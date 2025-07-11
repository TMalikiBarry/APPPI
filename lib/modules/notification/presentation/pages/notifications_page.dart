import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di.dart';
import '../../domain/models/notificationDTO.dart';
import '../../domain/services/notification_service.dart';
import '../../infra/notification_output_remote.dart';
import '../../ports/input/notification_input_port.dart';
import '../bloc/notifications_blocbuld.dart';
import '../bloc/notifications_blocs.dart';


class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({Key? key}) : super(key: key);

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late NotificationBloc bloc;
  String? phoneNumber;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initBloc();
  }

  Future<void> _initBloc() async {
    final pref = await SharedPreferences.getInstance();
    phoneNumber = pref.getString('accountNumber') ?? '';

    // Récupère ici ton NotificationOutputPort (ex: à travers DI)
    final outputPort = Di.getNotificationInputPort();
    // final service = NotificationService(outputPort);

    bloc = NotificationBloc(outputPort)
      ..add(NotificationListRequest(phoneNumber!));

    setState(() {
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (bloc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // AppBar manuelle pour coller à votre header Figma
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              BackButton(color: Colors.white),
              const SizedBox(width: 8),
              Text('Notifications',
                  style: Theme.of(context).textTheme.headlineSmall!
                      .copyWith(color: Colors.white)),
            ],
          ),
        ),
        // Search + filtre
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Recherche',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red, // couleur bouton filtre
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {/* filtre */},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BlocBuilder<NotificationBloc, NotificationState>(
            bloc: bloc,
            builder: (context, state) {
              if (state is NotificationLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is NotificationEmpty) {
                return const Center(child: Text('Aucune notification'));
              }
              if (state is NotificationLoaded) {
                // Grouper par date
                final grouped = <String, List<NotificationModel>>{};
                for (var n in state.notifications) {
                  final day = DateFormat('d MMM').format(n.timestamp);
                  grouped.putIfAbsent(day, () => []).add(n);
                }

                // Construire la liste avec sections
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: grouped.keys.length,
                  itemBuilder: (ctx, sectionIndex) {
                    final day = grouped.keys.elementAt(sectionIndex);
                    final items = grouped[day]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            day,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                        ...items.map((n) => _buildNotificationCard(n)).toList(),
                      ],
                    );
                  },
                );
              }
              if (state is NotificationError) {
                return Center(child: Text('Erreur: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationModel n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar / Icon venant de Figma
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(_pickIcon(n.title)),
              ),
              const SizedBox(width: 12),
              // Texte principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      n.body,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              // Montant ou timestamp
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // Si vous avez un montant, sinon timestamp
                    DateFormat('HH:mm').format(n.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _pickIcon(String title) {
    // Renvoie le chemin AssetImage selon le type
    if (title.contains('Demande')) {
      return 'assets/icons/payment_request.png';
    }
    if (title.contains('Budget')) {
      return 'assets/icons/budget.png';
    }
    // etc.
    return 'assets/icons/default_notification.png';
  }
}