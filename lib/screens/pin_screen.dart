import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home/main_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  bool _isLoading = false;
  bool _shakeError = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  static const int _pinLength = 4;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _addDigit(String digit) {
    if (_pin.length >= _pinLength || _isLoading) return;
    setState(() {
      _pin += digit;
      _shakeError = false;
    });
    if (_pin.length == _pinLength) {
      _authenticate();
    }
  }

  void _removeDigit() {
    if (_pin.isEmpty || _isLoading) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _clearPin() {
    setState(() => _pin = '');
  }

  Future<void> _authenticate() async {
    setState(() => _isLoading = true);
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.authenticateWithPin(_pin);

    if (success && mounted) {
      _navigateToHome();
    } else if (mounted) {
      _clearPin();
      setState(() {
        _isLoading = false;
        _shakeError = true;
      });
      _shakeController.forward(from: 0);
    }
  }

  Future<void> _biometricAuth() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.authenticateWithBiometrics();
    if (success && mounted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F0F1A),
                    AppTheme.bgPrimary,
                  ],
                ),
              ),
            ),
          ),

          // Glow effect top left
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentPrimary.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo & greeting
                Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppGradients.limeGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentPrimary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'N',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.bgPrimary,
                            height: 1,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                        ),

                    const SizedBox(height: 24),

                    const Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ).animate(delay: 100.ms).fadeIn(),

                    const SizedBox(height: 4),

                    const Text(
                      'Alex Morgan',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ).animate(delay: 150.ms).fadeIn(),
                  ],
                ),

                const SizedBox(height: 48),

                // PIN dots
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return Column(
                      children: [
                        Text(
                          _isLoading
                              ? 'Verifying...'
                              : auth.errorMessage.isNotEmpty
                                  ? auth.errorMessage
                                  : 'Enter your 4-digit PIN',
                          style: TextStyle(
                            fontSize: 14,
                            color: auth.errorMessage.isNotEmpty
                                ? AppTheme.accentRed
                                : AppTheme.textSecondary,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ).animate(key: ValueKey(auth.errorMessage)).fadeIn(),

                        const SizedBox(height: 8),

                        const Text(
                          'Demo PIN: 1234',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),

                        const SizedBox(height: 32),

                        AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            final shake =
                                _shakeError ? (_shakeAnimation.value * 8) : 0;
                            return Transform.translate(
                              offset: Offset(
                                shake * ((_shakeController.value * 10) % 2 == 0
                                    ? 1
                                    : -1),
                                0,
                              ),
                              child: child,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pinLength,
                              (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i < _pin.length
                                      ? _shakeError
                                          ? AppTheme.accentRed
                                          : AppTheme.accentPrimary
                                      : AppTheme.bgElevated,
                                  border: Border.all(
                                    color: i < _pin.length
                                        ? Colors.transparent
                                        : AppTheme.borderAccent,
                                    width: 1.5,
                                  ),
                                  boxShadow: i < _pin.length
                                      ? [
                                          BoxShadow(
                                            color: (_shakeError
                                                    ? AppTheme.accentRed
                                                    : AppTheme.accentPrimary)
                                                .withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const Spacer(),

                // Numpad
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      _buildNumRow(['1', '2', '3']),
                      const SizedBox(height: 16),
                      _buildNumRow(['4', '5', '6']),
                      const SizedBox(height: 16),
                      _buildNumRow(['7', '8', '9']),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Biometric button
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) => _buildActionButton(
                              icon: Icons.fingerprint_rounded,
                              onTap: auth.biometricsAvailable
                                  ? _biometricAuth
                                  : null,
                              color: auth.biometricsAvailable
                                  ? AppTheme.accentTertiary
                                  : AppTheme.textMuted,
                            ),
                          ),
                          _buildNumButton('0'),
                          _buildActionButton(
                            icon: Icons.backspace_outlined,
                            onTap: _removeDigit,
                            color: AppTheme.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _buildNumButton(d)).toList(),
    );
  }

  Widget _buildNumButton(String digit) {
    return GestureDetector(
      onTap: () => _addDigit(digit),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.bgCard,
          border: Border.all(color: AppTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 28,
            color: color ?? AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
