/// Base para todos los casos de uso
abstract class UseCase<T, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
