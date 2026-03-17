import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../provider/auth_provider.dart';
import '../../provider/profile_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Timer(const Duration(milliseconds: 2500), _routeAfterSplash);
  }

  Future<void> _routeAfterSplash() async {
    final bool restored = await ref
        .read(authNotifierProvider.notifier)
        .restoreSession();

    if (!mounted) {
      return;
    }

    if (restored) {
      try {
        await ref.read(profileProvider.notifier).fetchCurrentMrProfile();
      } catch (_) {
        // Profile can retry if backend is temporarily unavailable.
      }
      if (mounted) {
        context.go(AppRouter.home);
      }
      return;
    }

    context.go(AppRouter.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo/logo.png', width: 400, height: 400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
