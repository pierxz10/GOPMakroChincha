import 'package:flutter/material.dart';
import '../features/auth/session_controller.dart';
import '../shared/widgets/makro_widgets.dart';
import 'theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.role,
    required this.route,
    required this.child,
    required this.onLogout,
    super.key,
  });
  final UserRole role;
  final String route;
  final Widget child;
  final VoidCallback onLogout;

  void _navigate(BuildContext context, String target) {
    if (route == target) return;
    Navigator.of(context).pushNamed(target);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final mobile = constraints.maxWidth < 600;
      final compact = constraints.maxWidth < 1024;
      final expandedText = MediaQuery.textScalerOf(context).scale(14) > 21;
      final sidebar = !mobile && !expandedText;
      final destinations = role.isStaff
          ? const [
              ('/inicio', 'Inicio', 'layout-dashboard'),
              ('/objetos', 'Objetos', 'package-search'),
            ]
          : const [('/objetos', 'Objetos', 'package-search')];
      final active = route == '/filtros' ? '/objetos' : route;
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: mobile ? 64 : 72,
          titleSpacing: mobile ? 16 : 24,
          title: Row(
            children: [
              const MakroBrand(),
              if (!mobile && !expandedText) ...[
                const SizedBox(width: 24),
                const Expanded(
                  child: Text(
                    'Objetos perdidos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            if (!mobile && !expandedText)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  'Chincha · ${role.label}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            IconButton(
              tooltip: 'Perfil y permisos',
              onPressed: () => _showPermissions(context),
              icon: CircleAvatar(
                radius: 17,
                backgroundColor: const Color(0xFF002989),
                child: Text(
                  role.initials,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
            if (!sidebar)
              IconButton(
                key: const ValueKey('session-exit'),
                tooltip: role.isStaff ? 'Cerrar sesión' : 'Acceso del personal',
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: Row(
          children: [
            if (sidebar)
              SizedBox(
                width: compact ? 88 : 240,
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(compact ? 8 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!compact) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'SEDE CHINCHA',
                            style: TextStyle(
                              fontSize: 12,
                              color: MakroColors.muted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            role.isStaff
                                ? 'Atención al Cliente'
                                : 'Consulta pública',
                          ),
                          const SizedBox(height: 16),
                        ],
                        Expanded(
                          child: ListView(
                            children: [
                              for (final item in destinations)
                                _nav(
                                  context,
                                  item.$2,
                                  item.$3,
                                  selected: active == item.$1,
                                  compact: compact,
                                  action: () => _navigate(context, item.$1),
                                ),
                              if (role.isStaff)
                                _nav(
                                  context,
                                  'Reclamos',
                                  'clipboard-list',
                                  compact: compact,
                                ),
                              if (role.canViewReports)
                                _nav(
                                  context,
                                  'Reportes',
                                  'chart-column',
                                  compact: compact,
                                ),
                              if (role.canManageUsers)
                                _nav(
                                  context,
                                  'Administración',
                                  'users',
                                  compact: compact,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          key: const ValueKey('session-exit'),
                          onPressed: onLogout,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            side: const BorderSide(color: MakroColors.line),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          child: Text(
                            compact
                                ? 'Salir'
                                : role.isStaff
                                ? 'Cerrar sesión'
                                : 'Acceso del personal',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1440),
                    child: Padding(
                      padding: EdgeInsets.all(
                        mobile
                            ? 16
                            : compact
                            ? 24
                            : 32,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: !sidebar && role.isStaff
            ? SafeArea(
                top: false,
                child: Row(
                  children: [
                    for (final item in destinations)
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: active == item.$1
                                ? MakroColors.softBlue
                                : Colors.white,
                          ),
                          onPressed: () => _navigate(context, item.$1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MakroIcon(item.$3),
                                const SizedBox(height: 4),
                                Text(item.$2),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : null,
      );
    },
  );

  Widget _nav(
    BuildContext context,
    String label,
    String icon, {
    bool selected = false,
    bool compact = false,
    VoidCallback? action,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Tooltip(
      message: action == null
          ? '$label · Disponible en una próxima entrega'
          : label,
      child: Material(
        color: selected ? MakroColors.softBlue : Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: action,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: compact
                ? Column(
                    children: [
                      MakroIcon(
                        icon,
                        color: action == null
                            ? MakroColors.muted
                            : MakroColors.blue,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        label == 'Administración' ? 'Admin.' : label,
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      MakroIcon(
                        icon,
                        size: 20,
                        color: action == null
                            ? MakroColors.muted
                            : MakroColors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: action == null
                                ? MakroColors.muted
                                : selected
                                ? MakroColors.blue
                                : MakroColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ),
  );

  void _showPermissions(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(role.label),
      content: SingleChildScrollView(
        child: Text(
          role.isStaff
              ? 'Puedes consultar objetos y registrar hallazgos.\n\n'
                    '${role.canReviewClaims ? 'Revisión de reclamos: permitida.\n' : 'Revisión de reclamos: no permitida.\n'}'
                    '${role.canViewReports ? 'Reportes: permitido.\n' : 'Reportes: no permitido.\n'}'
                    '${role.canManageUsers ? 'Administrar usuarios: permitido.\n' : 'Administrar usuarios: no permitido.\n'}'
                    '\nReclamos, reportes y administración se habilitarán en una próxima entrega. Acceso de demostración.'
              : 'Puedes buscar objetos disponibles sin una cuenta. No puedes ver información interna ni registrar o modificar objetos.',
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
}
