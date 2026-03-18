enum NotificationMethod { email, sms }

extension NotificationMethodX on NotificationMethod {
  String get label => this == NotificationMethod.email ? 'Email' : 'SMS';
}
