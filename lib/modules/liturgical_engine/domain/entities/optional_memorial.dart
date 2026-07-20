import '../enums/liturgical_color.dart';
import '../value_objects/celebration_key.dart';

class OptionalMemorial {
  final CelebrationKey key;
  final LiturgicalColor color;

  const OptionalMemorial({required this.key, required this.color});
}