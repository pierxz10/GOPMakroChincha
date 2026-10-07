import 'package:flutter/material.dart';

import '../../../shared/widgets/responsive_content.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = ObjectsController(widget.repository)..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _search.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _search.clear();
    _controller.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objetos perdidos', overflow: TextOverflow.ellipsis),
      ),
      body: ResponsiveContent(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final objects = _controller.visibleObjects;
            final showMessage = _controller.isLoading ||
                _controller.hasError || objects.isEmpty;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: showMessage ? 2 : objects.length + 1,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeader(context, objects.length);
                if (showMessage) return _buildMessage();
                final object = objects[index - 1];
                return ObjectCard(
                  key: ValueKey(object.reference),
                  object: object,
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
        Text('Makro · Chincha', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('Datos de demostración'),
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
}
