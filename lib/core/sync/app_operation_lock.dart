class AppOperationLock {
  /// Representa la última operación en cola.
  /// Inicialmente es un Future ya completado para permitir la primera ejecución inmediata.
  Future<void> _pending = Future.value();

  /// Ejecuta una acción de forma sincronizada (secuencial).
  ///
  /// Garantiza que:
  /// - No se ejecuten múltiples acciones en paralelo.
  /// - Cada acción espere a que termine la anterior.
  Future<T> synchronized<T>(Future<T> Function() action) {
    /// Encadena la nueva acción a la operación previa.
    /// Esto asegura que `action` solo se ejecute cuando `_pending` haya finalizado.
    final completer = _pending.then((_) => action());

    /// Actualiza `_pending` para que apunte a esta nueva operación.
    ///
    /// Se usa `then<void>` para:
    /// - Ignorar el resultado de `action`
    /// - Convertirlo a `Future<void>`
    ///
    /// `onError` evita que un error rompa la cadena,
    /// permitiendo que futuras operaciones sigan ejecutándose.
    _pending = completer.then<void>((_) {}, onError: (_) {});

    /// Retorna el Future original con el resultado real de `action`.
    return completer;
  }
}
