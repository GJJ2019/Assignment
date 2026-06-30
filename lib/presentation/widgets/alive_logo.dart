import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';

class AliveLogo extends StatelessWidget {
  final double size;

  const AliveLogo({super.key, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    final double scaledSize = size.w;
    return Container(
      width: scaledSize,
      height: scaledSize,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(scaledSize * 0.25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: scaledSize * 0.12, horizontal: scaledSize * 0.08),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Alive',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                fontFamily: 'Outfit',
              ),
            ),
            SizedBox(height: 8),
            Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 45,
            ),
          ],
        ),
      ),
    );
  }
}
