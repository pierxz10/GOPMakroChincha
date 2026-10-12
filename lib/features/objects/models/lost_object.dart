// Campos, categorías y estados provisionales: confirmar con el equipo y la API.
enum ObjectCategory {
  documents('Documentos'),
  electronics('Electrónicos'),
  accessories('Accesorios'),
  other('Otros');

  const ObjectCategory(this.label);
  final String label;
}

enum ObjectStatus {
  inCustody('En custodia'),
  returned('Devuelto');

  const ObjectStatus(this.label);
  final String label;
}

class LostObject {
  const LostObject({
    required this.reference,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.status,
    this.foundAt,
  });

  final String reference;
  final String name;
  final String description;
  final String location;
  final ObjectCategory category;
  final ObjectStatus status;
  final DateTime? foundAt;

  bool matches({
    required String query,
    ObjectCategory? category,
    ObjectStatus? status,
    String location = '',
    DateTime? from,
    DateTime? until,
  }) {
    if (category != null && this.category != category) return false;
    if (status != null && this.status != status) return false;
    if (!_normalize(location)
        .trim()
        .split(RegExp(r'\s+'))
        .every((word) => _normalize(this.location).contains(word))) {
      return false;
    }
    if (from != null && (foundAt == null || foundAt!.isBefore(from))) {
      return false;
    }
    if (until != null &&
        (foundAt == null ||
            !foundAt!.isBefore(
              DateTime(until.year, until.month, until.day + 1),
            ))) {
      return false;
    }
    final normalizedQuery = _normalize(query).trim();
    if (normalizedQuery.isEmpty) return true;
    final searchable = _normalize(
      '$reference $name $description ${this.location} ${this.category.label} '
      '${this.status.label}',
    );
    return normalizedQuery
        .split(RegExp(r'\s+'))
        .every((word) => searchable.contains(word));
  }
}

String _normalize(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp('[áàäâ]'), 'a')
      .replaceAll(RegExp('[éèëê]'), 'e')
      .replaceAll(RegExp('[íìïî]'), 'i')
      .replaceAll(RegExp('[óòöô]'), 'o')
      .replaceAll(RegExp('[úùüû]'), 'u')
      .replaceAll('ñ', 'n');
}
