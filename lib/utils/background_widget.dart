import 'dart:math';
import 'dart:ui' as ui;

import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: vg.loadPicture(SvgStringLoader(
            getSvgIcon(Theme.of(context).colorScheme.onInverseSurface)
        ), context),
        builder: (context, v) {
          if (v.hasData) {
            return FutureBuilder(
                future: v.data!.picture.toImage(42, 48),
                builder: (context, v) {
                  if (v.hasData) {
                    return CustomPaint(
                      painter: BackgroundPainter(v.data!),
                      child: Container(),
                    );
                  }

                  return const SizedBox.shrink();
                });
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

String getSvgIcon(Color color) {
  String hex = color.toHex(leadingHashSign: true);

  String svgIcon = '''
  <svg width="42" height="48" viewBox="0 0 42 48" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="1" width="38" height="46" rx="3" stroke="$hex" stroke-width="2"/>
  <rect x="3" y="1" width="32" height="46" rx="3" stroke="$hex" stroke-width="2"/>
  <path d="M9 7L25 7" stroke="$hex" stroke-width="2" stroke-linecap="round"/>
  <path d="M9 11L29 11" stroke="$hex" stroke-width="2" stroke-linecap="round"/>
  <rect y="15" width="3" height="2" rx="1" fill="$hex"/>
  <rect y="23" width="3" height="2" rx="1" fill="$hex"/>
  <rect y="31" width="3" height="2" rx="1" fill="$hex"/>
  </svg>
''';

  return svgIcon;
}

class BackgroundPainter extends CustomPainter {
  ui.Image image;

  BackgroundPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) { // icon size: 42, 48
    double spacingX = 70;
    double spacingY = 70;
    double dX = 0;
    double dY = 0;

    canvas.rotate(pi/6);

    for (int j = 0; j < size.height/42; j++) {
      for (int i = 0; i < size.width/48; i++) {
        canvas.drawImage(
          image,
          Offset(dX + (i*spacingX), dY + (j*spacingY)),
          Paint()
            ..color = Colors.blue
            ..strokeWidth = 10,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}