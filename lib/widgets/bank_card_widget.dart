import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class BankCardWidget extends StatelessWidget {
  final BankCard card;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isExpanded;

  const BankCardWidget({
    super.key,
    required this.card,
    this.isSelected = false,
    this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final width = isExpanded
        ? MediaQuery.of(context).size.width - 48
        : 260.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [const Color(0xFF2A2A45), const Color(0xFF16162A)]
                : [const Color(0xFF1A1A2E), const Color(0xFF0D0D1A)],
          ),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentPrimary.withOpacity(0.4)
                : AppTheme.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accentPrimary.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Background circles decoration
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isSelected
                          ? AppTheme.accentPrimary
                          : AppTheme.accentSecondary)
                      .withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              right: 60,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentSecondary.withOpacity(0.04),
                ),
              ),
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top row: bank name + card type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card.bankName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      _buildCardTypeBadge(),
                    ],
                  ),

                  // Balance
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Balance',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${formatter.format(card.balance)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  // Bottom row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card.maskedNumber,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          letterSpacing: 2,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        card.expiryDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                          letterSpacing: 1,
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
    );
  }

  Widget _buildCardTypeBadge() {
    switch (card.type) {
      case CardType.visa:
        return const Text(
          'VISA',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
            fontStyle: FontStyle.italic,
          ),
        );
      case CardType.mastercard:
        return Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEB001B),
              ),
            ),
            Transform.translate(
              offset: const Offset(-8, 0),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF79E1B).withOpacity(0.9),
                ),
              ),
            ),
          ],
        );
      case CardType.verve:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppTheme.accentTertiary.withOpacity(0.2),
            border: Border.all(color: AppTheme.accentTertiary.withOpacity(0.4)),
          ),
          child: const Text(
            'VERVE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentTertiary,
              letterSpacing: 1,
            ),
          ),
        );
    }
  }
}
