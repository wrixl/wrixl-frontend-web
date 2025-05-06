 // import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:html' as html;

class PaymentService {
  /// Opens the checkout URL.
  /// For web, it opens the URL in a new browser tab.
  /// For non-web platforms, you can implement a WebView-based approach.
  static Widget buildCheckoutWidget(String checkoutUrl) {
    if (kIsWeb) {
      // Open the checkout URL in a new tab.
      html.window.open(checkoutUrl, '_blank');
      return const Center(child: Text('Redirecting to payment page...'));
    } else {
      // TODO: Implement WebView for mobile/desktop platforms if needed.
      return const Center(
        child: Text('WebView for payment is not implemented for this platform.'),
      );
    }
  }
}
