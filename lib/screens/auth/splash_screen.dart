
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key});

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
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
		_scale = Tween<double>(begin: 0.8, end: 1.0)
				.animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
		_fade = Tween<double>(begin: 0.0, end: 1.0)
				.animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

		_controller.forward();

		// stay for 2.5 seconds then go to login
		Timer(const Duration(milliseconds: 2500), () {
			if (mounted) context.go('/login');
		});
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
