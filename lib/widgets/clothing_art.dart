import 'package:flutter/material.dart';


import '../data/models.dart';
import '../theme/app_colors.dart';


/// Ilustrasi pakaian sederhana (pengganti foto sampai fitur kamera jadi).
class ClothingArt extends StatelessWidget {
  const ClothingArt({
    super.key,
    required this.category,
    required this.color,
    this.size = 64,
  });


  final ClothingCategory category;
  final Color color;
  final double size;


  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _ClothingPainter(category, color)),
  );
}


/// Outfit disusun vertikal: topi, atasan/outer, bawahan, sepatu.
class OutfitArt extends StatelessWidget {
  const OutfitArt({super.key, required this.items, this.height = 160});


  final List<ClothingItem> items;
  final double height;


  ClothingItem? _find(ClothingCategory c) =>
      items.where((i) => i.category == c).firstOrNull;


  @override
  Widget build(BuildContext context) {
    final hat = _find(ClothingCategory.hat);
    final top = _find(ClothingCategory.outer) ?? _find(ClothingCategory.top);
    final bottom = _find(ClothingCategory.bottom);
    final shoes = _find(ClothingCategory.shoes);
    final h = height;
    return SizedBox(
      height: h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hat != null)
            ClothingArt(category: hat.category, color: hat.color, size: h * .2),
          if (top != null)
            ClothingArt(
              category: top.category,
              color: top.color,
              size: h * .32,
            ),
          if (bottom != null)
            ClothingArt(
              category: bottom.category,
              color: bottom.color,
              size: h * .32,
            ),
          if (shoes != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClothingArt(
                  category: shoes.category,
                  color: shoes.color,
                  size: h * .14,
                ),
                ClothingArt(
                  category: shoes.category,
                  color: shoes.color,
                  size: h * .14,
                ),
              ],
            ),
        ],
      ),
    );
  }
}


/// Kartu kertas krem tempat ilustrasi pakaian, dipakai di grid dan detail.
class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.child,
    this.selected = false,
    this.dimmed = false,
    this.badge,
    this.radius = 16,
    this.onTap,
  });


  final Widget child;
  final bool selected;
  final bool dimmed;
  final Widget? badge;
  final double radius;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: dimmed ? const Color(0xFF7A7770) : AppColors.paper,
              borderRadius: BorderRadius.circular(radius),
              border: selected
                  ? Border.all(color: AppColors.gold, width: 2.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Opacity(opacity: dimmed ? .55 : 1, child: child),
          ),
          if (selected)
            const Positioned(
              top: 6,
              right: 6,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: AppColors.gold,
                child: Icon(Icons.check, size: 14, color: AppColors.bgBase),
              ),
            ),
          if (badge != null) Positioned(left: 6, bottom: 6, child: badge!),
        ],
      ),
    );
  }
}


class _ClothingPainter extends CustomPainter {
  _ClothingPainter(this.category, this.color);


  final ClothingCategory category;
  final Color color;


  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width, size.height);
    final fill = Paint()..color = color;
    final line = Paint()
      ..color = Color.lerp(color, Colors.black, .35)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = .02
      ..strokeJoin = StrokeJoin.round;


    final path = Path();
    switch (category) {
      case ClothingCategory.top:
        path
          ..moveTo(.32, .18)
          ..lineTo(.42, .14)
          ..quadraticBezierTo(.5, .24, .58, .14)
          ..lineTo(.68, .18)
          ..lineTo(.9, .34)
          ..lineTo(.8, .46)
          ..lineTo(.72, .4)
          ..lineTo(.72, .86)
          ..lineTo(.28, .86)
          ..lineTo(.28, .4)
          ..lineTo(.2, .46)
          ..lineTo(.1, .34)
          ..close();
      case ClothingCategory.outer:
        path
          ..moveTo(.32, .14)
          ..lineTo(.42, .1)
          ..lineTo(.5, .2)
          ..lineTo(.58, .1)
          ..lineTo(.68, .14)
          ..lineTo(.84, .28)
          ..lineTo(.9, .84)
          ..lineTo(.78, .86)
          ..lineTo(.72, .42)
          ..lineTo(.72, .9)
          ..lineTo(.28, .9)
          ..lineTo(.28, .42)
          ..lineTo(.22, .86)
          ..lineTo(.1, .84)
          ..lineTo(.16, .28)
          ..close();
      case ClothingCategory.bottom:
        path
          ..moveTo(.3, .08)
          ..lineTo(.7, .08)
          ..lineTo(.75, .92)
          ..lineTo(.56, .92)
          ..lineTo(.5, .34)
          ..lineTo(.44, .92)
          ..lineTo(.25, .92)
          ..close();
      case ClothingCategory.shoes:
        path
          ..moveTo(.1, .7)
          ..lineTo(.1, .42)
          ..quadraticBezierTo(.3, .38, .42, .46)
          ..lineTo(.62, .56)
          ..quadraticBezierTo(.9, .58, .92, .7)
          ..close();
      case ClothingCategory.hat:
        path
          ..moveTo(.16, .66)
          ..quadraticBezierTo(.18, .28, .5, .28)
          ..quadraticBezierTo(.8, .3, .8, .62)
          ..lineTo(.96, .66)
          ..quadraticBezierTo(.9, .74, .7, .72)
          ..close();
    }
    canvas
      ..drawPath(path, fill)
      ..drawPath(path, line);


    if (category == ClothingCategory.outer) {
      canvas.drawLine(const Offset(.5, .2), const Offset(.5, .9), line);
    }
    if (category == ClothingCategory.bottom) {
      canvas.drawLine(const Offset(.3, .16), const Offset(.7, .16), line);
    }
    if (category == ClothingCategory.shoes) {
      canvas.drawRect(
        const Rect.fromLTRB(.1, .7, .92, .78),
        Paint()..color = const Color(0xFFF7F5F0),
      );
    }
  }


  @override
  bool shouldRepaint(_ClothingPainter old) =>
      old.category != category || old.color != color;
}
