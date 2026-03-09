import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: const Text('QR Payment'),
        backgroundColor: AppTheme.bgPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.accentPrimary,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.accentPrimary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'My QR Code'),
            Tab(text: 'Scan QR'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyQR(context),
          _buildScanQR(context),
        ],
      ),
    );
  }

  Widget _buildMyQR(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Show this QR code to receive payment',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // QR code mock
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentPrimary.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // QR grid mock
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: _QRPainter(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Alex Morgan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A0A0F),
                    ),
                  ),
                  const Text(
                    '@alex.nexus',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A8AA8),
                    ),
                  ),
                ],
              ),
            ).animate().scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 32),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _QRAction(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  color: AppTheme.accentSecondary,
                ),
                SizedBox(width: 24),
                _QRAction(
                  icon: Icons.download_rounded,
                  label: 'Save',
                  color: AppTheme.accentTertiary,
                ),
                SizedBox(width: 24),
                _QRAction(
                  icon: Icons.copy_rounded,
                  label: 'Copy Link',
                  color: AppTheme.accentPrimary,
                ),
              ],
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildScanQR(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Point your camera at a QR code',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Camera viewfinder mock
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Stack(
                children: [
                  // Corner brackets
                  ..._buildCornerBrackets(),

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 80,
                          color: AppTheme.accentPrimary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Camera access required',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
          ),

          const SizedBox(height: 24),

          // Or enter manually
          const Row(
            children: [
              Expanded(child: Divider(color: AppTheme.borderColor)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppTheme.borderColor)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.borderAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Enter Payment Code Manually',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    return [
      const Positioned(
        top: 32,
        left: 32,
        child: _CornerBracket(rotated: false),
      ),
      Positioned(
        top: 32,
        right: 32,
        child: Transform(
          transform: Matrix4.rotationY(3.14),
          alignment: Alignment.center,
          child: const _CornerBracket(rotated: false),
        ),
      ),
      Positioned(
        bottom: 32,
        left: 32,
        child: Transform(
          transform: Matrix4.rotationX(3.14),
          alignment: Alignment.center,
          child: const _CornerBracket(rotated: false),
        ),
      ),
      Positioned(
        bottom: 32,
        right: 32,
        child: Transform(
          transform: Matrix4.rotationZ(3.14),
          alignment: Alignment.center,
          child: const _CornerBracket(rotated: false),
        ),
      ),
    ];
  }
}

class _CornerBracket extends StatelessWidget {
  final bool rotated;
  const _CornerBracket({required this.rotated});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: _BracketPainter(),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentPrimary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()
      ..color = const Color(0xFF0A0A0F)
      ..style = PaintingStyle.fill;

    // Draw QR code pattern (simplified visual)
    final cellSize = size.width / 10;

    // Pattern array for mock QR
    final pattern = [
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [1, 0, 0, 0, 0, 0, 1, 0, 1, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 1, 1, 0],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
      [1, 0, 1, 1, 0, 1, 1, 0, 0, 1],
      [0, 1, 0, 0, 1, 0, 1, 1, 0, 1],
    ];

    for (int row = 0; row < pattern.length; row++) {
      for (int col = 0; col < pattern[row].length; col++) {
        if (pattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * cellSize,
              row * cellSize,
              cellSize - 1,
              cellSize - 1,
            ),
            darkPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QRAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QRAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
