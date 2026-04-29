import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ConfirmRecipientView extends StatelessWidget {
  final Map<String, dynamic> data;
  const ConfirmRecipientView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String recipientId = data['id'] ?? 'unknown@arabpay';
    final double amount = data['amount'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Recipient')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Icon(LucideIcons.shieldCheck,
                size: 80, color: AppColors.emeraldGreen),
            const SizedBox(height: 24),
            const Text(
              'Recipient Verified',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emeraldGreen),
            ),
            const SizedBox(height: 32),
            CustomCard(
              child: Column(
                children: [
                  _buildInfoRow('ArabPay ID', recipientId),
                  const Divider(height: 32),
                  _buildInfoRow('Amount to Send', '$amount SAR'),
                  const Divider(height: 32),
                  //  _buildInfoRow('Full Name', 'Sara Khalid'), // Mock name for now
                  //const Divider(height: 32),
                  //  _buildInfoRow('Bank Country', 'United Arab Emirates'),
                  //  const Divider(height: 32),
                  _buildInfoRow('Safety Status', 'Trusted Member',
                      color: AppColors.emeraldGreen),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Confirm & Choose Route',
              onPressed: () => context.push('/choosing-route', extra: data),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.softSlateGray)),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
