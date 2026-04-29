import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChoosingRouteView extends StatefulWidget {
  final Map<String, dynamic> data;
  const ChoosingRouteView({super.key, required this.data});

  @override
  State<ChoosingRouteView> createState() => _ChoosingRouteViewState();
}

class _ChoosingRouteViewState extends State<ChoosingRouteView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) context.go('/confirm-payment', extra: widget.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightNavy,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ArabPay Smart Routing',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Calculating optimal path...',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 80),
            _buildAnimation(),
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.shield, color: AppColors.emeraldGreen, size: 16),
                  const SizedBox(width: 8),
                  const Text('Securing Instructions with AES-256', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ).animate().fadeIn(delay: 1.seconds).shimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Nodes
          _buildNode(const Offset(-100, 0), LucideIcons.wallet, 'Wallet'),
          _buildNode(const Offset(100, 0), LucideIcons.building2, 'Bank'),
          _buildNode(const Offset(0, -80), LucideIcons.globe, 'Network'),
          
          // Scanning lines/circles
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.emeraldGreen.withOpacity(0.3), width: 2),
            ),
          ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5)).fadeOut(),
          
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.emeraldGreen.withOpacity(0.5), width: 2),
            ),
          ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(0.2, 0.2)).fadeOut(),
        ],
      ),
    );
  }

  Widget _buildNode(Offset offset, IconData icon, String label) {
    return Transform.translate(
      offset: offset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.emeraldGreen.withOpacity(0.2),
            child: Icon(icon, color: AppColors.emeraldGreen),
          ).animate(onPlay: (c) => c.repeat()).shimmer(delay: 2.seconds),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}
