import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/makro_widgets.dart';
import '../../auth/session_controller.dart';
import '../models/lost_object.dart';
import 'objects_controller.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({required this.controller, required this.role, super.key});
  final ObjectsController controller;
  final UserRole role;
  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late final TextEditingController _query;
  late final TextEditingController _fromText;
  late final TextEditingController _untilText;
  ObjectCategory? _category;
  ObjectStatus? _status;
  String _location = '';
  DateTime? _from;
  DateTime? _until;
  String? _error;
  @override
  void initState() {
    super.initState();
    final c = widget.controller;
    _query = TextEditingController(text: c.query);
    _category = c.category;
    _status = c.status;
    _location = c.location;
    _from = c.from;
    _until = c.until;
    _fromText = TextEditingController(
      text: _from == null ? '' : formatDate(_from!),
    );
    _untilText = TextEditingController(
      text: _until == null ? '' : formatDate(_until!),
    );
  }

  @override
  void dispose() {
    _query.dispose();
    _fromText.dispose();
    _untilText.dispose();
    super.dispose();
  }

  void _back() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/objetos');
    }
  }

  void _apply() {
    if (_from != null && _until != null && _from!.isAfter(_until!)) {
      setState(
        () => _error = 'La fecha Desde debe ser anterior o igual a Hasta.',
      );
      return;
    }
    widget.controller.applyFilters(
      query: _query.text.trim(),
      category: _category,
      status: _status,
      location: _location,
      from: _from,
      until: _until,
    );
    _back();
  }

  void _clear() => setState(() {
    _query.clear();
    _fromText.clear();
    _untilText.clear();
    _category = null;
    _status = null;
    _location = '';
    _from = null;
    _until = null;
    _error = null;
    widget.controller.clearFilters();
  });
  Future<void> _pickDate(bool start) async {
    final current = start ? _from : _until;
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: current ?? DateTime.now(),
      helpText: start ? 'Desde' : 'Hasta',
    );
    if (!mounted || date == null) return;
    setState(() {
      if (start) {
        _from = date;
        _fromText.text = formatDate(date);
      } else {
        _until = date;
        _untilText.text = formatDate(date);
      }
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton(onPressed: _back, child: const Text('Volver')),
      ),
      const SizedBox(height: 12),
      const PageHeading(
        'Búsqueda y filtros',
        'Combina criterios para encontrar el objeto.',
      ),
      const SizedBox(height: 24),
      Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const ValueKey('filter-query'),
                controller: _query,
                decoration: InputDecoration(
                  labelText: widget.role.isStaff
                      ? 'Nombre, código o descripción'
                      : 'Tipo de objeto',
                ),
              ),
              const SizedBox(height: 24),
              _pair(
                context,
                _categoryField(),
                widget.role.isStaff ? _statusField() : null,
              ),
              const SizedBox(height: 24),
              _pair(
                context,
                TextField(
                  key: const ValueKey('filter-from'),
                  controller: _fromText,
                  readOnly: true,
                  onTap: () => _pickDate(true),
                  decoration: const InputDecoration(
                    labelText: 'Desde',
                    hintText: 'dd/mm/aaaa',
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
                TextField(
                  key: const ValueKey('filter-until'),
                  controller: _untilText,
                  readOnly: true,
                  onTap: () => _pickDate(false),
                  decoration: const InputDecoration(
                    labelText: 'Hasta',
                    hintText: 'dd/mm/aaaa',
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _error!,
                    style: const TextStyle(color: MakroColors.error),
                  ),
                ),
              ],
              if (widget.role.isStaff) ...[
                const SizedBox(height: 24),
                _locationField(),
              ],
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 16,
                runSpacing: 12,
                children: [
                  OutlinedButton(
                    onPressed: _clear,
                    child: const Text('Limpiar'),
                  ),
                  FilledButton(
                    key: const ValueKey('apply-filters'),
                    onPressed: _apply,
                    child: const Text('Aplicar filtros'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
  Widget _pair(BuildContext context, Widget first, Widget? second) =>
      LayoutBuilder(
        builder: (context, constraints) {
          if (second == null) return first;
          if (constraints.maxWidth < 550 ||
              MediaQuery.textScalerOf(context).scale(14) > 21) {
            return Column(
              children: [first, const SizedBox(height: 24), second],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: first),
              const SizedBox(width: 16),
              Expanded(child: second),
            ],
          );
        },
      );
  Widget _categoryField() => DropdownButtonFormField<ObjectCategory>(
    key: ValueKey('category-${_category?.name}'),
    initialValue: _category,
    isExpanded: true,
    decoration: const InputDecoration(labelText: 'Categoría'),
    hint: const Text('Todas las categorías'),
    items: [
      const DropdownMenuItem<ObjectCategory>(
        value: null,
        child: Text('Todas las categorías'),
      ),
      for (final c in ObjectCategory.values)
        if (widget.role.isStaff || c != ObjectCategory.documents)
          DropdownMenuItem(value: c, child: Text(c.label)),
    ],
    onChanged: (value) => setState(() => _category = value),
  );
  Widget _statusField() => DropdownButtonFormField<ObjectStatus>(
    key: ValueKey('status-${_status?.name}'),
    initialValue: _status,
    isExpanded: true,
    decoration: const InputDecoration(labelText: 'Estado'),
    hint: const Text('Todos'),
    items: [
      const DropdownMenuItem<ObjectStatus>(value: null, child: Text('Todos')),
      for (final s in ObjectStatus.values)
        DropdownMenuItem(value: s, child: Text(s.label)),
    ],
    onChanged: (value) => setState(() => _status = value),
  );
  Widget _locationField() => DropdownButtonFormField<String>(
    key: ValueKey('location-$_location'),
    initialValue: _location,
    isExpanded: true,
    decoration: const InputDecoration(labelText: 'Lugar del hallazgo'),
    items: [
      const DropdownMenuItem(value: '', child: Text('Todos los lugares')),
      for (final l in {
        ...widget.controller.locations,
        if (_location.isNotEmpty) _location,
      })
        DropdownMenuItem(value: l, child: Text(l)),
    ],
    onChanged: (value) => setState(() => _location = value ?? ''),
  );
}
