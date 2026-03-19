import 'package:flutter/material.dart';
import 'package:fund_management/core/theme/app_colors.dart';
import 'package:fund_management/shared/widgets/app_card.dart';

class SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final Color? accent;

  const SummaryTile({
    super.key,
    required this.title,
    required this.value,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: accent ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
