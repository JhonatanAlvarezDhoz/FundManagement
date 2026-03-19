part of 'portfolio_bloc.dart';

sealed class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class PortfolioLoaded extends PortfolioState {
  final UserWallet wallet;
  final List<PortfolioPosition> positions;
  final String? flashMessage;
  final bool isSubmitting;

  const PortfolioLoaded({
    required this.wallet,
    required this.positions,
    this.flashMessage,
    this.isSubmitting = false,
  });

  PortfolioLoaded copyWith({
    UserWallet? wallet,
    List<PortfolioPosition>? positions,
    String? flashMessage,
    bool? isSubmitting,
  }) {
    return PortfolioLoaded(
      wallet: wallet ?? this.wallet,
      positions: positions ?? this.positions,
      flashMessage: flashMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [wallet, positions, flashMessage, isSubmitting];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
