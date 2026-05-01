import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SupportFaqView extends StatefulWidget {
  const SupportFaqView({super.key});

  @override
  State<SupportFaqView> createState() => _SupportFaqViewState();
}

class _SupportFaqViewState extends State<SupportFaqView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 'Account & Identity',
      'question': 'How do I verify my Saudi Digital Identity?',
      'answer':
          'Your Saudi Digital Identity is automatically synced with ArabPay using the highest-tier security. If your identity isn\'t verified, please go to your Profile and click "Verify Identity" to start the process.',
      'icon': LucideIcons.shieldCheck,
    },
    {
      'category': 'Payments & Routing',
      'question': 'How does the Smart Routing system work?',
      'answer':
          'Smart Routing analyzes transaction size, speed, and country of origin to auto-route your money to the optimal linked account with zero-fee processing.',
      'icon': LucideIcons.gitBranch,
    },
    {
      'category': 'Payments & Routing',
      'question': 'Are there any hidden fees for transfers?',
      'answer':
          'ArabPay is completely transparent. Small payments are instantly routed to your wallet, and local bank transfers are always zero-fee.',
      'icon': LucideIcons.wallet,
    },
    {
      'category': 'Security & Support',
      'question': 'What should I do if a payment fails?',
      'answer':
          'If a payment fails, do not worry. ArabPay will instantly securely return the funds to your default balance. Contact our 24/7 support team if the funds don\'t appear.',
      'icon': LucideIcons.alertCircle,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqs.where((faq) {
      final q = faq['question'].toString().toLowerCase();
      final a = faq['answer'].toString().toLowerCase();
      return q.contains(_searchQuery.toLowerCase()) ||
          a.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header (consistent design)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft,
                        color: Color(0xFF0F172A)),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/image/app_logo.png'),
                  ),
                  const Spacer(),
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
                    const Text(
                      'Support & FAQ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'How can we help you today?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search Input Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search for articles, questions...',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          icon: Icon(LucideIcons.search,
                              color: Color(0xFF94A3B8), size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Frequently Asked Questions Header
                    const Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (filteredFaqs.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            'No matching questions found.',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ),
                      )
                    else
                      ...filteredFaqs.map((faq) => _buildFaqTile(
                            faq['icon'] as IconData,
                            faq['question'] as String,
                            faq['answer'] as String,
                          )),

                    const SizedBox(height: 24),

                    // Contact Support Button
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xFF0F172A),
                    //     borderRadius: BorderRadius.circular(16),
                    //   ),
                    //   child: Material(
                    //     color: Colors.transparent,
                    //     child: InkWell(
                    //       onTap: () {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(
                    //             content: Text('Direct chat support initiated.'),
                    //             duration: Duration(seconds: 2),
                    //           ),
                    //         );
                    //       },
                    //       borderRadius: BorderRadius.circular(16),
                    //       child: const Padding(
                    //         padding: EdgeInsets.symmetric(vertical: 18.0),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Icon(LucideIcons.messageCircle, color: Colors.white, size: 22),
                    //             SizedBox(width: 12),
                    //             Text(
                    //               'Contact Live Chat Support',
                    //               style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(IconData icon, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0F172A), size: 20),
          ),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          childrenPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 44.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
