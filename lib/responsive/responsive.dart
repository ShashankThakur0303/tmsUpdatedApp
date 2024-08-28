import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class ReponsiveWidget extends StatelessWidget {
  final Widget child;

  const ReponsiveWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      return Container(
        width: Constraints.maxHeight,
        height: Constraints.maxHeight,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: Constraints.maxHeight,
              minWidth: Constraints.maxWidth,
            ),
            child: IntrinsicHeight(child: child),
          ),
        ),
      );
    });
  }
}
