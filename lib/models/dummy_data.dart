import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class DummyData {
  static final List<Transaction> transactions = [
    Transaction(
      id: 't1',
      title: 'Monthly Salary',
      subtitle: 'TechCorp Inc.',
      amount: 4850.00,
      type: TransactionType.credit,
      category: TransactionCategory.salary,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 't2',
      title: 'Netflix Subscription',
      subtitle: 'Entertainment',
      amount: 15.99,
      type: TransactionType.debit,
      category: TransactionCategory.entertainment,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 't3',
      title: 'Uber Eats',
      subtitle: 'Food & Dining',
      amount: 32.50,
      type: TransactionType.debit,
      category: TransactionCategory.food,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 't4',
      title: 'Transfer to Sarah',
      subtitle: 'Personal Transfer',
      amount: 200.00,
      type: TransactionType.debit,
      category: TransactionCategory.transfer,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: 't5',
      title: 'Apple Store',
      subtitle: 'Shopping',
      amount: 129.00,
      type: TransactionType.debit,
      category: TransactionCategory.shopping,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Transaction(
      id: 't6',
      title: 'Investment Return',
      subtitle: 'Nexus Invest',
      amount: 312.45,
      type: TransactionType.credit,
      category: TransactionCategory.investment,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      id: 't7',
      title: 'Electricity Bill',
      subtitle: 'DSTV Kenya',
      amount: 89.00,
      type: TransactionType.debit,
      category: TransactionCategory.utilities,
      date: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Transaction(
      id: 't8',
      title: 'Cash Deposit',
      subtitle: 'ATM Deposit',
      amount: 500.00,
      type: TransactionType.credit,
      category: TransactionCategory.deposit,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Transaction(
      id: 't9',
      title: 'Bolt Ride',
      subtitle: 'Transport',
      amount: 12.00,
      type: TransactionType.debit,
      category: TransactionCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Transaction(
      id: 't10',
      title: 'Jumia Shopping',
      subtitle: 'E-commerce',
      amount: 245.80,
      type: TransactionType.debit,
      category: TransactionCategory.shopping,
      date: DateTime.now().subtract(const Duration(days: 9)),
    ),
    Transaction(
      id: 't11',
      title: 'ATM Withdrawal',
      subtitle: 'Westlands Branch',
      amount: 300.00,
      type: TransactionType.debit,
      category: TransactionCategory.withdrawal,
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Transaction(
      id: 't12',
      title: 'Freelance Payment',
      subtitle: 'Upwork',
      amount: 750.00,
      type: TransactionType.credit,
      category: TransactionCategory.salary,
      date: DateTime.now().subtract(const Duration(days: 12)),
      isPending: false,
    ),
  ];

  static final List<BankCard> cards = [
    BankCard(
      id: 'c1',
      cardNumber: '4532123456789012',
      cardHolder: 'Alex Morgan',
      expiryDate: '12/27',
      cvv: '456',
      bankName: 'Nexus Bank',
      balance: 12_847.55,
      type: CardType.visa,
      gradientColors: [const Color(0xFF1A1A35), const Color(0xFF0D0D20)],
    ),
    BankCard(
      id: 'c2',
      cardNumber: '5301234567890123',
      cardHolder: 'Alex Morgan',
      expiryDate: '08/26',
      cvv: '789',
      bankName: 'Nexus Savings',
      balance: 35_210.00,
      type: CardType.mastercard,
      gradientColors: [const Color(0xFF1A2A1A), const Color(0xFF0D1A0D)],
    ),
  ];

  static final List<Contact> contacts = [
    Contact(
      id: 'u1',
      name: 'Sarah Chen',
      phone: '+254 712 345 678',
      initials: 'SC',
      avatarColor: AppTheme.accentSecondary,
      accountNumber: '1234567890',
    ),
    Contact(
      id: 'u2',
      name: 'James Odhiambo',
      phone: '+254 723 456 789',
      initials: 'JO',
      avatarColor: AppTheme.accentTertiary,
      accountNumber: '0987654321',
    ),
    Contact(
      id: 'u3',
      name: 'Priya Sharma',
      phone: '+254 734 567 890',
      initials: 'PS',
      avatarColor: AppTheme.accentWarn,
      accountNumber: '1122334455',
    ),
    Contact(
      id: 'u4',
      name: 'Kevin Mwangi',
      phone: '+254 745 678 901',
      initials: 'KM',
      avatarColor: const Color(0xFFFF80AB),
      accountNumber: '5544332211',
    ),
    Contact(
      id: 'u5',
      name: 'Amina Hassan',
      phone: '+254 756 789 012',
      initials: 'AH',
      avatarColor: const Color(0xFFFFB836),
      accountNumber: '6677889900',
    ),
  ];

  static final List<SpendingCategory> spendingCategories = [
    SpendingCategory(
      label: 'Shopping',
      amount: 374.80,
      percentage: 32,
      color: AppTheme.accentWarn,
      icon: Icons.shopping_bag_rounded,
    ),
    SpendingCategory(
      label: 'Food',
      amount: 215.50,
      percentage: 18,
      color: const Color(0xFFFFB836),
      icon: Icons.restaurant_rounded,
    ),
    SpendingCategory(
      label: 'Transport',
      amount: 120.00,
      percentage: 10,
      color: AppTheme.accentTertiary,
      icon: Icons.directions_car_rounded,
    ),
    SpendingCategory(
      label: 'Entertainment',
      amount: 95.99,
      percentage: 8,
      color: const Color(0xFFFF80AB),
      icon: Icons.movie_rounded,
    ),
    SpendingCategory(
      label: 'Utilities',
      amount: 178.00,
      percentage: 15,
      color: const Color(0xFF4FC3F7),
      icon: Icons.bolt_rounded,
    ),
    SpendingCategory(
      label: 'Others',
      amount: 200.00,
      percentage: 17,
      color: AppTheme.accentSecondary,
      icon: Icons.more_horiz_rounded,
    ),
  ];

  static final List<SavingsGoal> savingsGoals = [
    SavingsGoal(
      id: 'g1',
      title: 'New MacBook Pro',
      target: 3000.00,
      current: 1850.00,
      color: AppTheme.accentSecondary,
      icon: Icons.laptop_rounded,
      deadline: DateTime.now().add(const Duration(days: 60)),
    ),
    SavingsGoal(
      id: 'g2',
      title: 'Vacation Fund',
      target: 5000.00,
      current: 3200.00,
      color: AppTheme.accentTertiary,
      icon: Icons.flight_rounded,
      deadline: DateTime.now().add(const Duration(days: 90)),
    ),
    SavingsGoal(
      id: 'g3',
      title: 'Emergency Fund',
      target: 10000.00,
      current: 7500.00,
      color: AppTheme.accentPrimary,
      icon: Icons.shield_rounded,
      deadline: DateTime.now().add(const Duration(days: 180)),
    ),
  ];

  // Monthly spending data for chart
  static final List<double> monthlySpending = [
    1200, 980, 1450, 1100, 1600, 1380, 1250, 1700, 1420, 1850, 1300, 1184
  ];

  static final List<double> monthlyIncome = [
    4200, 4200, 4850, 4850, 5100, 4850, 5200, 5200, 5600, 5600, 5600, 5600
  ];

  static const List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
}
