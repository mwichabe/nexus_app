import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'success_screen.dart';

class PayBillsScreen extends StatefulWidget {
  const PayBillsScreen({super.key});

  @override
  State<PayBillsScreen> createState() => _PayBillsScreenState();
}

class _PayBillsScreenState extends State<PayBillsScreen> {
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  _Biller? _selectedBiller;
  bool _isLoading = false;

  final List<_Biller> _billers = [
    _Biller(
        name: 'Kenya Power',
        icon: Icons.bolt_rounded,
        color: const Color(0xFF4FC3F7),
        category: 'Utilities'),
    _Biller(
        name: 'Safaricom',
        icon: Icons.phone_android_rounded,
        color: const Color(0xFF69F0AE),
        category: 'Airtime'),
    _Biller(
        name: 'DSTV',
        icon: Icons.tv_rounded,
        color: const Color(0xFFFF80AB),
        category: 'TV'),
    _Biller(
        name: 'Nairobi Water',
        icon: Icons.water_drop_rounded,
        color: AppTheme.accentTertiary,
        category: 'Utilities'),
    _Biller(
        name: 'KRA iTax',
        icon: Icons.receipt_long_rounded,
        color: AppTheme.accentWarn,
        category: 'Tax'),
    _Biller(
        name: 'Airtel',
        icon: Icons.wifi_rounded,
        color: AppTheme.accentSecondary,
        category: 'Internet'),
    _Biller(
        name: 'NHIF',
        icon: Icons.local_hospital_rounded,
        color: const Color(0xFFFF6B35),
        category: 'Insurance'),
    _Biller(
        name: 'NSSF',
        icon: Icons.shield_rounded,
        color: AppTheme.accentPrimary,
        category: 'Pension'),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _payBill() async {
    if (_selectedBiller == null) {
      _showError('Select a biller');
      return;
    }
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Enter a valid amount');
      return;
    }
    if (_accountController.text.isEmpty) {
      _showError('Enter account reference');
      return;
    }

    final provider = context.read<AppProvider>();
    if (amount > provider.selectedCard.balance) {
      _showError('Insufficient funds');
      return;
    }

    setState(() => _isLoading = true);
    final success = await provider.payBill(
      amount: amount,
      biller: _selectedBiller!.name,
      accountRef: _accountController.text,
      cardId: provider.selectedCard.id,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SuccessScreen(
              title: 'Bill Payment Successful!',
              subtitle: '${_selectedBiller!.name} paid successfully.',
              amount: amount,
              type: 'Bill Payment',
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
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: const Text('Pay Bills'),
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
            const Text(
              'Select Biller',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),

            // Billers grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _billers.length,
              itemBuilder: (context, i) {
                final biller = _billers[i];
                final isSelected = _selectedBiller?.name == biller.name;

                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedBiller = biller),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? biller.color.withOpacity(0.15)
                          : AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? biller.color.withOpacity(0.5)
                            : AppTheme.borderColor,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          biller.icon,
                          size: 26,
                          color: biller.color,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          biller.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? biller.color
                                : AppTheme.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate(delay: (i * 30).ms)
                    .fadeIn(duration: 250.ms)
                    .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1));
              },
            ),

            const SizedBox(height: 28),

            if (_selectedBiller != null) ...[
              // Selected biller info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedBiller!.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: _selectedBiller!.color.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(_selectedBiller!.icon,
                        color: _selectedBiller!.color),
                    const SizedBox(width: 12),
                    Text(
                      _selectedBiller!.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _selectedBiller!.color,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _selectedBiller!.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedBiller!.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: _selectedBiller!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              TextField(
                controller: _accountController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Account / Meter Number',
                  prefixIcon: const Icon(Icons.tag_rounded,
                      color: AppTheme.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppTheme.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppTheme.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: _selectedBiller!.color, width: 1.5),
                  ),
                  filled: true,
                  fillColor: AppTheme.bgCard,
                ),
              ),

              const SizedBox(height: 16),

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

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _payBill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedBiller?.color ??
                        AppTheme.accentPrimary,
                    foregroundColor: AppTheme.bgPrimary,
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
                                AppTheme.bgPrimary),
                          ),
                        )
                      : const Text(
                          'Pay Bill',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Biller {
  final String name;
  final IconData icon;
  final Color color;
  final String category;

  _Biller({
    required this.name,
    required this.icon,
    required this.color,
    required this.category,
  });
}
