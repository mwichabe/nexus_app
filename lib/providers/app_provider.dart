import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../models/dummy_data.dart';
import '../theme/app_theme.dart';

class AppProvider extends ChangeNotifier {
  final List<Transaction> _transactions = List.from(DummyData.transactions);
  final List<BankCard> _cards = List.from(DummyData.cards);
  final List<Contact> _contacts = List.from(DummyData.contacts);
  int _selectedCardIndex = 0;
  bool _balanceVisible = true;
  int _selectedNavIndex = 0;

  List<Transaction> get transactions => _transactions;
  List<BankCard> get cards => _cards;
  List<Contact> get contacts => _contacts;
  BankCard get selectedCard => _cards[_selectedCardIndex];
  int get selectedCardIndex => _selectedCardIndex;
  bool get balanceVisible => _balanceVisible;
  int get selectedNavIndex => _selectedNavIndex;

  double get totalBalance => _cards.fold(0, (sum, card) => sum + card.balance);
  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.credit)
      .fold(0, (sum, t) => sum + t.amount);
  double get totalExpenses => _transactions
      .where((t) => t.type == TransactionType.debit)
      .fold(0, (sum, t) => sum + t.amount);

  List<Transaction> get recentTransactions => _transactions.take(5).toList();

  void selectCard(int index) {
    _selectedCardIndex = index;
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _balanceVisible = !_balanceVisible;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  Future<bool> deposit({
    required double amount,
    required String description,
    required String cardId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final cardIndex = _cards.indexWhere((c) => c.id == cardId);
    if (cardIndex == -1) return false;

    final updatedCard = BankCard(
      id: _cards[cardIndex].id,
      cardNumber: _cards[cardIndex].cardNumber,
      cardHolder: _cards[cardIndex].cardHolder,
      expiryDate: _cards[cardIndex].expiryDate,
      cvv: _cards[cardIndex].cvv,
      bankName: _cards[cardIndex].bankName,
      balance: _cards[cardIndex].balance + amount,
      type: _cards[cardIndex].type,
      gradientColors: _cards[cardIndex].gradientColors,
    );

    _cards[cardIndex] = updatedCard;

    _transactions.insert(
      0,
      Transaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Cash Deposit',
        subtitle: description.isNotEmpty ? description : 'Bank Deposit',
        amount: amount,
        type: TransactionType.credit,
        category: TransactionCategory.deposit,
        date: DateTime.now(),
      ),
    );

    notifyListeners();
    return true;
  }

  Future<bool> withdraw({
    required double amount,
    required String description,
    required String cardId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final cardIndex = _cards.indexWhere((c) => c.id == cardId);
    if (cardIndex == -1) return false;

    if (_cards[cardIndex].balance < amount) return false;

    final updatedCard = BankCard(
      id: _cards[cardIndex].id,
      cardNumber: _cards[cardIndex].cardNumber,
      cardHolder: _cards[cardIndex].cardHolder,
      expiryDate: _cards[cardIndex].expiryDate,
      cvv: _cards[cardIndex].cvv,
      bankName: _cards[cardIndex].bankName,
      balance: _cards[cardIndex].balance - amount,
      type: _cards[cardIndex].type,
      gradientColors: _cards[cardIndex].gradientColors,
    );

    _cards[cardIndex] = updatedCard;

    _transactions.insert(
      0,
      Transaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Cash Withdrawal',
        subtitle: description.isNotEmpty ? description : 'ATM Withdrawal',
        amount: amount,
        type: TransactionType.debit,
        category: TransactionCategory.withdrawal,
        date: DateTime.now(),
      ),
    );

    notifyListeners();
    return true;
  }

  Future<bool> transfer({
    required double amount,
    required Contact recipient,
    required String note,
    required String cardId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final cardIndex = _cards.indexWhere((c) => c.id == cardId);
    if (cardIndex == -1) return false;
    if (_cards[cardIndex].balance < amount) return false;

    final updatedCard = BankCard(
      id: _cards[cardIndex].id,
      cardNumber: _cards[cardIndex].cardNumber,
      cardHolder: _cards[cardIndex].cardHolder,
      expiryDate: _cards[cardIndex].expiryDate,
      cvv: _cards[cardIndex].cvv,
      bankName: _cards[cardIndex].bankName,
      balance: _cards[cardIndex].balance - amount,
      type: _cards[cardIndex].type,
      gradientColors: _cards[cardIndex].gradientColors,
    );

    _cards[cardIndex] = updatedCard;

    _transactions.insert(
      0,
      Transaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Transfer to ${recipient.name}',
        subtitle: note.isNotEmpty ? note : 'Personal Transfer',
        amount: amount,
        type: TransactionType.debit,
        category: TransactionCategory.transfer,
        date: DateTime.now(),
        note: note,
      ),
    );

    notifyListeners();
    return true;
  }

  Future<bool> payBill({
    required double amount,
    required String biller,
    required String accountRef,
    required String cardId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final cardIndex = _cards.indexWhere((c) => c.id == cardId);
    if (cardIndex == -1) return false;
    if (_cards[cardIndex].balance < amount) return false;

    final updatedCard = BankCard(
      id: _cards[cardIndex].id,
      cardNumber: _cards[cardIndex].cardNumber,
      cardHolder: _cards[cardIndex].cardHolder,
      expiryDate: _cards[cardIndex].expiryDate,
      cvv: _cards[cardIndex].cvv,
      bankName: _cards[cardIndex].bankName,
      balance: _cards[cardIndex].balance - amount,
      type: _cards[cardIndex].type,
      gradientColors: _cards[cardIndex].gradientColors,
    );

    _cards[cardIndex] = updatedCard;

    _transactions.insert(
      0,
      Transaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: biller,
        subtitle: 'Bill Payment • $accountRef',
        amount: amount,
        type: TransactionType.debit,
        category: TransactionCategory.utilities,
        date: DateTime.now(),
      ),
    );

    notifyListeners();
    return true;
  }
}
