 // lib\screens\payment\subscription_page.dart

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:html' as html;
import '../../utils/constants.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      html.window.open('https://www.wrixl.com/checkout', '_blank');
      return Scaffold(
        backgroundColor: AppConstants.primaryColor,
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          title: const Text('Subscription Payment'),
        ),
        body: const Center(child: Text('Redirecting to payment page...')),
      );
    }
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        title: const Text('Subscription Payment'),
      ),
      body: const Center(
        child: Text('Payment WebView is not implemented for this platform.'),
      ),
    );
  }
}
