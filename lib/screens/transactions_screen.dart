import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _filter = 'All';
  final List<String> _filters = ['All', 'Income', 'Expenses'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final filteredTransactions = _filter == 'Income'
            ? provider.transactions
                .where((t) => t.type == TransactionType.credit)
                .toList()
            : _filter == 'Expenses'
                ? provider.transactions
                    .where((t) => t.type == TransactionType.debit)
                    .toList()
                : provider.transactions;

        // Group by date
        final grouped = <String, List<Transaction>>{};
        for (final t in filteredTransactions) {
          final key = _formatDateGroup(t.date);
          grouped.putIfAbsent(key, () => []).add(t);
        }

        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: AppTheme.bgPrimary,
                pinned: true,
                title: const Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.filter_list_rounded,
                        color: AppTheme.textSecondary),
                    onPressed: () {},
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(52),
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: Row(
                      children: _filters.map((f) {
                        final isSelected = _filter == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _filter = f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.accentPrimary
                                    : AppTheme.bgCard,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.accentPrimary
                                      : AppTheme.borderColor,
                                ),
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppTheme.bgPrimary
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              ...grouped.entries.map(
                (entry) => SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24, 16, 24, 8),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...entry.value.map(
                      (t) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 3),
                        child: TransactionTile(
                          transaction: t,
                          showDate: false,
                        ).animate().fadeIn(duration: 250.ms),
                      ),
                    ),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  String _formatDateGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) return 'TODAY';
    if (diff == 1) return 'YESTERDAY';
    if (diff < 7) return DateFormat('EEEE').format(date).toUpperCase();
    return DateFormat('MMMM d, yyyy').format(date).toUpperCase();
  }
}
