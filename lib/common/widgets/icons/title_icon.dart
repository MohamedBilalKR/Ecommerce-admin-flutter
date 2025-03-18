import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:flutter/material.dart';

class TitleIcon extends StatelessWidget {
  const TitleIcon({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: 30,
      height: 30,
      backgroundColor: color.withOpacity(0.1),
      padding: const EdgeInsets.all(4.0), // Add padding to center the icon
      child: Center(
        child: Icon(icon, color: color, size: 16), // Adjust the size as needed
      ),
    );
  }
}