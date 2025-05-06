// lib\utils\crypto_icons_flutter.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CryptoIconUtils {
  static Widget getIcon(String symbol, {double size = 20}) {
    final lowercase = symbol.toLowerCase();
    return SvgPicture.asset(
      'packages/crypto_icons_flutter/assets/color/$lowercase.svg',
      width: size,
      height: size,
      placeholderBuilder: (context) => const SizedBox(width: 20, height: 20),
    );
  }
}

