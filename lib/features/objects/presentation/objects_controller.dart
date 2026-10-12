import 'package:flutter/foundation.dart';

import '../data/objects_repository.dart';
import '../models/lost_object.dart';

class ObjectsController extends ChangeNotifier {
  ObjectsController(this._repository);

  final ObjectsRepository _repository;
  List<LostObject> _objects = const [];
  String _query = '';
  ObjectCategory? _category;
  ObjectStatus? _status;
  bool _isLoading = false;
  bool _hasError = false;
  bool _disposed = false;
  bool _publicMode = false;
  String _location = '';
  DateTime? _from;
  DateTime? _until;
  String get location => _location;
  DateTime? get from => _from;
  DateTime? get until => _until;

  String get query => _query;
  ObjectCategory? get category => _category;
  ObjectStatus? get status => _status;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasFilters =>
      _query.isNotEmpty ||
      _category != null ||
      _status != null ||
      _location.isNotEmpty ||
      _from != null ||
      _until != null;

  List<LostObject> get allObjects => List.unmodifiable(_objects);
  List<String> get locations =>
      (_objects.map((o) => o.location).toSet().toList()..sort());
  Iterable<LostObject> get _pool => _publicMode
      ? _objects
            .where(
              (o) =>
                  o.status == ObjectStatus.inCustody &&
                  o.category != ObjectCategory.documents,
            )
            .indexed
            .map((item) => item.$2.publicView(item.$1))
      : _objects;

  List<LostObject> get visibleObjects => List.unmodifiable(
    _pool.where(
      (object) => object.matches(
        query: _query,
        category: _category,
        status: _status,
        location: _location,
        from: _from,
        until: _until,
      ),
    ),
  );

  void setPublicMode(bool value) {
    _publicMode = value;
    clearFilters();
  }

  void addObject(LostObject object) {
    if (_publicMode) throw StateError('El catálogo público es de consulta.');
    _objects = List.unmodifiable([object, ..._objects]);
    notifyListeners();
  }

  void applyFilters({
    required String query,
    ObjectCategory? category,
    ObjectStatus? status,
    String location = '',
    DateTime? from,
    DateTime? until,
  }) {
    _query = query;
    _category = category;
    _status = _publicMode ? null : status;
    _location = _publicMode ? '' : location;
    _from = from;
    _until = until;
    notifyListeners();
  }

  Future<void> load() async {
    if (_isLoading || _disposed) return;
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    try {
      final result = await _repository.loadObjects();
      if (_disposed) return;
      _objects = List.unmodifiable(result);
    } catch (_) {
      if (_disposed) return;
      _hasError = true;
    } finally {
      if (!_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void setCategory(ObjectCategory? value) {
    _category = value;
    notifyListeners();
  }

  void setStatus(ObjectStatus? value) {
    _status = value;
    notifyListeners();
  }

  void clearFilters() {
    _location = '';
    _from = null;
    _until = null;
    _query = '';
    _category = null;
    _status = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void setDateRange(DateTime? from, DateTime? until) {
    _from = from;
    _until = until;
    notifyListeners();
  }
}
