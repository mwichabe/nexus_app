import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'success_screen.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;
  String _selectedMethod = 'ATM';

  final List<String> _methods = ['ATM', 'Bank Counter', 'Agent'];
  final List<double> _quickAmounts = [50, 100, 200, 500];

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _withdraw() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    final provider = context.read<AppProvider>();
    if (amount > provider.selectedCard.balance) {
      _showError('Insufficient funds');
      return;
    }

    setState(() => _isLoading = true);
    final success = await provider.withdraw(
      amount: amount,
      description: _descController.text.isEmpty
          ? '$_selectedMethod Withdrawal'
          : _descController.text,
      cardId: provider.selectedCard.id,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SuccessScreen(
              title: 'Withdrawal Successful!',
              subtitle: 'Your cash is ready for collection.',
              amount: amount,
              type: 'Withdrawal',
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
        final formatter = NumberFormat('#,##0.00', 'en_US');

        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          appBar: AppBar(
            title: const Text('Withdraw Cash'),
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
                // Balance info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppTheme.accentSecondary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.accentSecondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppTheme.accentSecondary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Balance',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            '\$${formatter.format(provider.selectedCard.balance)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 28),

                // Amount
                const Text(
                  'Amount to Withdraw',
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
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixText: '\$ ',
                      prefixStyle: TextStyle(
                        fontSize: 24,
                        color: AppTheme.textSecondary,
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

                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  children: _quickAmounts
                      .map(
                        (a) => GestureDetector(
                          onTap: () =>
                              _amountController.text = a.toStringAsFixed(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.bgElevated,
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: AppTheme.borderColor),
                            ),
                            child: Text(
                              '\$${a.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 24),

                // Withdrawal method
                const Text(
                  'Withdrawal Method',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: _methods
                      .map(
                        (method) => Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedMethod = method),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(
                                right: method != _methods.last ? 8 : 0,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedMethod == method
                                    ? AppTheme.accentSecondary
                                        .withOpacity(0.15)
                                    : AppTheme.bgCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _selectedMethod == method
                                      ? AppTheme.accentSecondary
                                          .withOpacity(0.4)
                                      : AppTheme.borderColor,
                                  width: _selectedMethod == method ? 1.5 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  method,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _selectedMethod == method
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: _selectedMethod == method
                                        ? AppTheme.accentSecondary
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _withdraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentSecondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                        : const Text(
                            'Withdraw Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
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
