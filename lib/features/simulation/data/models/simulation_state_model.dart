import 'package:fund_management/features/simulation/domain/entities/simulation_state_entity.dart';

class SimulationStateModel extends SimulationStateEntity {
  const SimulationStateModel({
    required super.totalSimulatedDays,
    required super.lastTickAt,
  });

  factory SimulationStateModel.fromJson(Map<String, dynamic> json) =>
      SimulationStateModel(
        totalSimulatedDays: json['totalSimulatedDays'] as int,
        lastTickAt: DateTime.parse(json['lastTickAt'] as String),
      );

  Map<String, dynamic> toJson() => {
    'totalSimulatedDays': totalSimulatedDays,
    'lastTickAt': lastTickAt.toIso8601String(),
  };

  factory SimulationStateModel.fromEntity(SimulationStateEntity entity) =>
      SimulationStateModel(
        totalSimulatedDays: entity.totalSimulatedDays,
        lastTickAt: entity.lastTickAt,
      );
}
