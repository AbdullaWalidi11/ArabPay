import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;

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
                    child: Icon(LucideIcons.user, color: Colors.brown, size: 20),
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
                    icon: const Icon(LucideIcons.bell, color: Color(0xFF0F172A)),
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
                    const SizedBox(height: 12),
                    // Profile Header Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Star Pattern Background (Simulated)
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.03,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                                itemBuilder: (context, index) => const Icon(LucideIcons.star, size: 40),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Color(0xFFF1F5F9),
                                  child: Icon(LucideIcons.user, size: 50, color: Color(0xFF94A3B8)),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  user?.name ?? 'Ali Ahmed',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(LucideIcons.checkCircle2, size: 14, color: Color(0xFF1D4ED8)),
                                      const SizedBox(width: 6),
                                      Text(
                                        user?.arabPayId ?? 'ali@arabpay',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'ACCOUNT SETTINGS',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1),
                    ),
                    const SizedBox(height: 16),

                    // Settings List
                    _buildSettingItem(LucideIcons.landmark, 'My Linked Accounts', () => context.push('/linked-methods')),
                    _buildSettingItem(LucideIcons.gitBranch, 'Routing Preferences', () => context.push('/routing-rules')),

                    const SizedBox(height: 32),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => context.go('/'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFEF4444)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          foregroundColor: const Color(0xFFEF4444),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.logOut, size: 20),
                            SizedBox(width: 12),
                            Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'ArabPay Version 2.4.0 (2023)',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0B132B),
        unselectedItemColor: const Color(0xFF94A3B8),
        currentIndex: 4,
        backgroundColor: Colors.white,
        elevation: 20,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/dashboard'); break;
            case 1: context.push('/send-money'); break;
            case 2: context.push('/receive-money'); break;
            case 3: context.push('/routing-rules'); break;
            case 4: context.push('/profile'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.send), label: 'Send'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.qrCode), label: 'Receive'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.gitBranch), label: 'Routing'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.userCircle), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, String value, {bool isStatus = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isStatus ? const Color(0xFF10B981) : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF1D4ED8), size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 15),
              ),
              const Spacer(),
              const Icon(LucideIcons.chevronRight, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
