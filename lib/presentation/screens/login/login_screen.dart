import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';
import '../../widgets/alive_logo.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.fastLinearToSlowEaseIn),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Route _createHomeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween<double>(begin: 0.92, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );
        final fadeTween = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
        );
        final slideTween = Tween<Offset>(begin: const Offset(0.0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );

        return FadeTransition(
          opacity: fadeTween,
          child: SlideTransition(
            position: slideTween,
            child: ScaleTransition(
              scale: scaleTween,
              child: child,
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 750),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(_createHomeRoute());
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Stack(
            children: [
              // Abstract light leaks/gradient background decoration
              Positioned(
                bottom: -150.h,
                right: -100.w,
                child: Container(
                  width: 350.w,
                  height: 350.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                top: 80.h,
                left: 30.w,
                child: Container(
                  width: 150.w,
                  height: 150.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.04),
                  ),
                ),
              ),

              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AliveLogo(size: 96),
                            SizedBox(height: 48.h),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Welcome back!',
                                  style: AppTextStyles.headingMedium(),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '👋',
                                  style: TextStyle(fontSize: 24.sp),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Sign in to continue your live streaming journey.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: 64.h),

                            // Animated Google Login Button
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: state is AuthLoading
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Connecting...',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          key: const ValueKey('button'),
                                          onTap: () {
                                            context.read<AuthCubit>().loginWithGoogle();
                                          },
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: double.infinity,
                                              height: 56.h,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(28.h),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.08),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 20.w,
                                                          height: 20.w,
                                                          margin: EdgeInsets.only(right: 12.w),
                                                          child: SvgPicture.asset(
                                                            'assets/icons/google.svg',
                                                            width: 20.w,
                                                            height: 20.w,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Continue with Google',
                                                          style: AppTextStyles.buttonText(color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 18.h),
                                        GestureDetector(
                                          onTap: () {
                                            context.read<AuthCubit>().loginAnonymously();
                                          },
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.h),
                                              child: Text(
                                                'Continue as Guest',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
