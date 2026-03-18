import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fund_management/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:fund_management/features/funds/presentation/widgets/fund_card.dart';
import 'package:fund_management/shared/constant/responsive.dart';

class FundsPage extends StatelessWidget {
  const FundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    late int crossAxisCount;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (Responsive.isDesktop(width)) {
          crossAxisCount = 3; // desktop grande
        } else if (Responsive.isTablet(width)) {
          crossAxisCount = 2; // 👈 tu caso clave
        } else if (Responsive.isMobile(width)) {
          crossAxisCount = 1; // mobile
        }
        return BlocBuilder<FundBloc, FundState>(
          builder: (context, state) {
            if (state.status == FundStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            log(constraints.toString());

            return Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: GridView.builder(
                itemCount: state.funds.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                ),
                itemBuilder: (_, i) {
                  final fund = state.funds[i];
                  return FundCard(fund: fund);
                },
              ),
            );
          },
        );
      },
    );
  }
}
