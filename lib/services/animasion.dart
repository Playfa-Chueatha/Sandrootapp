import 'package:flutter/material.dart';

class AnimatedCircleTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const AnimatedCircleTab({
    required this.text,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:  Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      constraints:  BoxConstraints(
        minWidth: 100,
        minHeight: 50,
      ),
      alignment: Alignment.center,
      padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: AnimatedDefaultTextStyle(
        duration:  Duration(milliseconds: 300),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isSelected ? 20 : 16,
          color: isSelected ? Color(0xFF355E3B) : Colors.grey,
        ),
        child: Text(text),
      ),
    );
  }
}
