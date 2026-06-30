import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';
import '../../../logic/cubits/navigation/navigation_cubit.dart';
import '../../../logic/cubits/navigation/navigation_state.dart';
import '../../../logic/cubits/stream/stream_cubit.dart';
import '../../../logic/cubits/stream/stream_state.dart';
import '../party/party_screen.dart';
import '../go_live/go_live_screen.dart';
import '../chats/chats_screen.dart';
import '../profile/profile_screen.dart';
import '../../../logic/cubits/theme/theme_cubit.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/location_pills.dart';
import 'widgets/stream_grid_item.dart';

import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<StreamCubit>().loadStreams();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
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
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, navState) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              bottom: false,
              child: BlocListener<NavigationCubit, NavigationState>(
                listener: (context, state) {
                  // Ensure page jumps/animates only if out of sync
                  if (_pageController.hasClients &&
                      _pageController.page?.round() != state.selectedIndex) {
                    _pageController.animateToPage(
                      state.selectedIndex,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                    );
                  }
                },
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<NavigationCubit>().setTab(index);
                  },
                  children: [
                    _buildLiveFeed(),
                    const PartyScreen(),
                    const GoLiveScreen(),
                    const ChatsScreen(),
                    const ProfileScreen(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNav(
              selectedIndex: navState.selectedIndex,
              onTap: (index) {
                context.read<NavigationCubit>().setTab(index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveFeed() {
    return BlocBuilder<StreamCubit, StreamState>(
      builder: (context, state) {
        if (state is StreamLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        } else if (state is StreamError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => context.read<StreamCubit>().loadStreams(),
                  child: const Text('Try Again'),
                )
              ],
            ),
          );
        } else if (state is StreamLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 16.h),
              _buildCategoryTabs(state.selectedCategory),
              SizedBox(height: 16.h),
              LocationPills(
                selectedCountry: state.selectedCountry,
                onCountrySelected: (country) {
                  context.read<StreamCubit>().setCountry(country);
                },
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onRefresh: () => context.read<StreamCubit>().loadStreams(),
                  child: state.filteredStreams.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: state.filteredStreams.length,
                          itemBuilder: (context, index) {
                            final stream = state.filteredStreams[index];
                            return StreamGridItem(
                              stream: stream,
                              onFollowTap: () {
                                context.read<StreamCubit>().toggleFollow(stream.id);
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Mini App Logo
          Row(
            children: [
              Container(
                width: 36.h,
                height: 36.h,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Center(
                  child: Icon(
                    Icons.videocam_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Alive',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontFamily: 'Outfit',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          // Right side: Theme toggle + Notifications with badge + User Avatar
          Row(
            children: [
              // Theme Toggle Button
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  final isDark = themeMode == ThemeMode.dark;
                  return IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 22.sp,
                    ),
                    onPressed: () {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  );
                },
              ),
              SizedBox(width: 4.w),

              // Notification icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 24.sp,
                    ),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 6.w,
                    top: 6.h,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4.w),
              // User Avatar
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  String? photoUrl;
                  if (state is Authenticated) {
                    photoUrl = state.user.photoUrl;
                  }

                  return GestureDetector(
                    onTap: () {
                      context.read<NavigationCubit>().setTab(4); // Open profile tab
                    },
                    child: Container(
                      width: 32.h,
                      height: 32.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 1.5.w),
                        image: photoUrl != null
                            ? DecorationImage(
                                image: NetworkImage(photoUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: photoUrl == null
                          ? const Icon(Icons.person_rounded, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(String selectedCategory) {
    final categories = ['Stream', 'Hot', 'Follow'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat;
          return GestureDetector(
            onTap: () {
              context.read<StreamCubit>().setCategory(cat);
            },
            child: Container(
              margin: EdgeInsets.only(right: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : Theme.of(context).hintColor,
                      fontSize: 16.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Animated indicator line below selected tab
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 2.h,
                    width: isSelected ? 20.w : 0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.live_tv_rounded,
            color: AppColors.textMuted,
            size: 48.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Active Streams Found',
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try switching your country filter or checking other categories.',
            style: AppTextStyles.bodySmall(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
