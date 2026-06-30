import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.h),
            side: BorderSide(color: Theme.of(context).dividerColor, width: 0.5.w),
          ),
          title: Text(
            'Log Out',
            style: AppTextStyles.headingSmall(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of your account?',
            style: AppTextStyles.bodyMedium(
              color: Theme.of(context).hintColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.h),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = 'Anonymous User';
        String email = '';
        String? avatarUrl;

        if (state is Authenticated) {
          name = state.user.displayName;
          email = state.user.email;
          avatarUrl = state.user.photoUrl;
        }

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Card container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24.r ?? 24.h),
                  border: Border.all(color: Theme.of(context).dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 90.h,
                      height: 90.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2.w),
                        image: avatarUrl != null
                            ? DecorationImage(
                                image: NetworkImage(avatarUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: avatarUrl == null
                          ? Icon(
                              Icons.person_rounded,
                              color: AppColors.textSecondary,
                              size: 48.sp,
                            )
                          : null,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingMedium(),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 24.h),
                    
                    // Simple Statistics Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(context, 'Followers', '1.4K'),
                        Container(
                          width: 1.w,
                          height: 30.h,
                          color: Theme.of(context).dividerColor,
                        ),
                        _buildStat(context, 'Following', '186'),
                        Container(
                          width: 1.w,
                          height: 30.h,
                          color: Theme.of(context).dividerColor,
                        ),
                        _buildStat(context, 'Live Level', 'Lv. 12'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Logout Button
              GestureDetector(
                onTap: () async {
                  final confirm = await _showLogoutConfirmationDialog(context);
                  if (confirm == true && context.mounted) {
                    context.read<AuthCubit>().logout();
                  }
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28.h),
                      border: Border.all(color: AppColors.error.withOpacity(0.5)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: AppColors.error,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Log Out Account',
                            style: AppTextStyles.buttonText(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headingSmall(color: AppColors.primary),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodySmall(color: Theme.of(context).hintColor),
        ),
      ],
    );
  }
}

// Extension to support r (radius) safely
extension on num {
  double? get r => Responsive.getWidth(toDouble());
}
