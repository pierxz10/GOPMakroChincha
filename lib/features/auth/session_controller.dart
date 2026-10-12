import 'package:flutter/foundation.dart';
import '../objects/models/lost_object.dart';
import '../objects/presentation/objects_controller.dart';

enum UserRole {
  administrator('Administrador', 'ADM'),
  supervisor('Supervisor', 'SUP'),
  responsible('Responsable', 'RES'),
  visitor('Visitante', 'VIS');

  const UserRole(this.label, this.initials);
  final String label;
  final String initials;
  bool get isStaff => this != visitor;
  bool get canRegister => isStaff;
  bool get canReviewClaims => this == administrator || this == supervisor;
  bool get canViewReports => this == administrator || this == supervisor;
  bool get canManageUsers => this == administrator;
}

class SessionController extends ChangeNotifier {
  SessionController({UserRole? initialRole}) : _role = initialRole;
  // Acceso local de demostración; no es autenticación de producción.
  static const demoPassword = 'MakroDemo2026';
  static const demoAccounts = {
    'admin.demo': UserRole.administrator,
    'supervisor.demo': UserRole.supervisor,
    'responsable.demo': UserRole.responsible,
  };
  UserRole? _role;
  UserRole? get role => _role;
  bool signIn(String username, String password) {
    final account = demoAccounts[username.trim().toLowerCase()];
    if (account == null || password != demoPassword) return false;
    _role = account;
    notifyListeners();
    return true;
  }

  void enterAsVisitor() {
    _role = UserRole.visitor;
    notifyListeners();
  }

  void signOut() {
    _role = null;
    notifyListeners();
  }

  bool canOpen(String route) => switch (route) {
    '/' => true,
    '/inicio' => _role?.isStaff ?? false,
    '/objetos' || '/filtros' => _role != null,
    _ => false,
  };
  bool registerObject(ObjectsController objects, LostObject object) {
    if (!(_role?.canRegister ?? false)) return false;
    objects.addObject(object);
    return true;
  }
}
