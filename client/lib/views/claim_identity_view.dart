import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';

class ClaimIdentityView extends StatefulWidget {
  const ClaimIdentityView({super.key});

  @override
  State<ClaimIdentityView> createState() => _ClaimIdentityViewState();
}

class _ClaimIdentityViewState extends State<ClaimIdentityView> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.text = "";
    // Reset availability state when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().resetAvailability();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Pattern (Simulated)
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) => const Icon(
                    LucideIcons.star,
                    size: 80,
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Custom App Bar
                  Row(
                    children: [
                      // const CircleAvatar(
                      //   radius: 32,
                      //   backgroundColor: Colors.transparent,
                      //   backgroundImage:
                      //       AssetImage('assets/image/app_logo.png'),
                      // ),
                      // const SizedBox(width: 12),
                      // const Text(
                      //   'ArabPay',
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     color: Color(0xFF0F172A),
                      //   ),
                      // ),
                      const Spacer(),
                      // IconButton(
                      //   icon: const Icon(LucideIcons.bell,
                      //       color: Color(0xFF64748B)),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Top Shield Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(LucideIcons.shieldCheck,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 32),

                  // Main Titles
                  const Text(
                    'Claim your payment identity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This is the only thing you need to share to receive money.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Alias Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose your alias',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Custom Input Field
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '@',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF0F172A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  onChanged: (val) {
                                    if (provider.error != null) {
                                      provider.clearError();
                                    }

                                    if (_debounce?.isActive ?? false)
                                      _debounce?.cancel();
                                    _debounce = Timer(
                                        const Duration(milliseconds: 500), () {
                                      // Simulation: "ahmed", "ali", "sara", "ayman" are taken
                                      final normalized = val
                                          .toLowerCase()
                                          .trim()
                                          .replaceFirst('@arabpay', '');
                                      if (normalized == 'ahmed' ||
                                          normalized == 'ali' ||
                                          normalized == 'sara' ||
                                          normalized == 'ayman') {
                                        provider.setAvailability(false);
                                      } else {
                                        provider.checkAvailability(val);
                                      }
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const Text(
                                'ARABPAY',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF94A3B8),
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Availability Status
                        Row(
                          children: [
                            if (provider.isCheckingAvailability)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Color(0xFF0B132B)),
                              )
                            else if (provider.error != null &&
                                provider.error!.contains('taken'))
                              const Icon(LucideIcons.xCircle,
                                  color: Colors.red, size: 18)
                            else if (provider.isAliasAvailable == true)
                              const Icon(LucideIcons.checkCircle2,
                                  color: Colors.green, size: 18)
                            else if (provider.isAliasAvailable == false)
                              const Icon(LucideIcons.xCircle,
                                  color: Colors.red, size: 18)
                            else
                              const Icon(LucideIcons.circle,
                                  color: Color(0xFF94A3B8), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              provider.isCheckingAvailability
                                  ? 'Checking...'
                                  : (provider.error != null &&
                                          provider.error!.contains('taken')
                                      ? 'Not Available'
                                      : (provider.isAliasAvailable == true
                                          ? 'Available'
                                          : (provider.isAliasAvailable == false
                                              ? 'Not Available'
                                              : 'Enter an alias'))),
                              style: TextStyle(
                                color: provider.isCheckingAvailability
                                    ? const Color(0xFF64748B)
                                    : (provider.error != null &&
                                            provider.error!.contains('taken')
                                        ? Colors.red
                                        : (provider.isAliasAvailable == true
                                            ? Colors.green
                                            : (provider.isAliasAvailable ==
                                                    false
                                                ? Colors.red
                                                : const Color(0xFF94A3B8)))),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (provider.error != null &&
                            provider.error!.contains('taken'))
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              provider.error!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 32),
                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: () async {
                              final success = await provider
                                  .claimIdentity(_controller.text);
                              if (success && mounted) {
                                context.go('/identity-success');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B132B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Create ArabPay ID',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(LucideIcons.arrowRight, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Security Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B132B),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.fingerprint,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Institutional Grade Security',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your ArabPay ID is cryptographically linked to your verified identity documents for secure, seamless settlements.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Suggestions
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0F172A),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
