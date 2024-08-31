import 'dart:ui';

extension HexColor on Color {
  String _generateAlpha({required int alpha, required bool withAlpha}) {
    if (withAlpha) {
      return alpha.toRadixString(16).padLeft(2, '0');
    } else {
      return '';
    }
  }

  String toHex({bool leadingHashSign = false, bool withAlpha = false}) =>
      '${leadingHashSign ? '#' : ''}'
          '${_generateAlpha(alpha: alpha, withAlpha: withAlpha)}'
          '${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
}

/// Construct a color from a hex code string, of the format #RRGGBB.
extension ColorHex on String {
  Color hexToColor() {
    return Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
  }
}