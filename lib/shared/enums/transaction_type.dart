enum TransactionType { subscription, cancellation }

extension TransactionTypeX on TransactionType {
  String get label =>
      this == TransactionType.subscription ? 'Suscripción' : 'Cancelación';
}
