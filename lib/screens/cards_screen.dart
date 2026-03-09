import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bank_card_widget.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  bool _showCardNumber = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final card = provider.selectedCard;
        final formatter = NumberFormat('#,##0.00', 'en_US');

        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: AppTheme.bgPrimary,
                pinned: true,
                title: const Text(
                  'My Cards',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () => _showAddCardSheet(context),
                    icon: const Icon(Icons.add_rounded,
                        color: AppTheme.accentPrimary, size: 18),
                    label: const Text(
                      'Add Card',
                      style: TextStyle(
                        color: AppTheme.accentPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              // Cards list
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: provider.cards.asMap().entries.map((entry) {
                      final i = entry.key;
                      final c = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => provider.selectCard(i),
                          child: BankCardWidget(
                            card: c,
                            isSelected: i == provider.selectedCardIndex,
                            isExpanded: true,
                          ),
                        )
                            .animate(delay: (i * 100).ms)
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.1, end: 0),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Card details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Card Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.bgCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Column(
                          children: [
                            _CardDetailRow(
                              label: 'Card Number',
                              value: _showCardNumber
                                  ? card.cardNumber
                                      .replaceAllMapped(RegExp(r'.{4}'),
                                          (m) => '${m.group(0)} ')
                                      .trim()
                                  : card.maskedNumber,
                              trailing: GestureDetector(
                                onTap: () => setState(
                                    () => _showCardNumber = !_showCardNumber),
                                child: Icon(
                                  _showCardNumber
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 18,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                            const Divider(
                                height: 1,
                                color: AppTheme.borderColor,
                                indent: 16,
                                endIndent: 16),
                            _CardDetailRow(
                              label: 'Cardholder',
                              value: card.cardHolder,
                            ),
                            const Divider(
                                height: 1,
                                color: AppTheme.borderColor,
                                indent: 16,
                                endIndent: 16),
                            _CardDetailRow(
                              label: 'Expiry Date',
                              value: card.expiryDate,
                            ),
                            const Divider(
                                height: 1,
                                color: AppTheme.borderColor,
                                indent: 16,
                                endIndent: 16),
                            _CardDetailRow(
                              label: 'Balance',
                              value: '\$${formatter.format(card.balance)}',
                              valueColor: AppTheme.accentPrimary,
                            ),
                          ],
                        ),
                      ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: 24),

                      // Card actions
                      const Text(
                        'Card Actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.5,
                        children: const [
                          _CardActionTile(
                            icon: Icons.block_rounded,
                            label: 'Freeze Card',
                            color: AppTheme.accentSecondary,
                          ),
                          _CardActionTile(
                            icon: Icons.contactless_rounded,
                            label: 'Tap to Pay',
                            color: AppTheme.accentTertiary,
                          ),
                          _CardActionTile(
                            icon: Icons.pin_rounded,
                            label: 'Change PIN',
                            color: AppTheme.accentWarn,
                          ),
                          _CardActionTile(
                            icon: Icons.credit_card_off_rounded,
                            label: 'Report Lost',
                            color: AppTheme.accentRed,
                          ),
                        ],
                      ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  void _showAddCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgSecondary,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Card',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Link an existing card to your account',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            _buildTextField(hint: 'Card Number'),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _buildTextField(hint: 'MM/YY')),
                const SizedBox(width: 14),
                Expanded(child: _buildTextField(hint: 'CVV')),
              ],
            ),
            const SizedBox(height: 14),
            _buildTextField(hint: 'Cardholder Name'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Add Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint}) {
    return TextField(
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppTheme.accentPrimary, width: 1.5),
        ),
        filled: true,
        fillColor: AppTheme.bgCard,
      ),
    );
  }
}

class _CardDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final Widget? trailing;

  const _CardDetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppTheme.textPrimary,
              fontFamily: label == 'Card Number' ? 'monospace' : null,
              letterSpacing: label == 'Card Number' ? 1 : 0,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _CardActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CardActionTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
