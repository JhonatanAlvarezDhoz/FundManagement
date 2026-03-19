import 'package:flutter_test/flutter_test.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/core/sync/app_operation_lock.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';
import 'package:fund_management/features/history/domain/entities/transaction_entity.dart';
import 'package:fund_management/features/history/domain/repositories/transaction_repository.dart';
import 'package:fund_management/features/portfolio/domain/entities/portfolio_position.dart';
import 'package:fund_management/features/portfolio/domain/entities/user_wallet.dart';
import 'package:fund_management/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:fund_management/features/portfolio/domain/usecases/subscribe_to_fund_use_case.dart';
import 'package:fund_management/shared/enums/fund_category.dart';
import 'package:fund_management/shared/enums/notification_method.dart';
import 'package:fund_management/shared/enums/risk_profile.dart';
import 'package:fund_management/shared/enums/transaction_type.dart';
import 'package:mocktail/mocktail.dart';

class MockFundRepository extends Mock implements FundRepository {}

class MockPortfolioRepository extends Mock implements PortfolioRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserWallet.initial());
    registerFallbackValue(<PortfolioPosition>[]);
    registerFallbackValue(
      TransactionEntity(
        id: '',
        type: TransactionType.subscription, // o cualquiera válido
        fundId: 0,
        fundName: '',
        category: FundCategory.fpv,
        amount: 0,
        createdAt: DateTime.now(),
        notificationMethod: null,
        resultingBalance: 0,
      ),
    );
  });
  late SubscribeToFundUseCase useCase;
  late MockFundRepository fundRepository;
  late MockPortfolioRepository portfolioRepository;
  late MockTransactionRepository transactionRepository;

  setUp(() {
    fundRepository = MockFundRepository();
    portfolioRepository = MockPortfolioRepository();
    transactionRepository = MockTransactionRepository();

    useCase = SubscribeToFundUseCase(
      fundRepository: fundRepository,
      portfolioRepository: portfolioRepository,
      transactionRepository: transactionRepository,
      operationLock: AppOperationLock(),
    );
  });

  test('should subscribe successfully', () async {
    // Arrange
    const fund = Fund(
      id: 1,
      name: 'FPV_TEST',
      category: FundCategory.fpv,
      minimumAmount: 50000,
      annualRate: 0.08,
      riskProfile: RiskProfile.low,
    );

    final wallet = UserWallet.initial();

    when(
      () => fundRepository.getFundById(1),
    ).thenAnswer((_) async => const Success(fund));

    when(
      () => portfolioRepository.getWallet(),
    ).thenAnswer((_) async => Success(wallet));

    when(
      () => portfolioRepository.getPositions(),
    ).thenAnswer((_) async => const Success([]));

    when(
      () => portfolioRepository.savePositions(any()),
    ).thenAnswer((_) async => const Success(null));

    when(
      () => portfolioRepository.saveWallet(any()),
    ).thenAnswer((_) async => const Success(null));

    when(
      () => transactionRepository.addTransaction(any()),
    ).thenAnswer((_) async => const Success(null));

    // Act
    final result = await useCase.call(
      const SubscribeToFundParams(
        fundId: 1,
        amount: 80000,
        notificationMethod: NotificationMethod.email,
      ),
    );

    // Assert
    expect(result, isA<Success<void>>());

    verify(() => portfolioRepository.savePositions(any())).called(1);
    verify(() => portfolioRepository.saveWallet(any())).called(1);
    verify(() => transactionRepository.addTransaction(any())).called(1);
  });
}
