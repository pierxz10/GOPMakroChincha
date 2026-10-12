import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/makro_widgets.dart';
import '../../auth/session_controller.dart';
import 'objects_controller.dart';
import 'widgets/object_card.dart';
import 'widgets/object_dialogs.dart';

class ObjectsPage extends StatefulWidget {
  const ObjectsPage({
    required this.controller,
    required this.role,
    required this.onRegister,
    super.key,
  });
  final ObjectsController controller;
  final UserRole role;
  final VoidCallback onRegister;
  @override
  State<ObjectsPage> createState() => _ObjectsPageState();
}

class _ObjectsPageState extends State<ObjectsPage> {
  late final TextEditingController _search;
  @override
  void initState() {
    super.initState();
    _search = TextEditingController(text: widget.controller.query);
    widget.controller.addListener(_sync);
  }

  void _sync() {
    if (_search.text != widget.controller.query) {
      _search.value = TextEditingValue(
        text: widget.controller.query,
        selection: TextSelection.collapsed(
          offset: widget.controller.query.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final controller = widget.controller;
      final objects = controller.visibleObjects;
      final message =
          controller.isLoading || controller.hasError || objects.isEmpty;
      return LayoutBuilder(
        builder: (context, constraints) {
          final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
          final columns = scale > 1.35
              ? 1
              : constraints.maxWidth >= 950
              ? 3
              : constraints.maxWidth >= 550
              ? 2
              : 1;
          final compact = constraints.maxWidth < 550 && scale <= 1.35;
          final rows = (objects.length / columns).ceil();
          return ListView.separated(
            key: const ValueKey('objects-scroll'),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: message ? 2 : rows + 1,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _header(context, constraints.maxWidth, objects.length);
              }
              if (message) return _message();
              final start = (index - 1) * columns;
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var offset = 0; offset < columns; offset++) ...[
                      if (offset > 0) const SizedBox(width: 16),
                      Expanded(
                        child: start + offset < objects.length
                            ? ObjectCard(
                                key: ValueKey(
                                  objects[start + offset].reference,
                                ),
                                object: objects[start + offset],
                                compact: compact,
                                isPublic: !widget.role.isStaff,
                                onDetail: () => showObjectDetails(
                                  context,
                                  objects[start + offset],
                                  isPublic: !widget.role.isStaff,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
  Widget _header(BuildContext context, double width, int count) {
    final search = TextField(
      key: const ValueKey('objects-search'),
      controller: _search,
      onChanged: widget.controller.setQuery,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: 'Buscar objeto',
        hintText: widget.role.isStaff
            ? 'Nombre, código o descripción'
            : 'Tipo de objeto',
        suffixIcon: _search.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Borrar búsqueda',
                onPressed: () => widget.controller.setQuery(''),
                icon: const Icon(Icons.close),
              ),
      ),
    );
    final actions = [
      OutlinedButton.icon(
        key: const ValueKey('open-filters'),
        onPressed: () => Navigator.pushNamed(context, '/filtros'),
        icon: const MakroIcon('sliders-horizontal', size: 18),
        label: const Text('Filtros'),
      ),
      if (widget.role.canRegister)
        FilledButton(
          key: const ValueKey('register-object'),
          onPressed: widget.onRegister,
          child: const Text('Registrar objeto'),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(
          widget.role.isStaff
              ? 'Objetos registrados'
              : '¿Perdiste algún objeto?',
          widget.role.isStaff
              ? 'Busca por nombre, código o lugar del hallazgo.'
              : 'Consulta los objetos disponibles en Makro Chincha sin una cuenta.',
        ),
        const SizedBox(height: 24),
        if (width >= 800 && MediaQuery.textScalerOf(context).scale(14) <= 21)
          Row(
            children: [
              Expanded(child: search),
              const SizedBox(width: 16),
              for (final action in actions) ...[
                action,
                const SizedBox(width: 16),
              ],
            ],
          )
        else ...[
          search,
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 12, children: actions),
        ],
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!widget.controller.isLoading && !widget.controller.hasError)
              Semantics(
                liveRegion: true,
                child: Text(
                  '$count ${count == 1 ? 'objeto' : 'objetos'} ${widget.role.isStaff ? (count == 1 ? 'registrado' : 'registrados') : (count == 1 ? 'disponible' : 'disponibles')}',
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: MakroColors.softBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.controller.hasFilters
                    ? 'Con filtros'
                    : widget.role.isStaff
                    ? 'Todos'
                    : 'Disponibles',
                style: const TextStyle(fontSize: 12, color: MakroColors.blue),
              ),
            ),
            if (widget.controller.hasFilters)
              TextButton(
                onPressed: widget.controller.clearFilters,
                child: const Text('Limpiar filtros'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Datos de prueba · Demostración',
          style: TextStyle(fontSize: 12, color: MakroColors.muted),
        ),
      ],
    );
  }

  Widget _message() {
    if (widget.controller.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(semanticsLabel: 'Cargando objetos'),
        ),
      );
    }
    if (widget.controller.hasError) {
      return Column(
        children: [
          const Text('No se pudieron cargar los objetos.'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: widget.controller.load,
            child: const Text('Reintentar'),
          ),
        ],
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const MakroIcon('package-search', size: 48),
            const SizedBox(height: 16),
            Text(
              widget.controller.hasFilters
                  ? 'No encontramos objetos con esa búsqueda y esos filtros.'
                  : 'Aún no hay objetos disponibles.',
              textAlign: TextAlign.center,
            ),
            if (widget.controller.hasFilters)
              TextButton(
                onPressed: widget.controller.clearFilters,
                child: const Text('Limpiar filtros'),
              ),
          ],
        ),
      ),
    );
  }
}
