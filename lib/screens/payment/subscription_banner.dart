// lib\screens\payment\subscription_banner.dart 

import 'package:flutter/material.dart';
import 'subscription_page.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.accentColor,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Subscribe for premium insights - \$4.99/month',
              style: TextStyle(
                color: AppConstants.textColor,
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          CustomButton(
            text: 'Subscribe',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubscriptionPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
