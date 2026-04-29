import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ConfirmPaymentView extends StatelessWidget {
  final Map<String, dynamic> data;
  const ConfirmPaymentView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final String recipientId = data['id'] ?? 'unknown@arabpay';
    final double amount = data['amount'] ?? 0.0;
    final routeResult = provider.getRouteResult(amount);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              '$amount SAR',
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightNavy),
            ),
            Text('To ($recipientId)',
                style: const TextStyle(color: AppColors.softSlateGray)),
            const SizedBox(height: 48),
            CustomCard(
              child: Column(
                children: [
                  _buildRow(
                    'Selected Route',
                    routeResult?.method.type == 'wallet'
                        ? 'Smart Wallet Route'
                        : 'Direct Bank Route',
                    icon: routeResult?.method.type == 'wallet'
                        ? LucideIcons.zap
                        : LucideIcons.building,
                    iconColor: routeResult?.method.type == 'wallet'
                        ? Colors.orange
                        : AppColors.midnightNavy,
                  ),
                  const Divider(height: 32),
                  _buildRow('Fee', '${routeResult?.fee.toStringAsFixed(2)} SAR',
                      color: Colors.redAccent),
                  const Divider(height: 32),
                  _buildRow('Conversion Rate', '1.00 SAR = 1.00 SAR'),
                  const Divider(height: 32),
                  _buildRow('Estimated Arrival', 'Instant'),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Authorize Transfer',
              onPressed: () => context.go('/money-delivered', extra: data),
            ),
            const SizedBox(height: 16),
            const Text(
              'Protected by ArabPay Security Layer',
              style: TextStyle(fontSize: 12, color: AppColors.softSlateGray),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value,
      {IconData? icon, Color? iconColor, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.softSlateGray)),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
            ],
            Text(value,
                style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ],
    );
  }
}
