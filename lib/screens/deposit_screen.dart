import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bank_card_widget.dart';
import 'success_screen.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  final List<double> _quickAmounts = [50, 100, 200, 500, 1000];

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _deposit() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    setState(() => _isLoading = true);
    final provider = context.read<AppProvider>();
    final success = await provider.deposit(
      amount: amount,
      description: _descController.text,
      cardId: provider.selectedCard.id,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SuccessScreen(
              title: 'Deposit Successful!',
              subtitle: 'Your account has been credited.',
              amount: amount,
              type: 'Deposit',
            ),
          ),
        );
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.accentRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          appBar: AppBar(
            title: const Text('Deposit Money'),
            backgroundColor: AppTheme.bgPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selected Card
                const Text(
                  'Deposit to',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                BankCardWidget(
                  card: provider.selectedCard,
                  isSelected: true,
                  isExpanded: true,
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 32),

                // Amount input
                const Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixText: '\$ ',
                      prefixStyle: TextStyle(
                        fontSize: 24,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        fontSize: 28,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w300,
                      ),
                      contentPadding: EdgeInsets.all(20),
                      filled: false,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Quick amounts
                Wrap(
                  spacing: 10,
                  children: _quickAmounts
                      .map(
                        (amount) => GestureDetector(
                          onTap: () => _amountController.text =
                              amount.toStringAsFixed(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.bgElevated,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.borderColor),
                            ),
                            child: Text(
                              '\$${amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 24),

                // Description
                const Text(
                  'Description (optional)',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'e.g. Salary, Cash deposit...',
                    prefixIcon: const Icon(
                      Icons.edit_note_rounded,
                      color: AppTheme.textMuted,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                          color: AppTheme.accentPrimary, width: 1.5),
                    ),
                    filled: true,
                    fillColor: AppTheme.bgCard,
                  ),
                ),

                const SizedBox(height: 40),

                // Deposit button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _deposit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentPrimary,
                      foregroundColor: AppTheme.bgPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      disabledBackgroundColor:
                          AppTheme.accentPrimary.withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.bgPrimary),
                            ),
                          )
                        : const Text(
                            'Deposit Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
