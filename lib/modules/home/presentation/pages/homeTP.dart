import 'package:flutter/material.dart';

class HomeScreenSPI extends StatelessWidget {
  const HomeScreenSPI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(radius: 16, backgroundColor: Colors.grey),
            const SizedBox(width: 8),
            Image.asset('assets/logo_spi.png', height: 20), // ton logo SPI
          ],
        ),
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Tabs: Compte / Abonnements / Économies
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _TabButton(title: "Compte", isActive: true),
                const SizedBox(width: 8),
                _TabButton(title: "Abonnements"),
                const SizedBox(width: 8),
                _TabButton(title: "Economies"),
              ],
            ),
          ),

          // Balance card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2F296A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Solde", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "100 000 F",
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(Icons.qr_code, size: 20, color: Color(0xFF2F296A)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _ActionIcon(title: "Envoyer", icon: Icons.send),
                      _ActionIcon(title: "Recevoir", icon: Icons.call_received),
                      _ActionIcon(title: "Plus", icon: Icons.more_horiz),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Transactions section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Transactions", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Tout afficher", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // List of transactions
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _TransactionTile(name: "Bamba Diagne", initials: "BD", color: Colors.purple, amount: "-18 000 F"),
                _TransactionTile(name: "Alpha Diack", initials: "AD", color: Colors.lightBlue, amount: "20 000 F"),
                _TransactionTile(name: "Bousso Gueye", initials: "BG", color: Colors.orange, amount: "-18 000 F"),
                _TransactionTile(name: "Bousso Gueye", initials: "BG", color: Colors.orange, amount: "-18 000 F"),
                _TransactionTile(name: "Bousso Niang", initials: "BN", color: Colors.blue, amount: "20 000 F"),
              ],
            ),
          ),

          // Widgets section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Dépenses du mois", style: TextStyle(color: Colors.grey)),
                Text("2 300 000 F", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2F296A),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_vert), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'TouchPoint'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // gestion des tabs
        },
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabButton({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ActionIcon({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white24,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String name;
  final String initials;
  final Color color;
  final String amount;

  const _TransactionTile({
    required this.name,
    required this.initials,
    required this.color,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color, child: Text(initials, style: const TextStyle(color: Colors.white))),
      title: Text(name),
      subtitle: const Text("22 Juin, 2024 · 08:20"),
      trailing: Text(
        amount,
        style: TextStyle(
          color: amount.contains('-') ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
