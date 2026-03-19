part of 'portfolio_bloc.dart';

sealed class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

class PortfolioRequested extends PortfolioEvent {
  const PortfolioRequested();
}

class SubscribeRequested extends PortfolioEvent {
  final int fundId;
  final double amount;
  final NotificationMethod notificationMethod;

  const SubscribeRequested({
    required this.fundId,
    required this.amount,
    required this.notificationMethod,
  });

  @override
  List<Object?> get props => [fundId, amount, notificationMethod];
}

class CancelPositionRequested extends PortfolioEvent {
  final String positionId;

  const CancelPositionRequested(this.positionId);

  @override
  List<Object?> get props => [positionId];
}

class ResetDemoRequested extends PortfolioEvent {
  const ResetDemoRequested();
}
