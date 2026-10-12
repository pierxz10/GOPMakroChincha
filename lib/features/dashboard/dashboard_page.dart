import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../shared/widgets/makro_widgets.dart';
import '../objects/models/lost_object.dart';
import '../objects/presentation/objects_controller.dart';
import '../objects/presentation/widgets/object_card.dart';
import '../objects/presentation/widgets/object_dialogs.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.objects,
    required this.onRegister,
    super.key,
  });
  final ObjectsController objects;
  final VoidCallback onRegister;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: objects,
    builder: (context, _) {
      final all = objects.allObjects;
      final metrics = [
        ('Registrados', all.length, 'En la demostración'),
        (
          'En custodia',
          all.where((o) => o.status != ObjectStatus.returned).length,
          'Pendientes de devolución',
        ),
        (
          'En reclamo',
          all.where((o) => o.status == ObjectStatus.claimed).length,
          'Por revisar',
        ),
        (
          'Entregados',
          all.where((o) => o.status == ObjectStatus.returned).length,
          'Devolución registrada',
        ),
      ];
      return ListView(
        children: [
          const PageHeading(
            'Buen día, equipo',
            'Gestiona los objetos perdidos de la sede Chincha.',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: MakroColors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Un hallazgo bien registrado\nfacilita una devolución.',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: MakroColors.yellow),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Describe las características del objeto y dónde fue encontrado.',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: onRegister,
                  child: const Text('Registrar objeto'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (objects.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (objects.hasError)
            Column(
              children: [
                const Text('No se pudo cargar el resumen.'),
                OutlinedButton(
                  onPressed: objects.load,
                  child: const Text('Reintentar'),
                ),
              ],
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
                final columns = scale > 1.35
                    ? 1
                    : constraints.maxWidth >= 850
                    ? 4
                    : constraints.maxWidth >= 300
                    ? 2
                    : 1;
                final width =
                    (constraints.maxWidth - (columns - 1) * 16) / columns;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final metric in metrics)
                      SizedBox(
                        width: width,
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  metric.$1,
                                  style: const TextStyle(
                                    color: MakroColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${metric.$2}',
                                  key: ValueKey('metric-${metric.$1}'),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    height: 1.25,
                                    color: MakroColors.blue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  metric.$3,
                                  style: const TextStyle(
                                    color: MakroColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          const SizedBox(height: 24),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Últimos hallazgos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (!objects.isLoading && !objects.hasError && all.isEmpty)
                    const Text('Aún no hay hallazgos registrados.'),
                  for (final object in all.take(2)) ...[
                    ObjectCard(
                      object: object,
                      compact: true,
                      onDetail: () => showObjectDetails(context, object),
                    ),
                    const SizedBox(height: 16),
                  ],
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/objetos'),
                    child: const Text('Ver todos los objetos'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Datos de prueba · Los indicadores se calculan desde el listado.',
            style: TextStyle(color: MakroColors.muted, fontSize: 12),
          ),
        ],
      );
    },
  );
}
