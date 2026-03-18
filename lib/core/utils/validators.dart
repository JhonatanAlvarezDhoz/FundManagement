class Validators {
  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa un monto.';
    }
    final normalized = value.replaceAll('.', '').replaceAll(',', '.').trim();
    final parsed = double.tryParse(normalized);
    if (parsed == null) {
      return 'Ingresa un monto válido.';
    }
    if (parsed <= 0) {
      return 'El monto debe ser mayor que cero.';
    }
    return null;
  }

  static double? parseAmount(String value) {
    return double.tryParse(
      value.replaceAll('.', '').replaceAll(',', '.').trim(),
    );
  }
}
