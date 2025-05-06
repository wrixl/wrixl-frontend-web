 // lib\screens\dashboard\mirror_insights.dart

import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MirrorInsights extends StatelessWidget {
  const MirrorInsights({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> insights = const [
    {
      'token': 'UNI',
      'action': 'Buy',
      'walletLabel': 'Whale A',
      'rationale': 'High confidence due to historical performance',
      'confidence': 'high',
    },
    {
      'token': 'SUSHI',
      'action': 'Sell',
      'walletLabel': 'Trader B',
      'rationale': 'Noticed profit booking trend',
      'confidence': 'medium',
    },
  ];

  Color _getConfidenceColor(String confidence) {
    switch (confidence) {
      case 'high':
        return AppConstants.neonGreen;
      case 'medium':
        return AppConstants.accentColor;
      case 'low':
        return AppConstants.neonMagenta;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: insights.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final insight = insights[index];
        return Card(
          color: AppConstants.primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppConstants.accentColor.withOpacity(0.5)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  title: Text(
                    '${insight['token']} ${insight['action']} Insight',
                    style: const TextStyle(color: AppConstants.textColor, fontFamily: 'Rajdhani'),
                  ),
                  content: Text(
                    insight['rationale'],
                    style: const TextStyle(color: AppConstants.textColor, fontFamily: 'Roboto'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close', style: TextStyle(color: AppConstants.accentColor)),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    insight['token'],
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 20,
                      color: AppConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insight['action'],
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: AppConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insight['walletLabel'],
                    style: const TextStyle(color: AppConstants.textColor),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.circle,
                    color: _getConfidenceColor(insight['confidence']),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
