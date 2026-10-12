import 'package:flutter/material.dart';

import '../../../shared/widgets/responsive_content.dart';
import '../../../app/theme.dart';
import '../data/objects_repository.dart';
import 'objects_controller.dart';
import 'widgets/object_card.dart';
import 'widgets/object_filters.dart';

class ObjectsPage extends StatefulWidget {
  const ObjectsPage({required this.repository, super.key});

  final ObjectsRepository repository;

  @override
  State<ObjectsPage> createState() => _ObjectsPageState();
}

class _ObjectsPageState extends State<ObjectsPage> {
  late final ObjectsController _controller;
  final _search = TextEditingController();
  final _location = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ObjectsController(widget.repository)..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _search.dispose();
    _location.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _search.clear();
    _location.clear();
    _controller.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo/makro-logo.png',
              width: 104,
              semanticLabel: 'Makro',
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text('Chincha', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      body: ResponsiveContent(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final objects = _controller.visibleObjects;
            final showMessage =
                _controller.isLoading ||
                _controller.hasError ||
                objects.isEmpty;
            return LayoutBuilder(
              builder: (context, constraints) {
                final scaled = MediaQuery.textScalerOf(context).scale(14) / 14;
                final columns = scaled > 1.4
                    ? 1
                    : constraints.maxWidth >= 1000
                    ? 3
                    : constraints.maxWidth >= 600
                    ? 2
                    : 1;
                final rows = (objects.length / columns).ceil();
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: showMessage ? 2 : rows + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeader(context, objects.length);
                    }
                    if (showMessage) return _buildMessage();
                    final start = (index - 1) * columns;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int resultCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Objetos perdidos',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Datos de demostración'),
        const SizedBox(height: 8),
        const Text(
          'Encuentra y consulta los objetos hallados en la tienda.',
          style: TextStyle(color: MakroColors.muted),
        ),
        const SizedBox(height: 20),
        TextField(
          key: const ValueKey('objects-search'),
          controller: _search,
          onChanged: _controller.setQuery,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: 'Buscar objetos',
            hintText: 'Nombre, código o ubicación',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Borrar búsqueda',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _search.clear();
                      _controller.setQuery('');
                    },
                  ),
          ),
        ),
        const SizedBox(height: 20),
        ObjectFilters(
          category: _controller.category,
          status: _controller.status,
          onCategoryChanged: _controller.setCategory,
          onStatusChanged: _controller.setStatus,
        ),
        const SizedBox(height: 20),
        TextField(
          key: const ValueKey('objects-location'),
          controller: _location,
          onChanged: _controller.setLocation,
          decoration: const InputDecoration(
            labelText: 'Lugar del hallazgo',
            hintText: 'Ej. Área de cajas',
            prefixIcon: Icon(Icons.place_outlined),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              initialDateRange: _controller.from == null
                  ? null
                  : DateTimeRange(
                      start: _controller.from!,
                      end: _controller.until!,
                    ),
              helpText: 'Fecha del hallazgo',
            );
            if (!mounted || range == null) return;
            _controller.setDateRange(range.start, range.end);
          },
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text(
            _controller.from == null
                ? 'Filtrar por fechas'
                : '${_date(_controller.from!)} — ${_date(_controller.until!)}',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!_controller.isLoading && !_controller.hasError)
              Semantics(
                liveRegion: true,
                child: Text(
                  '$resultCount ${resultCount == 1 ? 'objeto' : 'objetos'}',
                ),
              ),
            if (_controller.hasFilters)
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off_outlined),
                label: const Text('Limpiar filtros'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessage() {
    if (_controller.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(semanticsLabel: 'Cargando objetos'),
        ),
      );
    }
    if (_controller.hasError) {
      return Column(
        children: [
          const Text('No se pudieron cargar los objetos.'),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _controller.load,
            child: const Text('Reintentar'),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        _controller.hasFilters
            ? 'No encontramos objetos con esa búsqueda y esos filtros.'
            : 'Aún no hay objetos registrados.',
        textAlign: TextAlign.center,
      ),
    );
  }

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
