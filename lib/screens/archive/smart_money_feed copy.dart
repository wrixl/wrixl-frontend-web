 // lib\screens\dashboard\smart_money_feed.dart

import 'package:flutter/material.dart';
import '../../models/smart_money_model.dart';
import '../../utils/constants.dart';

class SmartMoneyFeed extends StatelessWidget {
  SmartMoneyFeed({Key? key}) : super(key: key);

  final List<SmartMoneyTransaction> dummyTransactions = [
    SmartMoneyTransaction(
      token: 'UNI',
      action: 'Buy',
      amount: 100000,
      walletLabel: 'Whale A',
      timestamp: DateTime(2023, 4, 1, 12, 0),
      context: 'Accumulation for DeFi strategy',
    ),
    SmartMoneyTransaction(
      token: 'AAVE',
      action: 'Sell',
      amount: 50000,
      walletLabel: 'Fund X',
      timestamp: DateTime(2023, 4, 1, 13, 30),
      context: 'Profit booking',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyTransactions.length,
      itemBuilder: (context, index) {
        final tx = dummyTransactions[index];
        return Card(
          color: AppConstants.primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppConstants.accentColor.withOpacity(0.5)),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 8,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              '${tx.walletLabel} - ${tx.token} ${tx.action}',
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 18,
                color: AppConstants.textColor,
              ),
            ),
            subtitle: Text(
              'Amount: ${tx.amount}\nTime: ${tx.timestamp.toLocal().toString().substring(0, 16)}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                color: AppConstants.textColor,
              ),
            ),
            isThreeLine: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  title: Text(
                    '${tx.token} Transaction Details',
                    style: const TextStyle(fontFamily: 'Rajdhani', color: AppConstants.textColor),
                  ),
                  content: Text(
                    tx.context ?? 'No additional details',
                    style: const TextStyle(fontFamily: 'Roboto', color: AppConstants.textColor),
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
          ),
        );
      },
    );
  }
}
