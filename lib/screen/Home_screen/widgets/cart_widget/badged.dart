import 'package:flutter/material.dart';

import '../../../../config/app_dimens.dart';

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
            right: AppDimens.dimens_8,
            top: AppDimens.dimens_8,
            child: Container(
              padding: const EdgeInsets.all(AppDimens.dimens_2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.dimens_10),
                  color: color),
              constraints: const BoxConstraints(
                  minHeight: AppDimens.dimens_16,
                  minWidth: AppDimens.dimens_16),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: AppDimens.dimens_10),
              ),
            ))
      ],
    );
  }
}
