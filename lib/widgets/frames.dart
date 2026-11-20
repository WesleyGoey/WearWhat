import 'package:flutter/material.dart';


import '../theme/app_colors.dart';
import '../theme/app_theme.dart';


/// Kotak dengan garis putus-putus (slot kosong, Nothing planned, oval selfie).
class DashedBox extends StatelessWidget {
  const DashedBox({
    super.key,
    required this.child,
    this.radius = 20,
    this.oval = false,
    this.color = AppColors.goldDark,
  });


  final Widget child;
  final double radius;
  final bool oval;
  final Color color;


  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _DashedPainter(radius: radius, oval: oval, color: color),
    child: child,
  );
}


/// Area kamera: latar coklat gelap, sudut bingkai emas, caption di bawah.
/// shortcut: belum pakai kamera sungguhan; tambahkan package camera di Sprint 3.
class CameraFrame extends StatelessWidget {
  const CameraFrame({
    super.key,
    required this.child,
    required this.caption,
    this.height = 330,
  });


  final Widget child;
  final String caption;
  final double height;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A3128), Color(0xFF1C1814)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _CornerPainter())),
          Center(child: child),
          Positioned(
            left: 0,
            right: 0,
            bottom: 28,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgBase,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(caption, style: AppText.body(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Baris kontrol kamera: galeri, shutter, putar kamera.
class CameraControls extends StatelessWidget {
  const CameraControls({
    super.key,
    required this.onShutter,
    required this.onGallery,
    required this.onFlip,
  });


  final VoidCallback onShutter;
  final VoidCallback onGallery;
  final VoidCallback onFlip;


  @override
  Widget build(BuildContext context) {
    Widget side(IconData icon, VoidCallback onTap, String tip) => IconButton(
      tooltip: tip,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.bgElevated,
        fixedSize: const Size(48, 48),
      ),
      icon: Icon(icon, color: AppColors.textPrimary, size: 22),
    );


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        side(Icons.photo_outlined, onGallery, 'Gallery'),
        GestureDetector(
          onTap: onShutter,
          child: Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2.5),
            ),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.paper,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        side(Icons.flip_camera_android_outlined, onFlip, 'Flip camera'),
      ],
    );
  }
}


class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const inset = 24.0, len = 28.0;
    final p = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final r = Rect.fromLTRB(
      inset,
      inset,
      size.width - inset,
      size.height - inset,
    );
    for (final (corner, dx, dy) in [
      (r.topLeft, 1.0, 1.0),
      (r.topRight, -1.0, 1.0),
      (r.bottomLeft, 1.0, -1.0),
      (r.bottomRight, -1.0, -1.0),
    ]) {
      canvas
        ..drawLine(corner, corner.translate(len * dx, 0), p)
        ..drawLine(corner, corner.translate(0, len * dy), p);
    }
  }


  @override
  bool shouldRepaint(_CornerPainter old) => false;
}


class _DashedPainter extends CustomPainter {
  _DashedPainter({
    required this.radius,
    required this.oval,
    required this.color,
  });


  final double radius;
  final bool oval;
  final Color color;


  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = oval
        ? (Path()..addOval(rect))
        : (Path()
            ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius))));
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 10) {
        canvas.drawPath(m.extractPath(d, d + 5), p);
      }
    }
  }


  @override
  bool shouldRepaint(_DashedPainter old) =>
      old.radius != radius || old.oval != oval || old.color != color;
}