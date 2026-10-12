import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/makro_widgets.dart';
import '../../models/lost_object.dart';

class ObjectCard extends StatelessWidget {
  const ObjectCard({
    required this.object,
    required this.onDetail,
    this.compact = false,
    this.isPublic = false,
    super.key,
  });
  final LostObject object;
  final VoidCallback onDetail;
  final bool compact;
  final bool isPublic;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!compact)
          Container(
            height: 120,
            color: MakroColors.softBlue,
            child: Center(child: MakroIcon(object.iconName, size: 56)),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (compact)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 64,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: MakroColors.softBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: MakroIcon(object.iconName, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _info(context)),
                  ],
                )
              else
                _info(context),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onDetail,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: MakroColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  minimumSize: const Size(48, 48),
                ),
                child: const Text('Ver detalle'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _info(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StatusBadge(object.status),
      const SizedBox(height: 8),
      Text(
        object.name,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 4),
      Text(
        isPublic
            ? object.category.label
            : '${object.reference} · ${object.category.label}',
        style: const TextStyle(fontSize: 12, color: MakroColors.muted),
      ),
      if (!isPublic) ...[
        const SizedBox(height: 6),
        Text(
          object.location,
          style: const TextStyle(fontSize: 12, color: MakroColors.muted),
        ),
      ],
      if (object.foundAt != null) ...[
        const SizedBox(height: 4),
        Text(
          formatDate(object.foundAt!, withTime: !isPublic),
          style: const TextStyle(fontSize: 12, color: MakroColors.muted),
        ),
      ],
    ],
  );
}
