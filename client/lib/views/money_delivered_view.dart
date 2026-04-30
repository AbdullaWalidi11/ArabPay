import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';

class MoneyDeliveredView extends StatelessWidget {
  final Map<String, dynamic> data;
  const MoneyDeliveredView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String recipientId = data['id'] ?? 'unknown@arabpay';
    final double amount = data['amount'] ?? 0.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.emeraldGreen,
              child: const Icon(Icons.check, size: 60, color: Colors.white),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.easeOutBack)
                .then()
                .shimmer(duration: 1.seconds),
            const SizedBox(height: 32),
            Text(
              'Money Delivered',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightNavy),
            ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
            const SizedBox(height: 16),
            Text(
              '$amount SAR has been successfully sent to ${data['name'] ?? recipientId}',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16, color: AppColors.softSlateGray, fontWeight: FontWeight.w500),
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 8),
            Text(
              recipientId,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.softSlateGray.withOpacity(0.7)),
            ).animate().fadeIn(delay: 700.ms),
            const Spacer(),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Track Transfer Status',
              onPressed: () => context.push('/track-transfer'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Back to Dashboard'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
