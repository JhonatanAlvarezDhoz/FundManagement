enum RiskProfile { low, medium, high }

extension RiskProfileX on RiskProfile {
  String get label {
    switch (this) {
      case RiskProfile.low:
        return 'Bajo';
      case RiskProfile.medium:
        return 'Medio';
      case RiskProfile.high:
        return 'Alto';
    }
  }
}
