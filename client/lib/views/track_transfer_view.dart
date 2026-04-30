import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TrackTransferView extends StatelessWidget {
  const TrackTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Transfer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transfer ID: TX-9921033',
                style: TextStyle(color: AppColors.softSlateGray)),
            const SizedBox(height: 32),
            _buildTimelineItem(
              'Initiated',
              'Transfer instruction received.',
              '14:32 PM',
              isCompleted: true,
            ),
            _buildTimelineItem(
              'Security Layer',
              'Instructions encrypted with AES-256.',
              '14:32 PM',
              isCompleted: true,
            ),
            _buildTimelineItem(
              'Smart Routing',
              'Wallet route selected via pathfinding.',
              '14:33 PM',
              isCompleted: true,
            ),
            _buildTimelineItem(
              'In Transit',
              'Funds moving through network.',
              '14:33 PM',
              isActive: true,
            ),
            _buildTimelineItem(
              'Delivered',
              'Funds available in Recipient Wallet.',
              'Pending',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, String time,
      {bool isCompleted = false, bool isActive = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle
                  : (isActive
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off),
              color: isCompleted || isActive
                  ? AppColors.emeraldGreen
                  : AppColors.softSlateGray,
            ),
            Container(
              width: 2,
              height: 50,
              color: isCompleted
                  ? AppColors.emeraldGreen
                  : AppColors.softSlateGray.withOpacity(0.3),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isActive ? AppColors.emeraldGreen : null)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppColors.softSlateGray, fontSize: 12)),
              const SizedBox(height: 8),
              Text(time,
                  style: const TextStyle(
                      color: AppColors.softSlateGray,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
