import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'success_screen.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  Contact? _selectedContact;
  bool _isLoading = false;
  int _step = 0; // 0=select recipient, 1=enter amount

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _transfer() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Enter a valid amount');
      return;
    }
    if (_selectedContact == null) {
      _showError('Select a recipient');
      return;
    }

    final provider = context.read<AppProvider>();
    if (amount > provider.selectedCard.balance) {
      _showError('Insufficient funds');
      return;
    }

    setState(() => _isLoading = true);
    final success = await provider.transfer(
      amount: amount,
      recipient: _selectedContact!,
      note: _noteController.text,
      cardId: provider.selectedCard.id,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SuccessScreen(
              title: 'Transfer Successful!',
              subtitle:
                  'Sent to ${_selectedContact!.name}',
              amount: amount,
              type: 'Transfer',
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
            title: const Text('Send Money'),
            backgroundColor: AppTheme.bgPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                if (_step == 1) {
                  setState(() => _step = 0);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: _step == 0
              ? _buildSelectRecipient(context, provider)
              : _buildAmountStep(context, provider),
        );
      },
    );
  }

  Widget _buildSelectRecipient(BuildContext context, AppProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send to',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select from your contacts',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 24),

          // Search bar
          TextField(
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search contacts or enter account',
              prefixIcon: const Icon(
                Icons.search_rounded,
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
                    color: AppTheme.accentTertiary, width: 1.5),
              ),
              filled: true,
              fillColor: AppTheme.bgCard,
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Recent Contacts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 16),

          ...provider.contacts.asMap().entries.map(
            (entry) {
              final i = entry.key;
              final contact = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedContact = contact;
                      _step = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: contact.avatarColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              contact.initials,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: contact.avatarColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                contact.phone,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppTheme.textMuted,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate(delay: (i * 50).ms)
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: 0.1, end: 0),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmountStep(BuildContext context, AppProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipient info
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppTheme.accentTertiary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _selectedContact!.avatarColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      _selectedContact!.initials,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _selectedContact!.avatarColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedContact!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      _selectedContact!.phone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _step = 0),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.accentTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 32),

          // Amount
          const Text(
            'How much?',
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
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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

          const SizedBox(height: 20),

          TextField(
            controller: _noteController,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Add a note (optional)',
              prefixIcon: const Icon(Icons.note_rounded,
                  color: AppTheme.textMuted),
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
                    color: AppTheme.accentTertiary, width: 1.5),
              ),
              filled: true,
              fillColor: AppTheme.bgCard,
            ),
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _transfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentTertiary,
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
                      'Send Money',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
