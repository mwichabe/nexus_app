import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../screens/pin_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Profile header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0F0F1A), AppTheme.bgPrimary],
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: AppGradients.limeGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentPrimary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'AM',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.bgPrimary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.bgCard,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppTheme.bgPrimary, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        curve: Curves.easeOutBack,
                      )
                      .fadeIn(duration: 300.ms),

                  const SizedBox(height: 16),

                  const Text(
                    'Alex Morgan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ).animate(delay: 100.ms).fadeIn(),

                  const SizedBox(height: 4),

                  const Text(
                    'alex.morgan@nexus.bank',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ).animate(delay: 150.ms).fadeIn(),

                  const SizedBox(height: 16),

                  // Verified badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPrimary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.accentPrimary.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: AppTheme.accentPrimary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Verified Account',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentPrimary,
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn(),
                ],
              ),
            ),
          ),

          // Stats row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const _StatItem(label: 'Transactions', value: '124'),
                    _Divider(),
                    const _StatItem(label: 'Contacts', value: '28'),
                    _Divider(),
                    const _StatItem(label: 'Member Since', value: "2022"),
                  ],
                ),
              ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
            ),
          ),

          // Settings sections
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const _SectionTitle(title: 'Account'),
                  const _SettingsTile(
                    icon: Icons.person_rounded,
                    label: 'Personal Information',
                    color: AppTheme.accentSecondary,
                  ),
                  const _SettingsTile(
                    icon: Icons.security_rounded,
                    label: 'Security & Privacy',
                    color: AppTheme.accentTertiary,
                  ),
                  const _SettingsTile(
                    icon: Icons.notifications_rounded,
                    label: 'Notifications',
                    color: AppTheme.accentWarn,
                    trailing: _Badge(label: '3'),
                  ),
                  const _SettingsTile(
                    icon: Icons.language_rounded,
                    label: 'Language & Region',
                    color: Color(0xFF4FC3F7),
                    trailing: Text(
                      'English',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Finance'),
                  const _SettingsTile(
                    icon: Icons.account_balance_rounded,
                    label: 'Linked Bank Accounts',
                    color: AppTheme.accentPrimary,
                  ),
                  const _SettingsTile(
                    icon: Icons.credit_card_rounded,
                    label: 'Manage Cards',
                    color: Color(0xFFFF80AB),
                  ),
                  const _SettingsTile(
                    icon: Icons.receipt_long_rounded,
                    label: 'Transaction Limits',
                    color: AppTheme.accentWarn,
                  ),
                  const _SettingsTile(
                    icon: Icons.trending_up_rounded,
                    label: 'Investment Portfolio',
                    color: Color(0xFF69F0AE),
                  ),

                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Support'),
                  const _SettingsTile(
                    icon: Icons.help_rounded,
                    label: 'Help Center',
                    color: AppTheme.accentSecondary,
                  ),
                  const _SettingsTile(
                    icon: Icons.chat_rounded,
                    label: 'Live Chat Support',
                    color: AppTheme.accentTertiary,
                  ),
                  const _SettingsTile(
                    icon: Icons.star_rounded,
                    label: 'Rate Nexus',
                    color: Color(0xFFFFB836),
                  ),

                  const SizedBox(height: 24),

                  // Logout button
                  GestureDetector(
                    onTap: () {
                      context.read<AuthProvider>().logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const PinScreen()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.accentRed.withOpacity(0.2)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded,
                              color: AppTheme.accentRed, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Center(
                    child: Text(
                      'Nexus v1.0.0 • Secured by 256-bit Encryption',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: AppTheme.borderColor,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.textMuted,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 19, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppTheme.textMuted,
                ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: AppTheme.accentRed,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
