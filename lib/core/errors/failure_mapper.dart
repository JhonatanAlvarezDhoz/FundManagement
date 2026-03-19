import 'failures.dart';

/// Mapea errores de dominio a mensajes de UI.
class FailureMapper {
  static String map(Failure failure) => failure.message;
}
