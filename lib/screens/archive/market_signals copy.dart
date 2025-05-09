// lib\screens\dashboard\market_signals.dart

import 'package:flutter/material.dart';
import '../../models/market_signal_model.dart';
import '../../utils/constants.dart';

class MarketSignalsWidget extends StatelessWidget {
  MarketSignalsWidget({Key? key}) : super(key: key);

  // Dummy signals data.
  final List<MarketSignal> dummySignals = [
    MarketSignal(
      id: 1,
      signalType: 'Exchange Inflow',
      detail: '20,000 ETH deposited to Binance',
      severity: 'high',
      detectedAt: DateTime(2023, 4, 1, 14, 0),
    ),
    MarketSignal(
      id: 2,
      signalType: 'Liquidity Change',
      detail: 'Significant liquidity removed from DeFi pool',
      severity: 'medium',
      detectedAt: DateTime(2023, 4, 1, 15, 30),
    ),
  ];

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high':
        return AppConstants.neonMagenta;
      case 'medium':
        return AppConstants.accentColor; // Electric Blue
      case 'low':
        return AppConstants.neonGreen;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: dummySignals.length,
      itemBuilder: (context, index) {
        final signal = dummySignals[index];
        return Card(
          color: AppConstants.primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppConstants.accentColor.withOpacity(0.5)),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Icon(
              Icons.warning,
              color: _getSeverityColor(signal.severity),
              size: 30,
            ),
            title: Text(
              signal.signalType,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 18,
                color: AppConstants.textColor,
              ),
            ),
            subtitle: Text(
              '${signal.detail}\nAt: ${signal.detectedAt.toLocal().toString().substring(0, 16)}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: AppConstants.textColor,
              ),
            ),
            isThreeLine: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Text(
                    signal.signalType,
                    style: const TextStyle(
                        color: AppConstants.textColor, fontFamily: 'Rajdhani'),
                  ),
                  content: Text(
                    signal.detail ?? 'No additional details available.',
                    style: const TextStyle(
                        color: AppConstants.textColor, fontFamily: 'Roboto'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close',
                          style: TextStyle(color: AppConstants.accentColor)),
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
