// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\wallet_strategy_card.dart


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WalletStrategyCard extends StatefulWidget {
  final String walletAlias;
  final String walletType;
  final double rankDelta;

  const WalletStrategyCard({
    Key? key,
    required this.walletAlias,
    required this.walletType,
    required this.rankDelta,
  }) : super(key: key);

  @override
  State<WalletStrategyCard> createState() => _WalletStrategyCardState();
}

class _WalletStrategyCardState extends State<WalletStrategyCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _holdings = [
    {
      'token': 'PYTH',
      'icon': Icons.api,
      'percent': 38.0,
      'action': 'Accumulating',
      'priceDelta': 12.4,
      'sector': 'Oracle'
    },
    {
      'token': 'JUP',
      'icon': Icons.explore,
      'percent': 17.5,
      'action': 'Trimming',
      'priceDelta': -3.2,
      'sector': 'DEX'
    },
    {
      'token': 'WIF',
      'icon': Icons.pets,
      'percent': 0.0,
      'action': 'Exited',
      'priceDelta': 0.0,
      'sector': 'Meme'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'Accumulating':
        return Colors.green;
      case 'Trimming':
        return Colors.red;
      case 'Holding':
        return Colors.orange;
      case 'Exited':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('@${widget.walletAlias}',
                    style: Theme.of(context).textTheme.titleLarge),
                Chip(
                  label: Text(widget.walletType),
                  avatar: Icon(Icons.star),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                )
              ],
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Holdings'),
                Tab(text: 'Trades'),
                Tab(text: 'Conviction'),
                Tab(text: 'Activity'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHoldingsTab(),
                  Center(child: Text('Trades tab coming soon...')),
                  Center(child: Text('Conviction heatmap coming soon...')),
                  Center(child: Text('Activity chart coming soon...')),
                ],
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.square),
                  label: const Text("Mirror"),
                  onPressed: () {},
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.visibility),
                  label: const Text("Watch Wallet"),
                  onPressed: () {},
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.sync_alt),
                  label: const Text("Simulate Drift"),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingsTab() {
    return ListView.builder(
      itemCount: _holdings.length,
      itemBuilder: (context, index) {
        final holding = _holdings[index];
        return ListTile(
          leading: Icon(holding['icon'], color: _getActionColor(holding['action'])),
          title: Text('${holding['token']} (${holding['sector']})'),
          subtitle: Text(
            '${holding['percent']}% — ${holding['action']}',
            style: TextStyle(color: _getActionColor(holding['action'])),
          ),
          trailing: Text(
            '${holding['priceDelta']}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: holding['priceDelta'] >= 0 ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}
