import 'package:equatable/equatable.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class HistoryRequested extends HistoryEvent {
  const HistoryRequested();
}
