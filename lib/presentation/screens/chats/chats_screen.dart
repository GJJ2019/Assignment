import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(24.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.forum_rounded,
                color: AppColors.primary,
                size: 64.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Inbox & Messages',
              style: AppTextStyles.headingMedium(),
            ),
            SizedBox(height: 12.h),
            Text(
              'View updates, chat with other streamers, check notifications, and keep in touch with your friends list.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
