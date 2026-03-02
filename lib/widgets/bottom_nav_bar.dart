import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../router/app_router.dart';
import '../../theme/app_theme.dart';

class MRBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const MRBottomNavBar({super.key, this.currentIndex = 0});

  @override
  State<MRBottomNavBar> createState() => _MRBottomNavBarState();
}

class _MRBottomNavBarState extends State<MRBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(MRBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _selectedIndex = widget.currentIndex;
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    // Navigate based on selected tab using GoRouter
    switch (index) {
      case 0:
        context.go(AppRouter.home);
        break;
      case 1:
        context.go(AppRouter.doctor);
        break;
      case 2:
        context.go(AppRouter.appointments);
        break;
      case 3:
        context.go(AppRouter.orders);
        break;
      case 4:
        context.go(AppRouter.chemist);
        break;
      case 5:
        context.go(AppRouter.distributor);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _NavItem(label: 'Home',
       icon: Iconsax.home,
        filledIcon: Iconsax.home5
      ),
      _NavItem(label: 'My Doctors', 
      icon: FontAwesomeIcons.userDoctor, 
      filledIcon: FontAwesomeIcons.userDoctor
      ),
      _NavItem(
        label: 'Appointments',
        icon: Iconsax.calendar,
        filledIcon: Iconsax.calendar, 
      ),
      _NavItem(
        label: 'My Orders',
        icon: Iconsax.receipt,
        filledIcon: Iconsax.receipt_15,
      ),
      _NavItem(
        label: 'Shops',
        icon: Iconsax.shop,
        filledIcon: Iconsax.shop,
      ),
      _NavItem(
        label: 'Distributors',
        icon: Iconsax.truck,
        filledIcon: Iconsax.truck,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navItems.length,
              (index) => Expanded(
                child: _NavBarItem(
                  navItem: navItems[index],
                  isSelected: _selectedIndex == index,
                  onTap: () => _onItemTapped(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final _NavItem navItem;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.navItem,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation =
        ColorTween(begin: Colors.grey.shade500, end: AppColors.primary).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(_NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    final iconSize = Theme.of(context).iconTheme.size ?? 24.0;
                    return Icon(
                      widget.isSelected
                          ? widget.navItem.filledIcon
                          : widget.navItem.icon,
                      color: _colorAnimation.value,
                      size: iconSize,
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return Text(
                    widget.navItem.label,
                    style: AppTypography.caption.copyWith(
                      color: _colorAnimation.value,
                      fontSize: 9,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
              // Indicator
              if (widget.isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(100),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData filledIcon;

  _NavItem({required this.label, required this.icon, required this.filledIcon});
}