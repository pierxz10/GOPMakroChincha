import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../shared/widgets/makro_widgets.dart';
import 'session_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.session,
    required this.onEntered,
    required this.onVisitor,
    super.key,
  });
  final SessionController session;
  final VoidCallback onEntered;
  final VoidCallback onVisitor;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _error;
  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    if (widget.session.signIn(_username.text, _password.text)) {
      widget.onEntered();
    } else {
      setState(
        () => _error =
            'Usuario o contraseña incorrectos. Usa una cuenta de demostración.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            const MakroBrand(),
            if (constraints.maxWidth >= 440) ...[
              const SizedBox(width: 24),
              const Flexible(
                child: Text(
                  'Objetos perdidos',
                  style: TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final desktop =
            constraints.maxWidth >= 1024 &&
            MediaQuery.textScalerOf(context).scale(14) <= 21;
        final gap = desktop ? 48.0 : 0.0;
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(constraints.maxWidth < 600 ? 16 : 48),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 96).clamp(
                  0,
                  double.infinity,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: desktop ? 1040 : 480),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (desktop) ...[
                        Expanded(flex: 6, child: _hero(context)),
                        SizedBox(width: gap),
                      ],
                      Expanded(flex: 5, child: _formCard(context)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
  Widget _hero(BuildContext context) => Container(
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(
      color: MakroColors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cada objeto vuelve\na su dueño.',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: MakroColors.yellow),
        ),
        const SizedBox(height: 16),
        const Text(
          'Registra hallazgos, encuentra coincidencias y acompaña cada devolución desde un solo lugar.',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 64),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MakroIcon('backpack', size: 64, color: MakroColors.yellow),
            SizedBox(width: 32),
            MakroIcon('arrow-right', color: Colors.white),
            SizedBox(width: 32),
            MakroIcon('shield-check', size: 64, color: Colors.white),
          ],
        ),
        const SizedBox(height: 64),
        const Text(
          'Makro Chincha · Atención al Cliente',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
  );
  Widget _formCard(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenido',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: MakroColors.blue),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ingresa con tu cuenta de personal autorizado.',
              style: TextStyle(color: MakroColors.muted),
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const ValueKey('login-user'),
              controller: _username,
              autofillHints: const [AutofillHints.username],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                hintText: 'responsable.demo',
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Ingresa tu usuario.'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              key: const ValueKey('login-password'),
              controller: _password,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  tooltip: _obscure
                      ? 'Mostrar contraseña'
                      : 'Ocultar contraseña',
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Ingresa tu contraseña.'
                  : null,
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
            const SizedBox(height: 24),
            FilledButton(
              key: const ValueKey('login-submit'),
              onPressed: _submit,
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              key: const ValueKey('guest-entry'),
              onPressed: widget.onVisitor,
              child: const Text(
                'Consultar objetos sin cuenta',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Modo demostración · Sede Chincha',
              style: TextStyle(fontSize: 12, color: MakroColors.muted),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona un perfil para completar los datos de prueba:',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final entry in SessionController.demoAccounts.entries)
                  ActionChip(
                    label: Text(entry.value.label),
                    onPressed: () => setState(() {
                      _username.text = entry.key;
                      _password.text = SessionController.demoPassword;
                      _error = null;
                    }),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
