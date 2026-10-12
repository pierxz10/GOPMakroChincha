import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/lost_object.dart';
import '../../../../app/theme.dart';

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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: MakroColors.softBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SvgPicture.asset(
                  switch (object.category) {
                    ObjectCategory.electronics => 'assets/icons/smartphone.svg',
                    ObjectCategory.documents => 'assets/icons/file-check-2.svg',
                    ObjectCategory.accessories => 'assets/icons/backpack.svg',
                    ObjectCategory.other => 'assets/icons/package-search.svg',
                  },
                  colorFilter: const ColorFilter.mode(
                    MakroColors.blue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: object.status == ObjectStatus.returned
                        ? MakroColors.softBlue
                        : const Color(0xFFEAF7F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Estado: ${object.status.label}',
                    style: TextStyle(
                      color: object.status == ObjectStatus.returned
                          ? MakroColors.blue
                          : const Color(0xFF096846),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Ubicación: ${object.location}'),
            if (object.foundAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Hallazgo: ${object.foundAt!.day}/${object.foundAt!.month}/${object.foundAt!.year}',
                style: const TextStyle(color: MakroColors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
