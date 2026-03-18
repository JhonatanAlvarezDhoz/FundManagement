abstract class Failure {
  final String message;
  Failure(this.message);
}

class InsufficientBalanceFailure extends Failure {
  InsufficientBalanceFailure() : super("Saldo insuficiente");
}

class GeneralFailure extends Failure {
  GeneralFailure(super.message);
}
