import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/constants.dart';
import 'package:wrixl_frontend/utils/crypto_icons_flutter.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

class SmartMoneyFeedInsightCards extends StatefulWidget {
  const SmartMoneyFeedInsightCards({Key? key}) : super(key: key);

  @override
  State<SmartMoneyFeedInsightCards> createState() =>
      _SmartMoneyFeedInsightCardsState();
}

class _SmartMoneyFeedInsightCardsState
    extends State<SmartMoneyFeedInsightCards> {
  String activeFilter = 'all';
  String searchQuery = '';

  final List<String> filters = ['all', 'trend', 'confirmation', 'reversal'];

  final Map<String, IconData> insightFilterIcons = {
    'all': Icons.all_inclusive,
    'trend': Icons.trending_up,
    'confirmation': Icons.check_circle_outline,
    'reversal': Icons.change_circle_outlined,
  };

  final List<Color> brightNeonColors = [
    Colors.cyanAccent,
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.lightBlueAccent,
    Colors.deepPurpleAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
    Colors.redAccent,
    Colors.yellowAccent,
  ];
  int _colorIndex = 0;
  Color _getNextBrightColor() {
    final color = brightNeonColors[_colorIndex % brightNeonColors.length];
    _colorIndex++;
    return color;
  }

  late final List<Map<String, dynamic>> cardsData;

  @override
  void initState() {
    super.initState();
    cardsData = [
      {
        'title': 'Biggest Daily Accumulator',
        'stat': 'Wallet 0xFD... acquired 5M USDC',
        'priceSpots': {
          'FTC': [
            FlSpot(0, 1.21),
            FlSpot(1, 1.42),
            FlSpot(2, 6.98),
            FlSpot(3, 9.24),
            FlSpot(4, 5.56),
            FlSpot(5, 8.3),
            FlSpot(6, 9.82),
          ],
        },
        'wallets': ['0xABC...', '0xABC...'],
        'commentary':
            'Wallet showed strong stablecoin positioning in the last 24 hours.',
        'totalValue': 5000000.0,
        'confidence': 4,
        'trendType': 'New Trend',
        'tokens': ['FTC'],
        'chains': ['Ethereum', 'Ripple']
      },
      {
        'title': 'Smart Money Sector Shift',
        'stat': 'Shifted to L2s',
        'priceSpots': {
          'ETH': [
            FlSpot(0, 9.2),
            FlSpot(1, 3.0),
            FlSpot(2, 5.49),
            FlSpot(3, 1.6),
            FlSpot(4, 7.67),
            FlSpot(5, 2.14),
            FlSpot(6, 6.76),
          ],
        },
        'wallets': ['0xCDE...', '0xCDE...'],
        'commentary': 'Notable migration from ETH mainnet into L2 ecosystems.',
        'totalValue': 12800000.0,
        'confidence': 4,
        'trendType': 'Trend Reversal',
        'tokens': ['ETH'],
        'chains': ['Ethereum']
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredCards = cardsData.where((e) {
      final matchesFilter = activeFilter == 'all' ||
          e['trendType'].toString().toLowerCase().contains(activeFilter);
      final matchesSearch = searchQuery.isEmpty ||
          (e['title']?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false) ||
          (e['stat']?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false) ||
          (e['commentary']?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false);
      return matchesFilter && matchesSearch;
    }).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Insight Cards",
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppConstants.accentColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(
              width: 220,
              height: 36,
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search insights",
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: theme.colorScheme.surface.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppConstants.accentColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: ToggleFilterIconRowWidget(
            options: filters,
            optionIcons: insightFilterIcons,
            activeOption: activeFilter,
            onSelected: (selected) => setState(() => activeFilter = selected),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: filteredCards.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              separatorBuilder: (_, __) => const SizedBox(width: 40),
              itemBuilder: (context, index) {
                final data = filteredCards[index];
                return _buildInsightCard(context, data);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final trendType = data['trendType'] ?? 'trend';
    final int confidence = data['confidence'] ?? 3;
    final double totalValue = data['totalValue'] ?? 0;
    final List<String> tokens = List<String>.from(data['tokens'] ?? []);
    final List<String> chains = List<String>.from(data['chains'] ?? []);
    final Map<String, List<FlSpot>> priceSpotsMap = {};

    if (data['priceSpots'] is Map) {
      (data['priceSpots'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List) {
          priceSpotsMap[key] = value
              .map<FlSpot>((e) =>
                  e is FlSpot ? e : FlSpot(e[0].toDouble(), e[1].toDouble()))
              .toList();
        }
      });
    }

    final List<LineChartBarData> chartLines = [];
    priceSpotsMap.forEach((token, spots) {
      chartLines.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        color: _getNextBrightColor(),
        barWidth: 2.8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
    });

    final isPositive = priceSpotsMap.values.expand((e) => e).isNotEmpty
        ? priceSpotsMap.values.expand((e) => e).last.y >=
            priceSpotsMap.values.expand((e) => e).first.y
        : true;

    return GestureDetector(
      onTap: () => _showDetailModal(context, data),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface.withOpacity(0.95),
          border: Border.all(
              color:
                  isPositive ? AppConstants.neonGreen : AppConstants.neonRed),
          boxShadow: [
            BoxShadow(
              color:
                  (isPositive ? AppConstants.neonGreen : AppConstants.neonRed)
                      .withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title Row
            Row(
              children: [
                Icon(
                  trendType.contains('confirmation')
                      ? Icons.check_circle_outline
                      : trendType.contains('reversal')
                          ? Icons.change_circle_outlined
                          : Icons.trending_up,
                  size: 16,
                  color: AppConstants.accentColor,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    data['title'],
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppConstants.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(trendType,
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary, fontSize: 10)),
                )
              ],
            ),

            const SizedBox(height: 4),
            Text(
              data['stat'],
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppConstants.neonGreen,
              ),
            ),
            Text(
              'Total ${_formatCurrency(totalValue)}',
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: priceSpotsMap.isNotEmpty
                  ? LineChart(LineChartData(
                      lineTouchData: const LineTouchData(enabled: false),
                      lineBarsData: chartLines,
                      betweenBarsData: chartLines.length > 1
                          ? [
                              BetweenBarsData(
                                  fromIndex: 0,
                                  toIndex: 1,
                                  color: AppConstants.accentColor
                                      .withOpacity(0.15))
                            ]
                          : [],
                      titlesData: FlTitlesData(show: false),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ))
                  : const Center(child: Text("Loading chart...")),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ...tokens.map((token) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: CryptoIconUtils.getIcon(token, size: 16),
                    )),
                const Spacer(),
                ...chains.map((chain) => Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: theme.colorScheme.surface,
                        child: Text(
                          chain.substring(0, 3).toUpperCase(),
                          style: theme.textTheme.labelLarge?.copyWith(
                              fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                IconButton(
                  icon: const Icon(Icons.star_border, size: 18),
                  color: AppConstants.neonGreen,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Added '${data['title']}' to Watchlist")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(1)}B';
    if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(1)}M';
    if (value >= 1e3) return '\$${(value / 1e3).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(2)}';
  }

  void _showDetailModal(BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(data['title'], style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['stat'], style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            const Text("Top Wallets Involved:"),
            ...List.generate((data['wallets'] ?? []).length,
                (i) => Text("• ${data['wallets'][i]}")),
            const SizedBox(height: 10),
            const Text("Recent Actions:"),
            Text(data['commentary'] ?? "No AI commentary available."),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.copy),
            label: const Text("Track Wallets"),
          ),
        ],
      ),
    );
  }
}
