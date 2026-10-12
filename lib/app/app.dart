import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../features/auth/login_page.dart';
import '../features/auth/session_controller.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/objects/data/objects_repository.dart';
import '../features/objects/models/lost_object.dart';
import '../features/objects/presentation/filters_page.dart';
import '../features/objects/presentation/objects_controller.dart';
import '../features/objects/presentation/objects_page.dart';
import '../features/objects/presentation/widgets/object_dialogs.dart';
import 'app_shell.dart';
import 'theme.dart';

class GopApp extends StatefulWidget {
  const GopApp({required this.repository, this.initialRole, super.key});
  final ObjectsRepository repository;
  // Inyección de sesión para pruebas. La aplicación normal inicia en Acceso.
  final UserRole? initialRole;
  @override
  State<GopApp> createState() => _GopAppState();
}

class _GopAppState extends State<GopApp> {
  final _navigator = GlobalKey<NavigatorState>();
  late final SessionController _session;
  late final ObjectsController _objects;
  @override
  void initState() {
    super.initState();
    _session = SessionController(initialRole: widget.initialRole);
    _objects = ObjectsController(widget.repository);
    _objects.setPublicMode(widget.initialRole == UserRole.visitor);
    _objects.load();
  }

  @override
  void dispose() {
    _session.dispose();
    _objects.dispose();
    super.dispose();
  }

  void _enterStaff() {
    _objects.setPublicMode(false);
    _navigator.currentState!.pushNamedAndRemoveUntil('/inicio', (_) => false);
  }

  void _enterVisitor() {
    _session.enterAsVisitor();
    _objects.setPublicMode(true);
    _navigator.currentState!.pushNamedAndRemoveUntil('/objetos', (_) => false);
  }

  void _logout() {
    _session.signOut();
    _objects.setPublicMode(true);
    _navigator.currentState!.pushNamedAndRemoveUntil('/', (_) => false);
  }

  Future<void> _register() async {
    if (!(_session.role?.canRegister ?? false)) return;
    final result = await showDialog<LostObject>(
      context: _navigator.currentContext!,
      builder: (context) => const RegisterObjectDialog(),
    );
    if (!mounted || result == null || !(_session.role?.canRegister ?? false)) {
      return;
    }
    var next = 0;
    for (final object in _objects.allObjects) {
      final number = int.tryParse(object.reference.split('-').last) ?? 0;
      if (number > next) next = number;
    }
    final object = LostObject(
      reference: 'OBJ-${(next + 1).toString().padLeft(3, '0')}',
      name: result.name,
      description: result.description,
      location: result.location,
      category: result.category,
      status: result.status,
      foundAt: result.foundAt,
      iconName: result.iconName,
    );
    if (_session.registerObject(_objects, object)) {
      _objects.clearFilters();
      ScaffoldMessenger.of(_navigator.currentContext!).showSnackBar(
        const SnackBar(content: Text('Objeto registrado en la demostración.')),
      );
    }
  }

  Route<void> _route(RouteSettings settings) {
    final name = settings.name ?? '/';
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => AnimatedBuilder(
        animation: _session,
        builder: (context, _) {
          if (name == '/' || _session.role == null) {
            return LoginPage(
              session: _session,
              onEntered: _enterStaff,
              onVisitor: _enterVisitor,
            );
          }
          if (!_session.canOpen(name)) {
            return Scaffold(
              appBar: AppBar(title: const Text('Acceso no autorizado')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Tu perfil no tiene permiso para abrir esta sección.',
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/objetos'),
                        child: const Text('Volver a objetos'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final role = _session.role!;
          final body = switch (name) {
            '/inicio' => DashboardPage(
              objects: _objects,
              onRegister: _register,
            ),
            '/filtros' => FiltersPage(controller: _objects, role: role),
            _ => ObjectsPage(
              controller: _objects,
              role: role,
              onRegister: _register,
            ),
          };
          return AppShell(
            role: role,
            route: name,
            onLogout: _logout,
            child: body,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = widget.initialRole == null
        ? '/'
        : widget.initialRole!.isStaff
        ? '/inicio'
        : '/objetos';
    return MaterialApp(
      navigatorKey: _navigator,
      title: 'Objetos perdidos · Makro Chincha',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: start,
      onGenerateRoute: _route,
      onGenerateInitialRoutes: (_) => [_route(RouteSettings(name: start))],
    );
  }
}
