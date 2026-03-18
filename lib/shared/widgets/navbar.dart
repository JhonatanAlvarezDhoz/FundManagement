import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Fund Manager',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Row(
            children: [
              _NavItem(title: 'Home', onTap: () {}),
              _NavItem(title: 'Funds', onTap: () {}),
              _NavItem(title: 'Investments', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: TextStyle(
            color: location == '/' ? Colors.green : Colors.white,
          ),
        ),
      ),
    );
  }
}
