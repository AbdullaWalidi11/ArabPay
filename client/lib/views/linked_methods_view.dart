import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LinkedMethodsView extends StatelessWidget {
  const LinkedMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final methods = provider.linkedMethods;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFFFD1C1),
                    child:
                        Icon(LucideIcons.user, color: Colors.brown, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'ArabPay',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:
                        const Icon(LucideIcons.bell, color: Color(0xFF0F172A)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Dynamic Methods List from Provider
                    ...methods
                        .map((method) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildAccountCard(
                                icon: method.type == 'wallet'
                                    ? LucideIcons.wallet
                                    : LucideIcons.landmark,
                                name: method.provider,
                                country: method.country,
                                currency: method.currency,
                                date: 'Apr 2024', // Simplified for demo
                                status: method.isActive ? 'Active' : 'Pending',
                                statusColor: method.isActive
                                    ? const Color(0xFF1D4ED8)
                                    : const Color(0xFF94A3B8),
                                statusBg: method.isActive
                                    ? const Color(0xFFEFF6FF)
                                    : const Color(0xFFF1F5F9),
                                isPreferred: method.provider ==
                                    'Ziraat Bank', // Keep one as preferred for demo
                              ),
                            ))
                        .toList(),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-method'),
        backgroundColor: const Color(0xFF0B132B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 32),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0B132B),
        unselectedItemColor: const Color(0xFF94A3B8),
        currentIndex: 3, // Profile context
        backgroundColor: Colors.white,
        elevation: 20,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.push('/send-money');
              break;
            case 2:
              context.push('/receive-money');
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.send), label: 'Send'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.qrCode), label: 'Receive'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.userCircle), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildAccountCard({
    required IconData icon,
    required String name,
    required String country,
    required String currency,
    required String date,
    required String status,
    required Color statusColor,
    required Color statusBg,
    bool isPreferred = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Icon(icon,
                          color: const Color(0xFFEF4444),
                          size: 24), // Branded red icon
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          if (status == 'Verified')
                            Icon(LucideIcons.checkCircle2,
                                size: 12, color: statusColor),
                          if (status == 'Verified') const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A)),
                ),
                Text(
                  country,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.globe,
                              size: 14, color: Color(0xFF1D4ED8)),
                          const SizedBox(width: 8),
                          Text(
                            currency,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D4ED8),
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (isPreferred) ...[
                      const SizedBox(width: 12),
                      const Text(
                        'Preferred Method',
                        style: TextStyle(
                            color: Color(0xFF166534),
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Linked on $date',
                  style:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
                const Icon(LucideIcons.moreVertical,
                    color: Color(0xFF0F172A), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
