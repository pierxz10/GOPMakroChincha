import 'package:flutter/material.dart';

import '../../models/lost_object.dart';

class ObjectFilters extends StatelessWidget {
  const ObjectFilters({
    required this.category,
    required this.status,
    required this.onCategoryChanged,
    required this.onStatusChanged,
    super.key,
  });

  final ObjectCategory? category;
  final ObjectStatus? status;
  final ValueChanged<ObjectCategory?> onCategoryChanged;
  final ValueChanged<ObjectStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categoría', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Todas'),
              selected: category == null,
              onSelected: (_) => onCategoryChanged(null),
            ),
            for (final value in ObjectCategory.values)
              ChoiceChip(
                label: Text(value.label),
                selected: category == value,
                onSelected: (_) =>
                    onCategoryChanged(category == value ? null : value),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Estado', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Todos'),
              selected: status == null,
              onSelected: (_) => onStatusChanged(null),
            ),
            for (final value in ObjectStatus.values)
              ChoiceChip(
                label: Text(value.label),
                selected: status == value,
                onSelected: (_) =>
                    onStatusChanged(status == value ? null : value),
              ),
          ],
        ),
      ],
    );
  }
}
