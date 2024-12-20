import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    super.key,
    this.width = 30,
    this.height = 40,
    required this.discount,
    this.percentageFontSize = 13,
  });
  final double width, height;
  final int discount;
  final double percentageFontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/Discount_tag.svg",
            fit: BoxFit.fill,
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          ),
          Text(
            "$discount%\noff",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: percentageFontSize,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
