import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'home/main_screen.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final String type;

  const SuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final now = DateFormat('MMM d, yyyy • h:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          // Glow
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3 - 100,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentPrimary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Spacer(),

                  // Success icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: AppGradients.limeGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentPrimary.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 48,
                      color: AppTheme.bgPrimary,
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 300.ms),

                  const SizedBox(height: 28),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: 40),

                  // Receipt card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: AppTheme.accentPrimary.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        _ReceiptRow(
                            label: 'Amount',
                            value: '\$${formatter.format(amount)}',
                            isHighlight: true),
                        const Divider(height: 24, color: AppTheme.borderColor),
                        _ReceiptRow(label: 'Transaction Type', value: type),
                        const SizedBox(height: 8),
                        _ReceiptRow(label: 'Date & Time', value: now),
                        const SizedBox(height: 8),
                        _ReceiptRow(
                          label: 'Reference',
                          value:
                              'NXS${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                        ),
                        const SizedBox(height: 8),
                        const _ReceiptRow(
                            label: 'Status',
                            value: 'Completed',
                            statusColor: AppTheme.accentTertiary),
                      ],
                    ),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const Spacer(),

                  // Buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const MainScreen()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Back to Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Share Receipt',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  final Color? statusColor;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 18 : 13,
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
            color: statusColor ??
                (isHighlight ? AppTheme.accentPrimary : AppTheme.textPrimary),
            letterSpacing: isHighlight ? -0.5 : 0,
          ),
        ),
      ],
    );
  }
}
