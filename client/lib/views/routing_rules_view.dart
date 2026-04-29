import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';

class RoutingRulesView extends StatelessWidget {
  const RoutingRulesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header (consistent with Dashboard)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFFFD1C1),
                    child: Icon(LucideIcons.user, color: Colors.brown),
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
                    // Back Link
                    TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(LucideIcons.arrowLeft, size: 16),
                      label: const Text('Back'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0F172A),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Smart Routing Rules',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Let ArabPay choose the best way to receive\nyour money.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rule 1: Small Payments
                    _buildRuleCard(
                      icon: LucideIcons.wallet,
                      iconBg: const Color(0xFF6EE7B7),
                      title: 'Small Payments',
                      description:
                          'Transactions under 500 SAR will be instantly routed to your Mobile Wallet for immediate liquidity.',
                      isEnabled: true,
                      hasPattern: true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Destination',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF7DD3FC),
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              'Mobile Wallet (**** 8291)',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0C4A6E)),
                            ),
                            SizedBox(width: 8),
                            Icon(LucideIcons.checkCircle2,
                                size: 14, color: Color(0xFF0891B2)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Secure Layer Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.shieldCheck,
                                  color: Color(0xFF10B981), size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'SECURE BANKING LAYER',
                                style: TextStyle(
                                  color: const Color(0xFF10B981),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Verified ID Status',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'All routing rules are protected by end-to-end encryption and verified through your Saudi Digital Identity.',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13,
                                height: 1.4),
                          ),
                          const SizedBox(height: 24),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 1.0,
                              minHeight: 4,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF10B981)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Identity Strength: 100%',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rule 2: Large Payments
                    _buildRuleCard(
                      icon: LucideIcons.landmark,
                      iconBg: const Color(0xFFDBEAFE),
                      iconColor: const Color(0xFF1D4ED8),
                      title: 'Large Payments',
                      description:
                          'Payments exceeding 5,000 SAR are directed to your Main Bank account for security.',
                      isEnabled: true,
                      child: const Row(
                        children: [
                          Icon(LucideIcons.info,
                              size: 14, color: Color(0xFF64748B)),
                          SizedBox(width: 8),
                          Text(
                            'Requires dual-factor confirmation',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rule 3: Local Transfers
                    _buildRuleCard(
                      icon: LucideIcons.globe,
                      iconBg: const Color(0xFFDCFCE7),
                      iconColor: const Color(0xFF166534),
                      title: 'Local Transfers',
                      description:
                          'Any same-country transfers will be settled via your preferred Local Bank for zero-fee processing.',
                      isEnabled: true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'OPTIMIZED',
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF166534),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Save Routing Preferences',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
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
        currentIndex: 3, // Profile selected
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

  Widget _buildRuleCard({
    required IconData icon,
    required Color iconBg,
    Color iconColor = Colors.white,
    required String title,
    required String description,
    required bool isEnabled,
    Widget? child,
    bool hasPattern = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Stack(
        children: [
          if (hasPattern)
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Icon(LucideIcons.star,
                    size: 200, color: Colors.grey.withOpacity(0.1)),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  Switch(
                    value: isEnabled,
                    onChanged: (v) {},
                    activeColor: const Color(0xFF166534),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF64748B), height: 1.4),
              ),
              if (child != null) ...[
                const SizedBox(height: 16),
                child,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
