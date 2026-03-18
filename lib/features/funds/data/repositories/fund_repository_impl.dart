import 'package:fund_management/core/errors/failures.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/funds/data/datasources/funds_remote_data_source.dart';
import 'package:fund_management/features/funds/domain/entities/fund.dart';
import 'package:fund_management/features/funds/domain/repositories/fund_repository.dart';

class FundRepositoryImpl implements FundRepository {
  final FundsRemoteDataSource dataSource;

  FundRepositoryImpl(this.dataSource);

  @override
  Future<Result<List<Fund>>> getFunds() async {
    try {
      final data = await dataSource.getFunds();
      return Success(data);
    } catch (_) {
      return const FailureResult<List<Fund>>(
        NetworkFailure('No fue posible cargar los fondos disponibles.'),
      );
    }
  }

  @override
  Future<Result<Fund>> getFundById(int id) async {
    final result = await getFunds();
    if (result is FailureResult<List<Fund>>) {
      return FailureResult<Fund>(result.failure);
    }
    final funds = (result as Success<List<Fund>>).data;
    final match = funds.where((element) => element.id == id);
    if (match.isEmpty) {
      return const FailureResult<Fund>(
        NotFoundFailure('No se encontró el fondo solicitado.'),
      );
    }
    return Success(match.first);
  }
}
