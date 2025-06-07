// lib\widgets\screen_specific_widgets\current_widgets\strategies\smart_money_ticker.dart

import 'dart:async';
import 'package:flutter/material.dart';

class SmartMoneyTicker extends StatefulWidget {
  const SmartMoneyTicker({super.key});

  @override
  State<SmartMoneyTicker> createState() => _SmartMoneyTickerState();
}

class _SmartMoneyTickerState extends State<SmartMoneyTicker> {
  final List<SmartMoneyAction> _actions = [];
  late Timer _mockDataTimer;

  @override
  void initState() {
    super.initState();
    _mockDataTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _actions.insert(0, SmartMoneyAction.generate());
        if (_actions.length > 20) _actions.removeLast();
      });
    });
  }

  @override
  void dispose() {
    _mockDataTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Smart Money Ticker", style: theme.textTheme.titleMedium),
                const Icon(Icons.bolt_rounded, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 16),
            if (_actions.isEmpty)
              const Center(
                child: Text(
                  'No smart money activity yet... 💤',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              )
            else
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _actions.length,
                  itemBuilder: (context, index) {
                    return SmartMoneyCard(action: _actions[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SmartMoneyAction {
  final String walletName;
  final String token;
  final double amount;
  final DateTime timestamp;
  final ActionType actionType;
  final String fit;

  SmartMoneyAction({
    required this.walletName,
    required this.token,
    required this.amount,
    required this.timestamp,
    required this.actionType,
    required this.fit,
  });

  static SmartMoneyAction generate() {
    final names = ['0xWhale23', 'DegenBot42', 'MetaVault', 'WrixlScanner'];
    final tokens = ['ETH', 'USDC', 'SOL', 'OP'];
    final types = ActionType.values;
    final fits = ['High Fit', 'Tracking', 'Outlier'];

    names.shuffle();
    tokens.shuffle();
    types.shuffle();
    fits.shuffle();

    return SmartMoneyAction(
      walletName: names.first,
      token: tokens.first,
      amount: (1000 + (10000 * (0.1 + 0.9 * (1.0 - 0.5)))).roundToDouble(),
      timestamp: DateTime.now(),
      actionType: types.first,
      fit: fits.first,
    );
  }
}

enum ActionType { buy, sell, rotate }

class SmartMoneyCard extends StatelessWidget {
  final SmartMoneyAction action;

  const SmartMoneyCard({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final color = switch (action.actionType) {
      ActionType.buy => Colors.green.shade100,
      ActionType.sell => Colors.red.shade100,
      ActionType.rotate => Colors.orange.shade100,
    };

    final icon = switch (action.actionType) {
      ActionType.buy => '🟢',
      ActionType.sell => '🔴',
      ActionType.rotate => '🟡',
    };

    final theme = Theme.of(context);

    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$icon ${action.actionType.name.toUpperCase()} ${action.token}',
              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('${action.walletName} moved \$${action.amount.toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(label: Text(action.fit, style: theme.textTheme.labelSmall), backgroundColor: Colors.grey.shade200),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.all(6)),
                child: const Text('Mirror'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
