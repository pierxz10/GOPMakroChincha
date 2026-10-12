import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/theme.dart';
import '../../features/objects/models/lost_object.dart';

class MakroIcon extends StatelessWidget {
  const MakroIcon(
    this.name, {
    this.size = 24,
    this.color = MakroColors.blue,
    super.key,
  });
  final String name;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: SvgPicture.asset(
      'assets/icons/$name.svg',
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    ),
  );
}

class MakroBrand extends StatelessWidget {
  const MakroBrand({super.key});
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/logo/makro-logo.png',
    width: 128,
    height: 31,
    semanticLabel: 'Makro',
    fit: BoxFit.contain,
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(color: MakroColors.muted)),
    ],
  );
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key});
  final ObjectStatus status;
  @override
  Widget build(BuildContext context) {
    final (color, background) = switch (status) {
      ObjectStatus.inCustody => (MakroColors.blue, MakroColors.softBlue),
      ObjectStatus.claimed => (MakroColors.warning, MakroColors.softWarning),
      ObjectStatus.returned => (MakroColors.success, MakroColors.softSuccess),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status.label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

String formatDate(DateTime date, {bool withTime = false}) {
  String two(int value) => value.toString().padLeft(2, '0');
  final day = '${two(date.day)}/${two(date.month)}/${date.year}';
  return withTime ? '$day · ${two(date.hour)}:${two(date.minute)}' : day;
}
