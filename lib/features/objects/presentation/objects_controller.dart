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

  String get query => _query;
  ObjectCategory? get category => _category;
  ObjectStatus? get status => _status;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasFilters =>
      _query.isNotEmpty || _category != null || _status != null;

  List<LostObject> get visibleObjects => List.unmodifiable(
    _objects.where(
      (object) => object.matches(
        query: _query,
        category: _category,
        status: _status,
      ),
    ),
  );

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
}
