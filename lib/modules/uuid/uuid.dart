library uuid;

import 'package:uuid/uuid.dart';

/// A class of static methods to generate UUIDs
class UUID {
  /// Generates a RNG v4 UUID
  static String generate() => Uuid().v4().toString();
}
