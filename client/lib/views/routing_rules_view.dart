import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/linked_method.dart';

class RoutingRulesView extends StatefulWidget {
  const RoutingRulesView({super.key});

  @override
  State<RoutingRulesView> createState() => _RoutingRulesViewState();
}

class _RoutingRulesViewState extends State<RoutingRulesView> {
  late final List<Map<String, dynamic>> _rules;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    if (provider.configuredRoutingRules != null) {
      _rules = provider.configuredRoutingRules!.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      _rules = [
      {
        'id': 'small_payments',
        'title': 'Small Payments Routing',
        'description': 'Instantly route transactions under a specified amount to a selected wallet for immediate liquidity.',
        'icon': LucideIcons.wallet,
        'iconBg': const Color(0xFF6EE7B7),
        'iconColor': Colors.white,
        'isEnabled': true,
        'hasThreshold': true,
        'thresholdLabel': 'Amount Under (SAR)',
        'thresholdValue': '500',
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'large_payments',
        'title': 'Large Payments Routing',
        'description': 'Direct high-value payments exceeding your threshold to a secure bank account.',
        'icon': LucideIcons.landmark,
        'iconBg': const Color(0xFFDBEAFE),
        'iconColor': const Color(0xFF1D4ED8),
        'isEnabled': true,
        'hasThreshold': true,
        'thresholdLabel': 'Amount Over (SAR)',
        'thresholdValue': '5000',
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'local_transfers',
        'title': 'Local Transfers',
        'description': 'Settle same-country transfers via your preferred Local Bank for zero-fee processing.',
        'icon': LucideIcons.globe,
        'iconBg': const Color(0xFFDCFCE7),
        'iconColor': const Color(0xFF166534),
        'isEnabled': true,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'international',
        'title': 'International Transfers',
        'description': 'Route foreign currency transfers directly to your Multi-Currency account to avoid high FX conversion fees.',
        'icon': LucideIcons.plane,
        'iconBg': const Color(0xFFFEF3C7),
        'iconColor': const Color(0xFFD97706),
        'isEnabled': false,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'business',
        'title': 'Business & Corporate',
        'description': 'Automatically route B2B and corporate payments to your designated Business Account to separate tax liabilities.',
        'icon': LucideIcons.briefcase,
        'iconBg': const Color(0xFFF3E8FF),
        'iconColor': const Color(0xFF7E22CE),
        'isEnabled': true,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'salary',
        'title': 'Salary & Payroll',
        'description': 'Detect and route your primary salary deposits directly to your Main Bank Account for safe keeping.',
        'icon': LucideIcons.banknote,
        'iconBg': const Color(0xFFE0E7FF),
        'iconColor': const Color(0xFF4338CA),
        'isEnabled': true,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'weekend',
        'title': 'Weekend & Holiday Transfers',
        'description': 'During non-banking hours, route all incoming funds to a 24/7 Mobile Wallet to ensure immediate availability.',
        'icon': LucideIcons.calendar,
        'iconBg': const Color(0xFFFFEDD5),
        'iconColor': const Color(0xFFC2410C),
        'isEnabled': false,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'government',
        'title': 'Government Subsidies',
        'description': 'Ensure strict compliance by routing all government support/subsidies directly to your verified National Bank Account.',
        'icon': LucideIcons.building,
        'iconBg': const Color(0xFFFFE4E6),
        'iconColor': const Color(0xFFE11D48),
        'isEnabled': true,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'crypto',
        'title': 'Crypto Withdrawals',
        'description': 'Isolate funds from digital asset exchanges into a dedicated Digital Wallet to prevent your main account from being flagged.',
        'icon': LucideIcons.bitcoin,
        'iconBg': const Color(0xFFFEF9C3),
        'iconColor': const Color(0xFFA16207),
        'isEnabled': false,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'micropayments',
        'title': 'Micro-Payments & Bill Splits',
        'description': 'Batch small, high-frequency payments into a Secondary Wallet to keep your main bank statement clean.',
        'icon': LucideIcons.split,
        'iconBg': const Color(0xFFFCE7F3),
        'iconColor': const Color(0xFFBE185D),
        'isEnabled': true,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
      {
        'id': 'rewards',
        'title': 'Cashback & Rewards',
        'description': 'Route promotional cashback and platform rewards into a specific Savings pocket to compound interest.',
        'icon': LucideIcons.gift,
        'iconBg': const Color(0xFFCCFBF1),
        'iconColor': const Color(0xFF0F766E),
        'isEnabled': true,
        'hasThreshold': false,
        'hasAccountSelector': true,
        'selectedAccountId': null,
      },
    ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final linkedMethods = provider.linkedMethods;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
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
                    const SizedBox(height: 8),
                    const Text(
                      'Smart Routing Rules',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dynamically build rules
                    ..._rules.asMap().entries.map((entry) {
                      final index = entry.key;
                      final rule = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildRuleCard(
                          index: index,
                          rule: rule,
                          linkedMethods: linkedMethods,
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sticky Save Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AppProvider>().saveConfiguredRoutingRules(_rules);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(LucideIcons.checkCircle2, color: Colors.white),
                            const SizedBox(width: 12),
                            const Text('Routing preferences saved!', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        backgroundColor: const Color(0xFF065F46),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(20),
                      ),
                    );
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Save Routing Preferences',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
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
        currentIndex: 3,
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

  Widget _buildRuleCard({
    required int index,
    required Map<String, dynamic> rule,
    required List<LinkedMethod> linkedMethods,
  }) {
    final bool isEnabled = rule['isEnabled'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isEnabled ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0)),
        boxShadow: isEnabled
            ? [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isEnabled ? rule['iconBg'] : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(rule['icon'], color: isEnabled ? rule['iconColor'] : Colors.grey, size: 20),
              ),
              Switch(
                value: isEnabled,
                onChanged: (val) {
                  setState(() {
                    rule['isEnabled'] = val;
                  });
                },
                activeColor: const Color(0xFF166534),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            rule['title'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isEnabled ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rule['description'],
            style: TextStyle(
              fontSize: 13,
              color: isEnabled ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),
          
          // Interactive settings block appears when the rule is enabled
          if (isEnabled && (rule['hasThreshold'] == true || rule['hasAccountSelector'] == true)) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rule['hasThreshold'] == true) ...[
                    Text(rule['thresholdLabel'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: rule['thresholdValue'],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
                      ),
                      onChanged: (val) {
                        rule['thresholdValue'] = val;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (rule['hasAccountSelector'] == true) ...[
                    const Text('Destination Account', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _getValidSelectedAccountId(rule['selectedAccountId'], linkedMethods),
                          hint: const Text('Select a bank or wallet'),
                          icon: const Icon(LucideIcons.chevronDown, size: 20),
                          items: linkedMethods.map((method) {
                            return DropdownMenuItem<String>(
                              value: method.id,
                              child: Row(
                                children: [
                                  Icon(method.type == 'wallet' ? LucideIcons.wallet : LucideIcons.landmark, size: 16, color: const Color(0xFF64748B)),
                                  const SizedBox(width: 8),
                                  Text('${method.provider} (**** ${method.accountEnding})', style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              rule['selectedAccountId'] = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Helper to ensure the dropdown value is valid within the list
  String? _getValidSelectedAccountId(String? currentId, List<LinkedMethod> methods) {
    if (methods.isEmpty) return null;
    if (currentId != null && methods.any((m) => m.id == currentId)) {
      return currentId;
    }
    return null; // Let the hint show if no matching account is found or selected
  }
}
