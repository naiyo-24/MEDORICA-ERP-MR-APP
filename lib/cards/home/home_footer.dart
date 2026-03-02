import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'assets/images/home_footer.png',
        fit: BoxFit.fitWidth,
        width: double.infinity,
        alignment: Alignment.center,
        errorBuilder: (context, error, stack) {
          // Fallback: a subtle placeholder matching theme
          return Container(
            width: double.infinity,
            color: AppColors.surface.withAlpha(128),
            alignment: Alignment.center,
            child: Text('Creating a Cheaper and More Accessible Healthcare System', style: AppTypography.description.copyWith(color: AppColors.quaternary)),
          );
        },
      ),
    );
  }
}