import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'pin_screen.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const PinScreen(),
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          // Background glow effects
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentPrimary.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentSecondary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppGradients.limeGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentPrimary.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'N',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.bgPrimary,
                        height: 1,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 20),

                // App name
                const Text(
                  'NEXUS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: 8,
                  ),
                )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 8),

                const Text(
                  'Smart Banking for the Future',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 500.ms),
              ],
            ),
          ),

          // Bottom loading indicator
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      backgroundColor: AppTheme.bgElevated,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.accentPrimary,
                      ),
                    ),
                  ),
                ).animate(delay: 800.ms).fadeIn(duration: 400.ms),
                const SizedBox(height: 16),
                const Text(
                  'Secured by 256-bit encryption',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                    letterSpacing: 0.3,
                  ),
                ).animate(delay: 900.ms).fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
