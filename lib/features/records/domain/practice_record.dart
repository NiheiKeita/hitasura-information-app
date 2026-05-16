import '../../practice/domain/enums.dart';

class PracticeRecord {
  const PracticeRecord({
    required this.id,
    required this.category,
    required this.mode,
    required this.clearTimeMillis,
    required this.playedAt,
  });

  final String id;
  final Category category;
  final PracticeMode mode;
  final int clearTimeMillis;
  final DateTime playedAt;

  double get clearTimeSec => clearTimeMillis / 1000;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'mode': mode.name,
      'clearTimeMillis': clearTimeMillis,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  static PracticeRecord? tryFromJson(Map<String, dynamic> json) {
    try {
      final modeName = json['mode'];
      if (modeName is! String) return null;
      final mode = PracticeMode.values.firstWhere(
        (m) => m.name == modeName,
        orElse: () => PracticeMode.timeAttack10,
      );
      final categoryName = json['category'];
      Category? category;
      if (categoryName is String) {
        for (final c in Category.values) {
          if (c.name == categoryName) {
            category = c;
            break;
          }
        }
      }
      if (category == null) return null;
      final clearTimeMillis = _readInt(json['clearTimeMillis']);
      if (clearTimeMillis == null || clearTimeMillis <= 0) return null;
      final playedAtStr = json['playedAt'];
      if (playedAtStr is! String) return null;
      final playedAt = DateTime.tryParse(playedAtStr);
      if (playedAt == null) return null;
      final id = json['id'] is String && (json['id'] as String).isNotEmpty
          ? json['id'] as String
          : '${playedAt.microsecondsSinceEpoch}';
      return PracticeRecord(
        id: id,
        category: category,
        mode: mode,
        clearTimeMillis: clearTimeMillis,
        playedAt: playedAt,
      );
    } catch (_) {
      return null;
    }
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
