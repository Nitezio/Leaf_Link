import 'package:flutter/material.dart';

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool center;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.maxWidth = 720,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth < maxWidth ? constraints.maxWidth : maxWidth;
        final sizedChild = SizedBox(width: width, child: child);
        if (!center) {
          return sizedChild;
        }
        return Align(alignment: Alignment.topCenter, child: sizedChild);
      },
    );
  }
}
