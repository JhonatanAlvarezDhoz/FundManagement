# BTG Funds App

Aplicación Flutter Web para la prueba técnica de manejo de fondos FPV/FIC.

## Stack

- Flutter Web
- flutter_bloc
- get_it
- go_router
- shared_preferences
- Clean Architecture ligera

## Funcionalidades

- Visualización de fondos disponibles
- Suscripción validando saldo y monto mínimo
- Cancelación de posiciones activas
- Historial de transacciones
- Selección de notificación por email o SMS
- Persistencia local con SharedPreferences
- Simulación de rentabilidad donde 1 segundo equivale a 1 día

## Estructura

- `core`: utilidades, theme, errores, result
- `di`: configuración de dependencias
- `router`: rutas con GoRouter
- `shared`: enums y widgets reutilizables
- `features`: módulos funds, portfolio, history, simulation, dashboard

## Ejecución

```bash
flutter pub get
flutter run -d chrome
```

## Notas

- El almacenamiento es local y persiste en el navegador.
- El botón `Reset demo` limpia el estado y vuelve al saldo inicial.
- Las tasas de rentabilidad son simuladas con estrategias determinísticas para que el comportamiento sea reproducible.
- El proyecto fue preparado completo para ejecución local, pero no fue compilado en este entorno porque Flutter no está instalado en el contenedor.

## Posibles mejoras

- Gráficos históricos reales
- Cancelación parcial
- Notificaciones reales
- Backend real
- Tema oscuro
