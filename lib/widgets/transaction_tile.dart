import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final bool showDate;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');
    final isCredit = transaction.type == TransactionType.credit;

    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: transaction.categoryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                transaction.categoryIcon,
                size: 20,
                color: transaction.categoryColor,
              ),
            ),

            const SizedBox(width: 14),

            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        transaction.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (transaction.isPending) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppTheme.accentWarn.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.accentWarn,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Amount & date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}\$${formatter.format(transaction.amount)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isCredit
                        ? AppTheme.accentTertiary
                        : AppTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                if (showDate) ...[
                  const SizedBox(height: 3),
                  Text(
                    '${dateFormat.format(transaction.date)} · ${timeFormat.format(transaction.date)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final dateFormat = DateFormat('EEEE, MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final isCredit = transaction.type == TransactionType.credit;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Icon + amount
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: transaction.categoryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                transaction.categoryIcon,
                size: 30,
                color: transaction.categoryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${isCredit ? '+' : '-'}\$${formatter.format(transaction.amount)}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: isCredit
                    ? AppTheme.accentTertiary
                    : AppTheme.textPrimary,
                letterSpacing: -1,
              ),
            ),
            Text(
              transaction.title,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 28),

            // Details
            _DetailRow(
                label: 'Category',
                value: transaction.category.name.toUpperCase()),
            _DetailRow(label: 'Date',
                value: dateFormat.format(transaction.date)),
            _DetailRow(label: 'Time',
                value: timeFormat.format(transaction.date)),
            _DetailRow(
                label: 'Status',
                value: transaction.isPending ? 'Pending' : 'Completed'),
            if (transaction.note != null)
              _DetailRow(label: 'Note', value: transaction.note!),
            _DetailRow(
                label: 'Reference', value: 'TXN${transaction.id.toUpperCase()}'),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
