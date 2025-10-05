import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_image.dart';

class GradientHeader extends StatelessWidget {
  final String? logoPath;
  final String title;
  final double height;
  final VoidCallback? onLogoTap;

  const GradientHeader({
    super.key,
    this.logoPath,
    required this.title,
    this.height = 120.0,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1E3A8A), // Dark blue left
            Color(0xFF10B981), // Green center
            Color(0xFF1E3A8A), // Dark blue right
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Color bands decoration
          _buildColorBands(),
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo section
                if (logoPath != null)
                  CircleAvatar(
                    radius: 32,
                    child: Image.asset(
                      logoPath ?? AppImage.imageLogo,
                      fit: BoxFit.cover,
                    ), // kích thước avatar
                  ),
                const SizedBox(width: 24),
                // Title section
                _buildTitle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorBands() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ColorBandsPainter(),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'serif',
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ColorBandsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define color bands
    final bands = [
    ];

    double currentY = 0;
    
    for (final band in bands) {
      final paint = Paint()
        ..color = band['color'] as Color
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        0,
        currentY,
        size.width,
        band['height'] as double,
      );

      canvas.drawRect(rect, paint);
      currentY += band['height'] as double;
    }

    // Add diagonal stripes for more visual interest
    final stripePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final startX = (size.width / 8) * i;
      final endX = startX + (size.width / 4);
      final startY = size.height * 0.2;
      final endY = size.height * 0.8;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        stripePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
