import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Text(
        '© 2026 Fund Manager',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
