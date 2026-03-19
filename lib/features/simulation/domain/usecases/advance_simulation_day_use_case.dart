import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/core/sync/app_operation_lock.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fund_management/features/simulation/domain/entities/simulation_state_entity.dart';
import 'package:fund_management/features/simulation/domain/repositories/simulation_repository.dart';
import 'package:fund_management/features/simulation/domain/strategy/fic_debt_strategy.dart';
import 'package:fund_management/features/simulation/domain/strategy/fic_equity_strategy.dart';
import 'package:fund_management/features/simulation/domain/strategy/fpv_strategy.dart';
import 'package:fund_management/features/simulation/domain/strategy/fund_profitability_strategy.dart';
import 'package:fund_management/shared/enums/fund_category.dart';

/// Caso de uso encargado de avanzar un "día simulado".
///
/// Responsabilidades:
/// - Obtener estado actual (portfolio, fondos, simulación, wallet)
/// - Calcular nueva valorización de cada posición
/// - Persistir cambios de forma consistente
/// - Mantener integridad transaccional (usando lock)
class AdvanceSimulationDayUseCase {
  final PortfolioRepository portfolioRepository;
  final SimulationRepository simulationRepository;
  final FundRepository fundRepository;
  final AppOperationLock operationLock;

  AdvanceSimulationDayUseCase({
    required this.portfolioRepository,
    required this.simulationRepository,
    required this.fundRepository,
    required this.operationLock,
  });

  Future<Result<void>> call() {
    return operationLock.synchronized(() async {
      final positionsResult = await portfolioRepository.getPositions();
      final simulationResult = await simulationRepository.getSimulationState();
      final fundsResult = await fundRepository.getFunds();
      final walletResult = await portfolioRepository.getWallet();

      if (positionsResult is FailureResult<List<PortfolioPosition>>) {
        return FailureResult<void>(positionsResult.failure);
      }
      if (simulationResult is FailureResult<SimulationStateEntity>) {
        return FailureResult<void>(simulationResult.failure);
      }
      if (fundsResult is FailureResult<List<Fund>>) {
        return FailureResult<void>(fundsResult.failure);
      }
      if (walletResult is FailureResult<UserWallet>) {
        return FailureResult<void>(walletResult.failure);
      }

      final positions =
          (positionsResult as Success<List<PortfolioPosition>>).data;
      final simulation =
          (simulationResult as Success<SimulationStateEntity>).data;
      final funds = (fundsResult as Success<List<Fund>>).data;
      final wallet = (walletResult as Success<UserWallet>).data;
      final map = {for (final fund in funds) fund.id: fund};

      final updated = positions.map((position) {
        final fund = map[position.fundId];
        if (fund == null) return position;
        final strategy = _strategyFor(fund);
        final nextValue = strategy.calculateNextValue(
          currentValue: position.currentValue,
          annualRate: position.annualRate,
          simulatedDay: position.simulatedDays + 1,
          fundId: position.fundId,
        );
        return position.copyWith(
          simulatedDays: position.simulatedDays + 1,
          currentValue: nextValue < 0 ? 0 : nextValue,
        );
      }).toList();

      final investedBalance = updated.fold<double>(
        0,
        (sum, item) => sum + item.subscribedAmount,
      );
      final currentPortfolioValue = updated.fold<double>(
        0,
        (sum, item) => sum + item.currentValue,
      );

      final savePositions = await portfolioRepository.savePositions(updated);
      if (savePositions is FailureResult<void>) return savePositions;

      final saveWallet = await portfolioRepository.saveWallet(
        wallet.copyWith(
          investedBalance: investedBalance,
          portfolioCurrentValue: currentPortfolioValue,
        ),
      );
      if (saveWallet is FailureResult<void>) return saveWallet;

      final saveSimulation = await simulationRepository.saveSimulationState(
        simulation.copyWith(
          totalSimulatedDays: simulation.totalSimulatedDays + 1,
          lastTickAt: DateTime.now(),
        ),
      );
      if (saveSimulation is FailureResult<void>) return saveSimulation;

      return const Success(null);
    });
  }

  FundProfitabilityStrategy _strategyFor(Fund fund) {
    if (fund.category == FundCategory.fpv) return FpvStrategy();
    if (fund.name.toLowerCase().contains('acciones'))
      return FicEquityStrategy();
    return FicDebtStrategy();
  }
}
