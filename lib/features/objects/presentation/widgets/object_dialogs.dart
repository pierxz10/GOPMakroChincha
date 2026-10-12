import 'package:flutter/material.dart';
import '../../../../shared/widgets/makro_widgets.dart';
import '../../models/lost_object.dart';

Future<void> showObjectDetails(
  BuildContext context,
  LostObject object, {
  bool isPublic = false,
}) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(object.name),
    content: SizedBox(
      width: 480,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: MakroIcon(object.iconName, size: 64)),
            const SizedBox(height: 24),
            StatusBadge(object.status),
            const SizedBox(height: 16),
            Text('Categoría: ${object.category.label}'),
            if (object.foundAt != null)
              Text(
                'Hallazgo: ${formatDate(object.foundAt!, withTime: !isPublic)}',
              ),
            const SizedBox(height: 16),
            if (!isPublic) ...[
              Text('Código: ${object.reference}'),
              Text('Lugar: ${object.location}'),
              const SizedBox(height: 16),
              Text(object.description),
            ] else
              const Text(
                'Si crees que es tuyo, acércate a Atención al Cliente de Makro Chincha. Describe sus características para que el personal pueda verificarlo.',
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cerrar'),
      ),
    ],
  ),
);

class RegisterObjectDialog extends StatefulWidget {
  const RegisterObjectDialog({super.key});
  @override
  State<RegisterObjectDialog> createState() => _RegisterObjectDialogState();
}

class _RegisterObjectDialogState extends State<RegisterObjectDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _location = TextEditingController();
  ObjectCategory _category = ObjectCategory.accessories;
  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Registrar objeto'),
    content: SizedBox(
      width: 520,
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Registro de prueba. Se conserva durante esta ejecución de la aplicación.',
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('new-object-name'),
                controller: _name,
                maxLength: 80,
                decoration: const InputDecoration(
                  labelText: 'Nombre del objeto',
                ),
                validator: (s) => (s?.trim().length ?? 0) < 3
                    ? 'Escribe al menos 3 caracteres.'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ObjectCategory>(
                initialValue: _category,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: [
                  for (final c in ObjectCategory.values)
                    DropdownMenuItem(value: c, child: Text(c.label)),
                ],
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('new-object-location'),
                controller: _location,
                maxLength: 80,
                decoration: const InputDecoration(
                  labelText: 'Lugar del hallazgo',
                ),
                validator: (s) => (s?.trim().length ?? 0) < 3
                    ? 'Indica el lugar del hallazgo.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('new-object-description'),
                controller: _description,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (s) => (s?.trim().length ?? 0) < 8
                    ? 'Describe el objeto con al menos 8 caracteres.'
                    : null,
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          if (!_form.currentState!.validate()) return;
          Navigator.pop(
            context,
            LostObject(
              reference: '',
              name: _name.text.trim(),
              description: _description.text.trim(),
              location: _location.text.trim(),
              category: _category,
              status: ObjectStatus.inCustody,
              foundAt: DateTime.now(),
              iconName: switch (_category) {
                ObjectCategory.accessories => 'backpack',
                ObjectCategory.electronics => 'smartphone',
                ObjectCategory.documents => 'file-check-2',
                ObjectCategory.other => 'package-search',
              },
            ),
          );
        },
        child: const Text('Guardar objeto'),
      ),
    ],
  );
}
