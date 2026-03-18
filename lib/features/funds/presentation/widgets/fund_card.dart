import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fund_management/features/funds/domain/entity/fund_entity.dart';
import 'package:fund_management/shared/extentions/double_extentions.dart';
import 'package:fund_management/shared/widgets/custom_text.dart';
import 'package:fund_management/shared/extentions/string_extentions.dart';

class FundCard extends StatelessWidget {
  final FundEntity fund;
  const FundCard({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 70.h,
            child: CustomText(
              text: fund.name.formatReadable(),
              fontSize: 10.sp,
            ),
          ),
          Spacer(),
          CustomText(text: fund.minAmount.toCurrency(), fontSize: 10.sp),
          CustomText(text: fund.type, fontSize: 10.sp),
          CustomText(text: fund.annualRate.toPercentage(), fontSize: 10.sp),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomText(text: 'Invertir', fontSize: 5.sp),
            ),
          ),
        ],
      ),
    );
  }
}
