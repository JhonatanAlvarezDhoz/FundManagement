import 'package:fund_management/core/errors/failures.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/history/domain/entities/transaction_entity.dart';
import 'package:fund_management/features/history/domain/repositories/transaction_repository.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fund_management/shared/enums/transaction_type.dart';
import 'package:uuid/uuid.dart';

class CancelFundSubscriptionUseCase {
  final PortfolioRepository portfolioRepository;
  final TransactionRepository transactionRepository;
  final Uuid _uuid;

  CancelFundSubscriptionUseCase({
    required this.portfolioRepository,
    required this.transactionRepository,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  Future<Result<void>> call(String positionId) async {
    final positionsResult = await portfolioRepository.getPositions();
    if (positionsResult is FailureResult<List<PortfolioPosition>>) {
      return FailureResult<void>(positionsResult.failure);
    }
    final positions =
        (positionsResult as Success<List<PortfolioPosition>>).data;
    final index = positions.indexWhere((e) => e.id == positionId);
    if (index == -1) {
      return const FailureResult<void>(
        NotFoundFailure('No se encontró la posición a cancelar.'),
      );
    }

    final target = positions[index];
    final updatedPositions = [...positions]..removeAt(index);

    final walletResult = await portfolioRepository.getWallet();
    if (walletResult is FailureResult<UserWallet>) {
      return FailureResult<void>(walletResult.failure);
    }
    final wallet = (walletResult as Success<UserWallet>).data;

    final investedBalance = updatedPositions.fold<double>(
      0,
      (sum, item) => sum + item.subscribedAmount,
    );
    final portfolioCurrentValue = updatedPositions.fold<double>(
      0,
      (sum, item) => sum + item.currentValue,
    );

    final updatedWallet = wallet.copyWith(
      availableBalance: wallet.availableBalance + target.currentValue,
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
        type: TransactionType.cancellation,
        fundId: target.fundId,
        fundName: target.fundName,
        category: target.category,
        amount: target.currentValue,
        createdAt: DateTime.now(),
        notificationMethod: target.notificationMethod,
        resultingBalance: updatedWallet.availableBalance,
      ),
    );
    if (addTransaction is FailureResult<void>) return addTransaction;

    return const Success(null);
  }
}
