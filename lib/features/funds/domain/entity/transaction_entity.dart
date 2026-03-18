enum TransactionType { subscribe, cancel }

enum NotificationType { email, sms }

class TransactionEntity {
  final String id;
  final String fundId;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final NotificationType notification;

  TransactionEntity({
    required this.id,
    required this.fundId,
    required this.amount,
    required this.type,
    required this.date,
    required this.notification,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fundId': fundId,
    'amount': amount,
    'type': type.name,
    'date': date.toIso8601String(),
    'notification': notification.name,
  };

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    return TransactionEntity(
      id: json['id'],
      fundId: json['fundId'],
      amount: json['amount'],
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      date: DateTime.parse(json['date']),
      notification: NotificationType.values.firstWhere(
        (e) => e.name == json['notification'],
      ),
    );
  }
}
