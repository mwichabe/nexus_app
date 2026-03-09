import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bank_card_widget.dart';
import '../../widgets/transaction_tile.dart';
import '../deposit_screen.dart';
import '../withdraw_screen.dart';
import '../transfer_screen.dart';
import '../pay_bills_screen.dart';
import '../qr_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final formatter = NumberFormat('#,##0.00', 'en_US');

        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(context, provider, formatter),
              ),

              // Balance Card
              SliverToBoxAdapter(
                child: _buildBalanceSection(context, provider, formatter),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: _buildQuickActions(context),
              ),

              // Cards Carousel
              SliverToBoxAdapter(
                child: _buildCardsSection(context, provider),
              ),

              // Recent Transactions
              SliverToBoxAdapter(
                child: _buildRecentTransactions(context, provider),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppProvider provider,
    NumberFormat formatter,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Collins Mwichabe',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          GestureDetector(
            onTap: () => _showNotifications(context),
            child: Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.textPrimary,
                    size: 20,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppGradients.limeGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'CM',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.bgPrimary,
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
    );
  }

  Widget _buildBalanceSection(
    BuildContext context,
    AppProvider provider,
    NumberFormat formatter,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.borderAccent),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentPrimary.withOpacity(0.05),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                GestureDetector(
                  onTap: () => provider.toggleBalanceVisibility(),
                  child: Icon(
                    provider.balanceVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: provider.balanceVisible
                  ? Row(
                      key: const ValueKey('visible'),
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          '\$',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatter.format(provider.totalBalance),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      key: ValueKey('hidden'),
                      '••••••••',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textSecondary,
                        letterSpacing: 8,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // Income/Expense row
            Row(
              children: [
                Expanded(
                  child: _buildBalanceStat(
                    label: 'Income',
                    amount: provider.balanceVisible
                        ? '\$${formatter.format(provider.totalIncome)}'
                        : '••••',
                    icon: Icons.arrow_downward_rounded,
                    color: AppTheme.accentTertiary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppTheme.borderColor,
                ),
                Expanded(
                  child: _buildBalanceStat(
                    label: 'Expenses',
                    amount: provider.balanceVisible
                        ? '\$${formatter.format(provider.totalExpenses)}'
                        : '••••',
                    icon: Icons.arrow_upward_rounded,
                    color: AppTheme.accentRed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: 100.ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildBalanceStat({
    required String label,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.add_rounded,
        label: 'Deposit',
        color: AppTheme.accentPrimary,
        onTap: () => _navigate(context, const DepositScreen()),
      ),
      _QuickAction(
        icon: Icons.remove_rounded,
        label: 'Withdraw',
        color: AppTheme.accentSecondary,
        onTap: () => _navigate(context, const WithdrawScreen()),
      ),
      _QuickAction(
        icon: Icons.send_rounded,
        label: 'Transfer',
        color: AppTheme.accentTertiary,
        onTap: () => _navigate(context, const TransferScreen()),
      ),
      _QuickAction(
        icon: Icons.receipt_rounded,
        label: 'Pay Bills',
        color: AppTheme.accentWarn,
        onTap: () => _navigate(context, const PayBillsScreen()),
      ),
      _QuickAction(
        icon: Icons.qr_code_rounded,
        label: 'QR Pay',
        color: const Color(0xFFFF80AB),
        onTap: () => _navigate(context, const QRScreen()),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 28, 24, 16),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(
          height: 88,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: actions.length,
            itemBuilder: (context, i) {
              final a = actions[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: a.onTap,
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: a.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: a.color.withOpacity(0.2),
                          ),
                        ),
                        child: Icon(a.icon, size: 24, color: a.color),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        a.label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: (i * 50).ms + 200.ms)
                    .fadeIn(duration: 300.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                    ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardsSection(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Cards',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () => provider.setNavIndex(1),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.accentPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.cards.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: BankCardWidget(
                  card: provider.cards[i],
                  isSelected: i == provider.selectedCardIndex,
                  onTap: () => provider.selectCard(i),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () => provider.setNavIndex(3),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppTheme.accentPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...provider.recentTransactions.asMap().entries.map(
              (entry) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: TransactionTile(transaction: entry.value)
                    .animate(delay: (entry.key * 60).ms + 100.ms)
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: 0.1, end: 0),
              ),
            ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _NotificationsSheet(),
    );
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _Notification(
        icon: Icons.check_circle_rounded,
        color: AppTheme.accentTertiary,
        title: 'Transfer Successful',
        body: 'You sent \$200 to Sarah Chen',
        time: '2 hours ago',
      ),
      _Notification(
        icon: Icons.account_balance_rounded,
        color: AppTheme.accentPrimary,
        title: 'Salary Received',
        body: '\$4,850 credited from TechCorp Inc.',
        time: 'Yesterday',
      ),
      _Notification(
        icon: Icons.security_rounded,
        color: AppTheme.accentSecondary,
        title: 'Security Alert',
        body: 'New device login detected',
        time: '3 days ago',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...notifications.map(
            (n) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: n.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(n.icon, size: 20, color: n.color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          n.body,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    n.time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Notification {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;

  _Notification({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
  });
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
