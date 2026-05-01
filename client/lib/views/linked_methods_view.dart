import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LinkedMethodsView extends StatefulWidget {
  const LinkedMethodsView({super.key});

  @override
  State<LinkedMethodsView> createState() => _LinkedMethodsViewState();
}

class _LinkedMethodsViewState extends State<LinkedMethodsView> {
  Map<String, Map<String, dynamic>> _institutionData = {};

  @override
  void initState() {
    super.initState();
    _loadInstitutionData();
  }

  Future<void> _loadInstitutionData() async {
    final String response =
        await rootBundle.loadString('assets/data/institutions.json');
    final data = json.decode(response);
    final List<dynamic> countriesJson = data['countries'];
    
    Map<String, Map<String, dynamic>> instData = {};
    for (var country in countriesJson) {
      for (var inst in country['institutions']) {
        instData[inst['name']] = inst;
      }
    }
    
    setState(() {
      _institutionData = instData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final methods = provider.linkedMethods;
    final bankMethods = methods.where((m) => m.type == 'bank').toList();
    final walletMethods = methods.where((m) => m.type == 'wallet').toList();

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

                    if (bankMethods.isNotEmpty) ...[
                      const Text(
                        'Bank Accounts',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 16),
                      ...bankMethods.map((method) {
                        final inst = _institutionData[method.provider];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildAccountCard(
                            logoUrl: inst?['logo_url'],
                            fallbackLogoUrl: inst?['fallback_logo_url'],
                            fallbackIcon: LucideIcons.landmark,
                            name: method.provider,
                            country: method.country,
                            currency: method.currency,
                            date: 'Apr 2024',
                            status: method.isActive ? 'Active' : 'Pending',
                            statusColor: method.isActive
                                ? const Color(0xFF1D4ED8)
                                : const Color(0xFF94A3B8),
                            statusBg: method.isActive
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF1F5F9),
                            isPreferred: method.isActive && (methods.indexOf(method) == 0), // Default logic if flag missing, or use property below
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                    ],

                    if (walletMethods.isNotEmpty) ...[
                      const Text(
                        'Mobile Wallets',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 16),
                      ...walletMethods.map((method) {
                        final inst = _institutionData[method.provider];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildAccountCard(
                            logoUrl: inst?['logo_url'],
                            fallbackLogoUrl: inst?['fallback_logo_url'],
                            fallbackIcon: LucideIcons.wallet,
                            name: method.provider,
                            country: method.country,
                            currency: method.currency,
                            date: 'Apr 2024',
                            status: method.isActive ? 'Active' : 'Pending',
                            statusColor: method.isActive
                                ? const Color(0xFF1D4ED8)
                                : const Color(0xFF94A3B8),
                            statusBg: method.isActive
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF1F5F9),
                            isPreferred: false,
                          ),
                        );
                      }).toList(),
                    ],
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

  Widget _buildAccountCard({
    String? logoUrl,
    String? fallbackLogoUrl,
    required IconData fallbackIcon,
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
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: logoUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                logoUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  if (fallbackLogoUrl != null) {
                                    return Image.network(
                                      fallbackLogoUrl,
                                      fit: BoxFit.contain,
                                    );
                                  }
                                  return Icon(fallbackIcon,
                                      color: const Color(0xFF1D4ED8),
                                      size: 24);
                                },
                              ),
                            )
                          : Icon(fallbackIcon,
                              color: const Color(0xFF1D4ED8),
                              size: 24),
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
