import 'package:flutter/material.dart';
import 'package:fund_management/shared/enums/fund_category.dart';

class FundCategoryFilter extends StatelessWidget {
  final FundCategory? selected;
  final ValueChanged<FundCategory?> onChanged;

  const FundCategoryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Todos'),
          selected: selected == null,
          onSelected: (_) => onChanged(null),
        ),
        for (final category in FundCategory.values)
          ChoiceChip(
            label: Text(category.label),
            selected: selected == category,
            onSelected: (_) => onChanged(category),
          ),
      ],
    );
  }
}
