import 'package:flutter/material.dart';
import 'package:fund_management/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final String title;
  final List<Widget>? actions;

  const AppShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      // ('Dashboard', RouteNames.dashboard),
      ('Fondos', RouteNames.funds),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;
        return Scaffold(
          appBar: AppBar(title: Text(title), actions: actions),
          drawer: isDesktop
              ? null
              : Drawer(
                  child: ListView(
                    children: [
                      const DrawerHeader(child: Text('BTG Fondos')),
                      for (var i = 0; i < items.length; i++)
                        ListTile(
                          selected: i == selectedIndex,
                          title: Text(items[i].$1),
                          onTap: () {
                            Navigator.of(context).pop();
                            context.go(items[i].$2);
                          },
                        ),
                    ],
                  ),
                ),
          body: Row(
            children: [
              if (isDesktop)
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => context.go(items[index].$2),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.account_balance_wallet_outlined),
                      selectedIcon: Icon(Icons.account_balance_wallet),
                      label: Text('Fondos'),
                    ),
                  ],
                ),
              Expanded(
                child: Padding(padding: const EdgeInsets.all(20), child: child),
              ),
            ],
          ),
        );
      },
    );
  }
}
