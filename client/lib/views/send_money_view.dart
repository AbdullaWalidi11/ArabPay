import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SendMoneyView extends StatefulWidget {
  const SendMoneyView({super.key});

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {
  final _idController = TextEditingController(text: '@ali');
  final _amountController = TextEditingController(text: '500');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                    'Send Money',
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
                    backgroundColor: Color(0xFF0F172A),
                    child: Icon(LucideIcons.user, color: Colors.white, size: 16),
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
                    // Recipient Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recipient ArabPay ID',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _idController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(LucideIcons.atSign, color: Color(0xFF94A3B8)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                                child: const Icon(LucideIcons.check, color: Colors.white, size: 10),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Verified ArabPay User: Ali Mansoor',
                                style: TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Amount Section
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                const Text('Enter Amount', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '500',
                                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text('SAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                          Icon(Icons.keyboard_arrow_down, size: 16),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(LucideIcons.wallet, size: 14, color: Color(0xFF64748B)),
                                    const SizedBox(width: 8),
                                    const Text('Balance: 12,450.00 SAR', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: 100,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF166534),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'RECENT RECIPIENTS',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildRecentAvatar('Zaid K.', null, const Color(0xFF64748B)),
                              const SizedBox(width: 16),
                              _buildRecentAvatar('Sara H.', null, const Color(0xFF64748B)),
                              const SizedBox(width: 16),
                              _buildRecentAvatar('Fahad', 'FA', const Color(0xFFDBEAFE)),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B132B),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Continue', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 12),
                                  Icon(LucideIcons.arrowRight, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Transfer Summary
                    const Text(
                      'Transfer Summary',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('Amount', '500.00 SAR'),
                          const Divider(height: 32, thickness: 1, color: Color(0xFFF1F5F9)),
                          _buildSummaryRow('Transfer Fee', 'Free', isGreen: true),
                          const Divider(height: 32, thickness: 1, color: Color(0xFFF1F5F9)),
                          _buildSummaryRow('Estimated Time', 'Instant'),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total to Pay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              const Text('500.00 SAR', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFDCFCE7)),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.shieldCheck, color: Color(0xFF166534), size: 20),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Secured Payment', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4),
                                      Text(
                                        'Your transaction is protected by end-to-end encryption and 3D security layers.',
                                        style: TextStyle(color: Color(0xFF166534), fontSize: 12, height: 1.4),
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
                    const SizedBox(height: 24),
                    // Bottom Verification Bar
                    Container(
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
                            decoration: BoxDecoration(color: const Color(0xFF0B132B), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Identity Verified', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                Text('Level 3 Clearance', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981)),
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
        currentIndex: 1, // Send selected
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

  Widget _buildRecentAvatar(String name, String? initials, Color bgColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: initials != null ? bgColor : const Color(0xFFF1F5F9),
          child: initials != null 
            ? Text(initials, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)))
            : const Icon(LucideIcons.user, color: Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF475569))),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            color: isGreen ? const Color(0xFF10B981) : const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
