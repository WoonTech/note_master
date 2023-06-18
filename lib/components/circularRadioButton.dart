import 'package:flutter/material.dart';

class CircularRadioButton extends StatefulWidget {
  final int value;
  final int selectedValue;
  final ValueChanged<int> onChanged;
  final Color color;

  const CircularRadioButton({
    Key? key,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
    required this.color,
  }) : super(key: key);

  @override
  _CircularRadioButtonState createState() => _CircularRadioButtonState();
}

class _CircularRadioButtonState extends State<CircularRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(widget.value);
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
        child: widget.value == widget.selectedValue
            ? Center(
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
