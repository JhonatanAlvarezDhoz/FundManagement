import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fund_management/core/constants/app_constants.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/simulation/domain/usecases/advance_simulation_day_use_case.dart';

/// Cubit que maneja el avance del tiempo simulado en la app.
/// Esto con la finalidad de ver en cambio de la rentabilidad
/// en el tiempo como si fuese un caso real
class SimulationCubit extends Cubit<int> {
  final AdvanceSimulationDayUseCase advanceSimulationDayUseCase;
  Timer? _timer;

  SimulationCubit({required this.advanceSimulationDayUseCase}) : super(0);

  /// Inicia la simulación.
  ///
  /// - Cancela cualquier timer previo (evita duplicados)
  /// - Ejecuta una tarea periódica según la duración configurada
  void start() {
    /// Evita múltiples timers activos (memory leak / duplicación lógica)
    _timer?.cancel();
    _timer = Timer.periodic(AppConstants.simulatedDayDuration, (_) async {
      final result = await advanceSimulationDayUseCase.call();

      /// Solo avanza el estado si la operación fue exitosa
      if (result is Success<void>) {
        emit(state + 1);
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
