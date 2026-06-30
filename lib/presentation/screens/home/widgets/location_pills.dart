import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

class LocationPills extends StatelessWidget {
  final String selectedCountry;
  final Function(String) onCountrySelected;

  LocationPills({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  final List<Map<String, String>> countries = [
    {'name': 'Global', 'flag': '🌐'},
    {'name': 'India', 'flag': '🇮🇳'},
    {'name': 'Philippines', 'flag': '🇵🇭'},
    {'name': 'Brazil', 'flag': '🇧🇷'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: countries.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          final country = countries[index];
          final String name = country['name']!;
          final String flag = country['flag']!;
          final bool isSelected = selectedCountry.toLowerCase() == name.toLowerCase();

          return GestureDetector(
            onTap: () => onCountrySelected(name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(20.h),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.border,
                  width: 1.w,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    flag,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    name,
                    style: AppTextStyles.bodySmall(
                      color: isSelected ? Colors.black : AppColors.textPrimary,
                    ).copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
