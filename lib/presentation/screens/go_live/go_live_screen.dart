import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive.dart';

class GoLiveScreen extends StatelessWidget {
  const GoLiveScreen({super.key});

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
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.sensors_rounded,
                color: Colors.black,
                size: 64.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Go Live Now',
              style: AppTextStyles.headingMedium(),
            ),
            SizedBox(height: 12.h),
            Text(
              'Set up your broadcast details, toggle filters, and start streaming to your audience in high definition.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: Theme.of(context).hintColor),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.h)),
                elevation: 4,
              ),
              child: Text(
                'Setup Stream',
                style: AppTextStyles.buttonText(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
