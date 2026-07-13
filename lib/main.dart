import 'package:flutter/material.dart';

void main() {
  runApp(const LytsUpApp());
}

class LytsUpApp extends StatelessWidget {
  const LytsUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LytsUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF4F2FA),
        useMaterial3: true,
      ),
      home: const HistoryScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// DATA MODEL
// ---------------------------------------------------------------------------

enum TxnType { earned, redeemed }

class Txn {
  final String title;
  final String time;
  final String category;
  final int amount;
  final TxnType type;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const Txn({
    required this.title,
    required this.time,
    required this.category,
    required this.amount,
    required this.type,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

final Map<String, List<Txn>> sampleHistory = {
  'TODAY': [
    Txn(
      title: 'Walk 5km Goal',
      time: '08:45 AM',
      category: 'Fitness',
      amount: 50,
      type: TxnType.earned,
      icon: Icons.fitness_center,
      iconBg: const Color(0xFFEDE7FA),
      iconColor: const Color(0xFF7B2FF7),
    ),
    Txn(
      title: 'Coffee Purchase',
      time: '10:30 AM',
      category: 'Lifestyle',
      amount: -120,
      type: TxnType.redeemed,
      icon: Icons.coffee,
      iconBg: const Color(0xFFFCE8E8),
      iconColor: const Color(0xFFE0637A),
    ),
  ],
  'YESTERDAY': [
    Txn(
      title: 'Spin Wheel Win',
      time: '09:15 PM',
      category: 'Daily Bonus',
      amount: 500,
      type: TxnType.earned,
      icon: Icons.videogame_asset,
      iconBg: const Color(0xFFFBEAE3),
      iconColor: const Color(0xFFE07B4F),
    ),
    Txn(
      title: 'Amazon Voucher',
      time: '04:20 PM',
      category: 'Redemption',
      amount: -2500,
      type: TxnType.redeemed,
      icon: Icons.shopping_bag_outlined,
      iconBg: const Color(0xFFEDE7FA),
      iconColor: const Color(0xFF7B2FF7),
    ),
  ],
  'AUGUST 24': [
    Txn(
      title: 'Referral Bonus',
      time: '11:00 AM',
      category: 'Rewards',
      amount: 1000,
      type: TxnType.earned,
      icon: Icons.celebration_outlined,
      iconBg: const Color(0xFFFCE8E8),
      iconColor: const Color(0xFFE0637A),
    ),
  ],
};

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All'; // All | Earned | Redeemed

  Map<String, List<Txn>> get _filteredHistory {
    if (_filter == 'All') return sampleHistory;
    final wanted = _filter == 'Earned' ? TxnType.earned : TxnType.redeemed;
    final result = <String, List<Txn>>{};
    sampleHistory.forEach((section, txns) {
      final matches = txns.where((t) => t.type == wanted).toList();
      if (matches.isNotEmpty) result[section] = matches;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final history = _filteredHistory;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 8),
                  _buildBalanceCard(),
                  const SizedBox(height: 24),
                  _buildFilterPills(),
                  const SizedBox(height: 24),
                  for (final section in history.keys) ...[
                    _buildSectionLabel(section),
                    const SizedBox(height: 12),
                    for (final txn in history[section]!) ...[
                      _buildTxnRow(txn),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ---- Top bar --------------------------------------------------------

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/100?img=47',
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3A2E5C),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF3A2E5C),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Balance card -----------------------------------------------------

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7B2FF7),
            Color(0xFFC4319B),
            Color(0xFFE0637A),
            Color(0xFFF08A3C),
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2FF7).withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL LYTS BALANCE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text(
                '12,450',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.wb_sunny_rounded, color: Colors.white70, size: 26),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _balanceChip('THIS MONTH', '+2,300'),
              const SizedBox(width: 12),
              _balanceChip('REDEEMED', '850'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balanceChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Filter pills -------------------------------------------------------

  Widget _buildFilterPills() {
    final options = ['All', 'Earned', 'Redeemed'];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAE6F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: options.map((opt) {
          final selected = _filter == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filter = opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF3D1E88) : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  opt,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF6B6480),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---- Section label -----------------------------------------------------

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF9A93AE),
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ---- Transaction row ----------------------------------------------------

  Widget _buildTxnRow(Txn txn) {
    final isEarned = txn.type == TxnType.earned;
    final amountText = '${isEarned ? '+' : '-'}${txn.amount.abs()} Lyts';
    final amountColor =
    isEarned ? const Color(0xFF6A2FD0) : const Color(0xFFC3455B);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: txn.iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(txn.icon, color: txn.iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E2A3E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${txn.time} • ${txn.category}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF9A93AE),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amountText,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  // ---- Bottom nav -----------------------------------------------------

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.home_outlined, 'Home', false),
          _navItem(Icons.local_offer_outlined, 'Deals', false),
          _navCenterItem(),
          _navItem(Icons.storefront_outlined, 'Stores', false),
          _navItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool selected) {
    final color = selected ? const Color(0xFF3D1E88) : const Color(0xFF9A93AE);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _navCenterItem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7B2FF7),
                Color(0xFFC4319B),
                Color(0xFFF08A3C),
              ],
            ),
          ),
          child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 4),
        const Text(
          'LytsUp',
          style: TextStyle(fontSize: 11.5, color: Color(0xFF3D1E88), fontWeight: FontWeight.w700),
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(color: Color(0xFF3D1E88), shape: BoxShape.circle),
        ),
      ],
    );
  }
}