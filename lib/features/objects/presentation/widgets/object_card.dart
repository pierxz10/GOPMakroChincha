import 'package:flutter/material.dart';

import '../../models/lost_object.dart';

class ObjectCard extends StatelessWidget {
  const ObjectCard({required this.object, super.key});

  final LostObject object;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(object.reference, style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(object.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(object.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Text('Categoría: ${object.category.label}'),
                Text('Estado: ${object.status.label}'),
              ],
            ),
            const SizedBox(height: 8),
            Text('Ubicación: ${object.location}'),
          ],
        ),
      ),
    );
  }
}
