import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TransactionType { credit, debit }
enum TransactionCategory {
  transfer,
  shopping,
  food,
  transport,
  utilities,
  entertainment,
  salary,
  investment,
  withdrawal,
  deposit
}

class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? note;
  final bool isPending;

  const Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
    this.isPending = false,
  });

  Color get categoryColor {
    switch (category) {
      case TransactionCategory.transfer:
        return AppTheme.accentSecondary;
      case TransactionCategory.shopping:
        return AppTheme.accentWarn;
      case TransactionCategory.food:
        return const Color(0xFFFFB836);
      case TransactionCategory.transport:
        return AppTheme.accentTertiary;
      case TransactionCategory.utilities:
        return const Color(0xFF4FC3F7);
      case TransactionCategory.entertainment:
        return const Color(0xFFFF80AB);
      case TransactionCategory.salary:
        return AppTheme.accentPrimary;
      case TransactionCategory.investment:
        return const Color(0xFF69F0AE);
      case TransactionCategory.withdrawal:
        return AppTheme.accentRed;
      case TransactionCategory.deposit:
        return AppTheme.accentTertiary;
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case TransactionCategory.transfer:
        return Icons.swap_horiz_rounded;
      case TransactionCategory.shopping:
        return Icons.shopping_bag_rounded;
      case TransactionCategory.food:
        return Icons.restaurant_rounded;
      case TransactionCategory.transport:
        return Icons.directions_car_rounded;
      case TransactionCategory.utilities:
        return Icons.bolt_rounded;
      case TransactionCategory.entertainment:
        return Icons.movie_rounded;
      case TransactionCategory.salary:
        return Icons.account_balance_rounded;
      case TransactionCategory.investment:
        return Icons.trending_up_rounded;
      case TransactionCategory.withdrawal:
        return Icons.atm_rounded;
      case TransactionCategory.deposit:
        return Icons.add_circle_rounded;
    }
  }
}

class BankCard {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final String bankName;
  final double balance;
  final CardType type;
  final List<Color> gradientColors;

  const BankCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    required this.bankName,
    required this.balance,
    required this.type,
    required this.gradientColors,
  });

  String get maskedNumber =>
      '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
}

enum CardType { visa, mastercard, verve }

class Contact {
  final String id;
  final String name;
  final String phone;
  final String initials;
  final Color avatarColor;
  final String? accountNumber;

  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.initials,
    required this.avatarColor,
    this.accountNumber,
  });
}

class SpendingCategory {
  final String label;
  final double amount;
  final double percentage;
  final Color color;
  final IconData icon;

  const SpendingCategory({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

class SavingsGoal {
  final String id;
  final String title;
  final double target;
  final double current;
  final Color color;
  final IconData icon;
  final DateTime deadline;

  const SavingsGoal({
    required this.id,
    required this.title,
    required this.target,
    required this.current,
    required this.color,
    required this.icon,
    required this.deadline,
  });

  double get progress => current / target;
  double get remaining => target - current;
}
