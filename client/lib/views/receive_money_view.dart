import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReceiveMoneyView extends StatelessWidget {
  const ReceiveMoneyView({super.key});

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
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF0F172A)),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Receive Money',
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
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFFFD1C1),
                    child: Icon(LucideIcons.user, color: Colors.brown, size: 16),
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
                    // Main QR Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          const Text(
                            'ArabPay ID',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '@${user?.arabPayId.split('@')[0] ?? 'ali'}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // QR Area
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 2,
                                style: BorderStyle.solid, // Note: Dashed would need custom painter
                              ),
                            ),
                            child: const Center(
                              child: Icon(LucideIcons.qrCode, size: 140, color: Color(0xFF94A3B8)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Verified Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF065F46),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.checkCircle2, color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'VERIFIED',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Card Buttons
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildCardButton(
                                    icon: LucideIcons.copy,
                                    label: 'Copy ID',
                                    isPrimary: true,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildCardButton(
                                    icon: LucideIcons.share2,
                                    label: 'Share QR',
                                    isPrimary: false,
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
                      'Quick Share',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildShareOption(LucideIcons.messageSquare, 'WhatsApp', const Color(0xFFDCFCE7), const Color(0xFF166534)),
                        _buildShareOption(LucideIcons.mail, 'Email', const Color(0xFFEFF6FF), const Color(0xFF1D4ED8)),
                        _buildShareOption(LucideIcons.messageCircle, 'SMS', const Color(0xFFF8FAFF), const Color(0xFF64748B)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Info Note
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.info, color: Color(0xFF1D4ED8)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Share this ID to receive money without exposing your private bank details.',
                              style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 13, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.shieldCheck, color: Color(0xFF166534)),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ENCRYPTED TRANSFER',
                                  style: TextStyle(
                                    color: Color(0xFF166534),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'All transactions are protected by bank-grade security protocols.',
                                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
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
        currentIndex: 2, // Receive selected
        backgroundColor: Colors.white,
        elevation: 20,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/dashboard'); break;
            case 1: context.push('/send-money'); break;
            case 2: context.push('/receive-money'); break;
            case 3: context.push('/profile'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.send), label: 'Send'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.qrCode), label: 'Receive'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.userCircle), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCardButton({required IconData icon, required String label, required bool isPrimary}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF0B132B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary ? null : Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isPrimary ? Colors.white : const Color(0xFF0F172A), size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color bg, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
