// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/capital_movement_map.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class FlowDetails {
  final double totalValue;
  final List<String> tokens;
  final int confidenceScore;
  final List<String> relatedWallets;

  const FlowDetails({
    required this.totalValue,
    required this.tokens,
    required this.confidenceScore,
    required this.relatedWallets,
  });
}

class SmartMoneyFeedFlowDiagram extends StatefulWidget {
  const SmartMoneyFeedFlowDiagram({Key? key}) : super(key: key);

  @override
  State<SmartMoneyFeedFlowDiagram> createState() => _SmartMoneyFeedFlowDiagramState();
}

class _SmartMoneyFeedFlowDiagramState extends State<SmartMoneyFeedFlowDiagram> {
  bool _viewByToken = false;
  String _hoveredCell = '';
  String _selectedDuration = "7d";

  final List<String> sources = ['Whale', 'Fund', 'Degen', 'Smart LP'];
  final List<String> destinations = ['DEXs', 'L2s', 'NFTs', 'LSDs'];

  static const Map<String, Map<String, FlowDetails>> _sectorData = {
    'Whale': { 'DEXs': FlowDetails(totalValue: 45, tokens: ['TOKEN_A', 'TOKEN_B'], confidenceScore: 5, relatedWallets: ['Wallet1', 'Wallet2']),
      'L2s': FlowDetails( totalValue: 12, tokens: ['TOKEN_C', 'TOKEN_D'], confidenceScore: 4, relatedWallets: ['Wallet3']),
      'NFTs': FlowDetails(
          totalValue: 2,
          tokens: ['NFT_A'],
          confidenceScore: 3,
          relatedWallets: ['Wallet4']),
      'LSDs': FlowDetails(
          totalValue: 6,
          tokens: ['TOKEN_E'],
          confidenceScore: 4,
          relatedWallets: ['Wallet5']),
    },
    'Fund': {
      'DEXs': FlowDetails(
          totalValue: 14,
          tokens: ['TOKEN_F'],
          confidenceScore: 4,
          relatedWallets: ['Wallet6', 'Wallet7']),
      'L2s': FlowDetails(
          totalValue: 28,
          tokens: ['TOKEN_G', 'TOKEN_H'],
          confidenceScore: 5,
          relatedWallets: ['Wallet8']),
      'NFTs': FlowDetails(
          totalValue: 0, tokens: [], confidenceScore: 0, relatedWallets: []),
      'LSDs': FlowDetails(
          totalValue: 9,
          tokens: ['TOKEN_I'],
          confidenceScore: 4,
          relatedWallets: ['Wallet9']),
    },
    'Degen': {
      'DEXs': FlowDetails(
          totalValue: 2,
          tokens: ['TOKEN_J'],
          confidenceScore: 3,
          relatedWallets: ['Wallet10']),
      'L2s': FlowDetails(
          totalValue: 4,
          tokens: ['TOKEN_K'],
          confidenceScore: 3,
          relatedWallets: ['Wallet11']),
      'NFTs': FlowDetails(
          totalValue: 10,
          tokens: ['NFT_B', 'NFT_C'],
          confidenceScore: 4,
          relatedWallets: ['Wallet12']),
      'LSDs': FlowDetails(
          totalValue: 3,
          tokens: ['TOKEN_L'],
          confidenceScore: 3,
          relatedWallets: ['Wallet13']),
    },
    'Smart LP': {
      'DEXs': FlowDetails(
          totalValue: 3,
          tokens: ['TOKEN_M'],
          confidenceScore: 4,
          relatedWallets: ['Wallet14']),
      'L2s': FlowDetails(
          totalValue: 7,
          tokens: ['TOKEN_N', 'TOKEN_O'],
          confidenceScore: 4,
          relatedWallets: ['Wallet15']),
      'NFTs': FlowDetails(
          totalValue: 1,
          tokens: ['NFT_D'],
          confidenceScore: 3,
          relatedWallets: ['Wallet16']),
      'LSDs': FlowDetails(
          totalValue: 5,
          tokens: ['TOKEN_P'],
          confidenceScore: 4,
          relatedWallets: ['Wallet17']),
    },
  };


  static const Map<String, Map<String, FlowDetails>> _tokenData = {
    // Token-specific data structure
    'Whale': {
      'DEXs': FlowDetails(totalValue: 30, tokens: ['TOKEN_A', 'TOKEN_B'], confidenceScore: 5, relatedWallets: ['Wallet1']),
      'L2s': FlowDetails(totalValue: 18, tokens: ['TOKEN_Y'], confidenceScore: 4, relatedWallets: ['Wallet3']),
      'NFTs': FlowDetails(totalValue: 4, tokens: ['NFT_A'], confidenceScore: 3, relatedWallets: ['Wallet4']),
      'LSDs': FlowDetails(totalValue: 6, tokens: ['TOKEN_E'], confidenceScore: 4, relatedWallets: ['Wallet5']),
    },
  };

