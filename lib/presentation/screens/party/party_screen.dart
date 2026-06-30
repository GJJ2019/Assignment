import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(24.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Icon(
                Icons.explore_rounded,
                color: AppColors.primary,
                size: 64.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Party Mode',
              style: AppTextStyles.headingMedium(),
            ),
            SizedBox(height: 12.h),
            Text(
              'Join group live streams, voice rooms, and interactive gaming sessions with people worldwide.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
