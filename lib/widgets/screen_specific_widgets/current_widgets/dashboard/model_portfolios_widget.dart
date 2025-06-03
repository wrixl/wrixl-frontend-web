// lib\widgets\screen_specific_widgets\current_widgets\model_portfolios_widget.dart

import 'package:flutter/material.dart';

class ModelPortfoliosWidget extends StatelessWidget {
  const ModelPortfoliosWidget({super.key});

  final List<_ModelPortfolio> portfolios = const [
    _ModelPortfolio(
      name: "Momentum Mix",
      returnPercent: 22.5,
      riskScore: 4,
      description:
          "Targets short-term token spikes with aggressive allocations.",
      constituents: ["ETH", "ARB", "PEPE", "RLB"],
    ),
    _ModelPortfolio(
      name: "Balanced Yield",
      returnPercent: 12.3,
      riskScore: 2,
      description: "Blends stablecoin staking with L2s and blue chips.",
      constituents: ["ETH", "USDC", "GMX", "MKR"],
    ),
    _ModelPortfolio(
      name: "High Conviction AI",
      returnPercent: 28.9,
      riskScore: 5,
      description:
          "AI-selected tokens with strong on-chain and sentiment signals.",
      constituents: ["WIF", "RLB", "ETH", "LDO"],
    ),
  ];

  void _showPortfolioModal(BuildContext context, _ModelPortfolio p) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        title: Text(p.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Risk Score: ${p.riskScore} / 5"),
            Text("Return: ${p.returnPercent.toStringAsFixed(1)}%"),
            const SizedBox(height: 8),
            Text("Constituents: ${p.constituents.join(', ')}"),
            const SizedBox(height: 8),
            Text("Strategy: ${p.description}",
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Model Portfolios",
                    style: Theme.of(context).textTheme.titleMedium),
                const Icon(Icons.auto_graph),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: portfolios.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final p = portfolios[i];
                  return Container(
                    width: 220,
                    decoration: BoxDecoration(
                      color: scheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: scheme.primary.withOpacity(0.3)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name,
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 6),
                        Text("Return: ${p.returnPercent.toStringAsFixed(1)}%",
                            style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.bold)),
                        Text(
                            "Risk: ${'⚠️' * p.riskScore}${'·' * (5 - p.riskScore)}",
                            style: const TextStyle(fontSize: 13)),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    _showPortfolioModal(context, p),
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6)),
                                child: const Text("Compare"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: scheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6)),
                                child: const Text("Copy"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ModelPortfolio {
  final String name;
  final double returnPercent;
  final int riskScore;
  final String description;
  final List<String> constituents;

  const _ModelPortfolio({
    required this.name,
    required this.returnPercent,
    required this.riskScore,
    required this.description,
    required this.constituents,
  });
}
