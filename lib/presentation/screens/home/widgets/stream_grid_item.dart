import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../data/models/stream_model.dart';

class StreamGridItem extends StatelessWidget {
  final StreamModel stream;
  final VoidCallback onFollowTap;

  const StreamGridItem({
    super.key,
    required this.stream,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r ?? 16.h),
        border: Border.all(color: AppColors.border, width: 0.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Stream Preview Image (using NetworkImage)
          Positioned.fill(
            child: Image.network(
              stream.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.surfaceLight,
                child: const Icon(Icons.broken_image, color: AppColors.textMuted),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.surfaceLight,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                );
              },
            ),
          ),

          // Dark Gradient Overlay for readability at bottom and top
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x66000000),
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xB3000000),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.2, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Top Left: Viewer Count Badge
          Positioned(
            top: 10.h,
            left: 10.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.h),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.white,
                    size: 12.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    stream.viewerCount,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Content: Streamer Info & Follow Button
          Positioned(
            left: 10.w,
            right: 10.w,
            bottom: 10.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Streamer Avatar + Details
                Expanded(
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 32.h,
                        height: 32.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 1.5.w),
                          image: DecorationImage(
                            image: NetworkImage(stream.streamerAvatarUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Text Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              stream.streamerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black,
                                    offset: Offset(0, 1),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Text(
                                  stream.countryFlag,
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    stream.countryName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 9.sp,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.black,
                                          offset: Offset(0, 1),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Follow / Following Button
                GestureDetector(
                  onTap: onFollowTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      gradient: stream.isFollowing ? null : AppColors.primaryGradient,
                      color: stream.isFollowing ? Colors.black.withOpacity(0.5) : null,
                      borderRadius: BorderRadius.circular(10.h),
                      border: Border.all(
                        color: stream.isFollowing ? AppColors.border : Colors.transparent,
                        width: 0.5.w,
                      ),
                    ),
                    child: Text(
                      stream.isFollowing ? 'Following' : '+ Follow',
                      style: TextStyle(
                        color: stream.isFollowing ? AppColors.textSecondary : Colors.black,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper extension for radius responsiveness if not defined
extension ResponsiveRadius on num {
  double? get r => Responsive.getWidth(toDouble());
}
