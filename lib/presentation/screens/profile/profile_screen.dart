import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          color: AppColors.background,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Card container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24.r ?? 24.h),
                  border: Border.all(color: AppColors.border),
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
                        _buildStat('Followers', '1.4K'),
                        Container(
                          width: 1.w,
                          height: 30.h,
                          color: AppColors.border,
                        ),
                        _buildStat('Following', '186'),
                        Container(
                          width: 1.w,
                          height: 30.h,
                          color: AppColors.border,
                        ),
                        _buildStat('Live Level', 'Lv. 12'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Logout Button
              GestureDetector(
                onTap: () {
                  context.read<AuthCubit>().logout();
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

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headingSmall(color: AppColors.primary),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// Extension to support r (radius) safely
extension on num {
  double? get r => Responsive.getWidth(toDouble());
}
