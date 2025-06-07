// lib\widgets\screen_specific_widgets\current_widgets\strategies\mint_strategy_actions.dart

import 'package:flutter/material.dart';

class MintStrategyActions extends StatefulWidget {
  const MintStrategyActions({super.key});

  @override
  State<MintStrategyActions> createState() => _MintStrategyActionsState();
}

class _MintStrategyActionsState extends State<MintStrategyActions> {
  bool isMobile = false;
  bool showDetails = false;
  bool isMinting = false;

  void simulateStrategy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Simulating strategy... (mock)")),
    );
  }

  void bookmarkStrategy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Strategy bookmarked for later.")),
    );
  }

  void mintStrategy() async {
    setState(() {
      isMinting = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      isMinting = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Strategy minted successfully! 🎉")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    isMobile = MediaQuery.of(context).size.width < 600;

    final actionButtons = [
      ElevatedButton.icon(
        icon: const Icon(Icons.auto_graph),
        onPressed: simulateStrategy,
        label: const Text("Simulate"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary),
          elevation: 0,
        ),
      ),
      OutlinedButton.icon(
        icon: const Icon(Icons.bookmark_border),
        onPressed: bookmarkStrategy,
        label: const Text("Bookmark"),
      ),
      ElevatedButton.icon(
        icon: const Icon(Icons.local_fire_department),
        onPressed: isMinting ? null : mintStrategy,
        label:
            isMinting ? const Text("Minting...") : const Text("Mint Strategy"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
        ),
      ),
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mint Strategy",
                    style: Theme.of(context).textTheme.titleMedium),
                const Icon(Icons.local_fire_department,
                    color: Colors.deepPurpleAccent),
              ],
            ),
            const SizedBox(height: 16),
            isMobile
                ? Column(
                    children: actionButtons
                        .map((btn) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: btn,
                            ))
                        .toList(),
                  )
                : Row(
                    children: actionButtons
                        .map((btn) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: btn,
                            ))
                        .toList(),
                  ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() => showDetails = !showDetails),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 8),
                  Text(
                    showDetails ? "Hide mint details" : "Show mint details",
                    style: TextStyle(color: scheme.primary),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: showDetails
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("• WRX Cost: 180 WRX",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text("• Gas Estimate: ~0.002 ETH"),
                    Text("• Chain: Base Mainnet"),
                    Text("• Portfolio Type: ERC-721 NFT"),
                    SizedBox(height: 8),
                    Text(
                      "AI Comment: Strategy shows strong Sharpe, balanced risk, and unique diversification profile.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
