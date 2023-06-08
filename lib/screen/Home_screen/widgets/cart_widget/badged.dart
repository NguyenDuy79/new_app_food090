import 'package:flutter/material.dart';

class Badged extends StatelessWidget {
  const Badged(
      {required this.child,
      this.color = Colors.deepOrange,
      required this.value,
      super.key});
  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: color),
              constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ))
      ],
    );
  }
}
