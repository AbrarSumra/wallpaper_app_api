import 'package:flutter/material.dart';

class EditedButton extends StatelessWidget {
  const EditedButton({
    super.key,
    required this.icon,
    required this.name,
    required this.heroTag,
    this.btnColor = Colors.white38,
    this.iconColor = Colors.black,
    this.onTap,
  });

  final IconData icon;
  final String name;
  final Color btnColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: heroTag,
          splashColor: Colors.blue,
          onPressed: onTap,
          backgroundColor: btnColor,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
