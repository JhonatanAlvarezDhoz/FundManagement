import 'package:equatable/equatable.dart';

class SimulationStateEntity extends Equatable {
  final int totalSimulatedDays;
  final DateTime lastTickAt;

  const SimulationStateEntity({
    required this.totalSimulatedDays,
    required this.lastTickAt,
  });

  factory SimulationStateEntity.initial() => SimulationStateEntity(
        totalSimulatedDays: 0,
        lastTickAt: DateTime.now(),
      );

  SimulationStateEntity copyWith({
    int? totalSimulatedDays,
    DateTime? lastTickAt,
  }) {
    return SimulationStateEntity(
      totalSimulatedDays: totalSimulatedDays ?? this.totalSimulatedDays,
      lastTickAt: lastTickAt ?? this.lastTickAt,
    );
  }

  @override
  List<Object?> get props => [totalSimulatedDays, lastTickAt];
}
