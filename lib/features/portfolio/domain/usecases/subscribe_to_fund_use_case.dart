import 'package:fund_management/core/errors/failures.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/core/sync/app_operation_lock.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';
import 'package:fund_management/features/history/domain/entities/transaction_entity.dart';
import 'package:fund_management/features/history/domain/repositories/transaction_repository.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fund_management/shared/enums/notification_method.dart';
import 'package:fund_management/shared/enums/transaction_type.dart';
import 'package:uuid/uuid.dart';

class SubscribeToFundParams {
  final int fundId;
  final double amount;
  final NotificationMethod notificationMethod;

  const SubscribeToFundParams({
    required this.fundId,
    required this.amount,
    required this.notificationMethod,
  });
}

class SubscribeToFundUseCase {
  final FundRepository fundRepository;
  final PortfolioRepository portfolioRepository;
  final TransactionRepository transactionRepository;
  final AppOperationLock operationLock;
  final Uuid _uuid;

  SubscribeToFundUseCase({
    required this.fundRepository,
    required this.portfolioRepository,
    required this.transactionRepository,
    required this.operationLock,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  Future<Result<void>> call(SubscribeToFundParams params) {
    return operationLock.synchronized(() async {
      if (params.amount <= 0) {
        return const FailureResult<void>(
          ValidationFailure('El monto debe ser mayor que cero.'),
        );
      }

      final fundResult = await fundRepository.getFundById(params.fundId);
      if (fundResult is FailureResult<Fund>) {
        return FailureResult<void>(fundResult.failure);
      }
      final fund = (fundResult as Success<Fund>).data;

      if (params.amount < fund.minimumAmount) {
        return FailureResult<void>(
          ValidationFailure(
            'El monto mínimo para ${fund.name} es ${fund.minimumAmount.toInt()}.',
          ),
        );
      }

      final walletResult = await portfolioRepository.getWallet();
      if (walletResult is FailureResult<UserWallet>) {
        return FailureResult<void>(walletResult.failure);
      }
      final wallet = (walletResult as Success<UserWallet>).data;

      if (wallet.availableBalance < params.amount) {
        return const FailureResult<void>(
          InsufficientBalanceFailure(
            'No tienes saldo suficiente para realizar esta suscripción.',
          ),
        );
      }

      final positionsResult = await portfolioRepository.getPositions();
      if (positionsResult is FailureResult<List<PortfolioPosition>>) {
        return FailureResult<void>(positionsResult.failure);
      }
      final positions =
          (positionsResult as Success<List<PortfolioPosition>>).data;

      final position = PortfolioPosition(
        id: _uuid.v4(),
        fundId: fund.id,
        fundName: fund.name,
        category: fund.category,
        subscribedAmount: params.amount,
        currentValue: params.amount,
        annualRate: fund.annualRate,
        subscribedAt: DateTime.now(),
        simulatedDays: 0,
        notificationMethod: params.notificationMethod,
        isActive: true,
      );

      final updatedPositions = [...positions, position];
      final investedBalance = updatedPositions.fold<double>(
        0,
        (sum, item) => sum + item.subscribedAmount,
      );
      final portfolioCurrentValue = updatedPositions.fold<double>(
        0,
        (sum, item) => sum + item.currentValue,
      );

      final updatedWallet = wallet.copyWith(
        availableBalance: wallet.availableBalance - params.amount,
        investedBalance: investedBalance,
        portfolioCurrentValue: portfolioCurrentValue,
      );

      final savePositions = await portfolioRepository.savePositions(
        updatedPositions,
      );
      if (savePositions is FailureResult<void>) return savePositions;

      final saveWallet = await portfolioRepository.saveWallet(updatedWallet);
      if (saveWallet is FailureResult<void>) return saveWallet;

      final addTransaction = await transactionRepository.addTransaction(
        TransactionEntity(
          id: _uuid.v4(),
          type: TransactionType.subscription,
          fundId: fund.id,
          fundName: fund.name,
          category: fund.category,
          amount: params.amount,
          createdAt: DateTime.now(),
          notificationMethod: params.notificationMethod,
          resultingBalance: updatedWallet.availableBalance,
        ),
      );
      if (addTransaction is FailureResult<void>) return addTransaction;

      return const Success(null);
    });
  }
}