  double get _maxVolume => (_viewByToken ? _tokenData : _sectorData)
      .values.expand((m) => m.values).map((d) => d.totalValue).fold(0.0, (a, b) => a > b ? a : b);

  double get _grandTotal => (_viewByToken ? _tokenData : _sectorData)
      .values.expand((m) => m.values).fold(0.0, (sum, d) => sum + d.totalValue);

  Color _flowColor(BuildContext context, double value) {
    final scheme = Theme.of(context).colorScheme;
    if (value > 30) return scheme.error;
    if (value > 10) return Colors.orange;
    if (value > 0) return Colors.green;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final data = _viewByToken ? _tokenData : _sectorData;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Capital Movement Map", style: theme.textTheme.titleMedium),
                Text("Total Flow: \$${_grandTotal.toStringAsFixed(1)}M", style: TextStyle(color: scheme.onSurface.withOpacity(0.7))),
              ],
            ),
            const SizedBox(height: 12),

            // Toggle Row
            Row(
              children: [
                ToggleFilterIconRowWidget(
                  options: ["Sector", "Token"],
                  optionIcons: {"Sector": Icons.grid_view, "Token": Icons.monetization_on},
                  activeOption: _viewByToken ? "Token" : "Sector",
                  onSelected: (sel) => setState(() => _viewByToken = sel == "Token"),
                ),
                const SizedBox(width: 16),
                ...['1d', '7d', '14d'].map((dur) {
                  final active = _selectedDuration == dur;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDuration = dur),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: active ? scheme.primary : scheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: active ? scheme.primary : Colors.transparent),
                        ),
                        child: Text(dur, style: TextStyle(fontSize: 12, color: active ? scheme.onPrimary : scheme.onSurface.withOpacity(0.7))),
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Matrix
            Column(
              children: [
                // Destinations as headers
                Row(
                  children: [
                    const SizedBox(width: 80),
                    ...destinations.map((d) => Expanded(
                          child: Center(child: Text(d, style: theme.textTheme.labelLarge)),
                        )),
                  ],
                ),
                const SizedBox(height: 8),

                // Source rows
                ...sources.map((src) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(width: 80, child: Text(src, style: theme.textTheme.labelLarge)),
                        ...destinations.map((dest) {
                          final details = data[src]?[dest];
                          final val = details?.totalValue ?? 0;
                          final barHeight = _maxVolume > 0 ? (val / _maxVolume) * 50.0 : 0.0;
                          final color = _flowColor(context, val);
                          final cellId = '$src-$dest';

                          return Expanded(
                            child: MouseRegion(
                              onEnter: (_) => setState(() => _hoveredCell = cellId),
                              onExit: (_) => setState(() => _hoveredCell = ''),
                              child: GestureDetector(
                                onTap: () => _showDetailModal(context, src, dest, details),
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: color, width: 1.2),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Text(
                                        val > 0 ? "\$${val.toStringAsFixed(1)}M" : "-",
                                        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
                                      ),
                                      Positioned(
                                        bottom: 2,
                                        child: Container(width: 6, height: barHeight, color: color),
                                      ),
                                      if (_hoveredCell == cellId)
                                        Positioned.fill(
                                          child: AnimatedOpacity(
                                            opacity: 1,
                                            duration: const Duration(milliseconds: 250),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: scheme.surface.withOpacity(0.95),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: scheme.primary),
                                              ),
                                              padding: const EdgeInsets.all(6),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Tokens: ${details?.tokens.join(', ') ?? 'N/A'}", style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
                                                  Text("Wallets: ${details?.relatedWallets.length ?? 0}", style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Tap a cell to inspect flow details by token, confidence, and wallet involvement.",
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }

  void _showDetailModal(BuildContext context, String src, String dest, FlowDetails? details) {
    if (details == null) return;
    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: "Flow Breakdown: $src → $dest",
        size: WidgetModalSize.medium,
        onClose: () => Navigator.pop(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("💰 Total Flow: \$${details.totalValue.toStringAsFixed(1)}M"),
            const SizedBox(height: 6),
            Text("🔗 Tokens: ${details.tokens.isNotEmpty ? details.tokens.join(', ') : 'N/A'}"),
            Text("🧠 Confidence: ${'★' * details.confidenceScore}${'☆' * (5 - details.confidenceScore)}"),
            Text("👛 Wallets: ${details.relatedWallets.isNotEmpty ? details.relatedWallets.join(', ') : 'N/A'}"),
          ],
        ),
      ),
    );
  }
}
