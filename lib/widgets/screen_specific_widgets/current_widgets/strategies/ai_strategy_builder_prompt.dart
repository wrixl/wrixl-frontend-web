// lib\widgets\screen_specific_widgets\current_widgets\strategies\ai_strategy_builder_prompt.dart

import 'package:flutter/material.dart';

class AIStrategyBuilderPrompt extends StatefulWidget {
  const AIStrategyBuilderPrompt({Key? key}) : super(key: key);

  @override
  State<AIStrategyBuilderPrompt> createState() => _AIStrategyBuilderPromptState();
}

class _AIStrategyBuilderPromptState extends State<AIStrategyBuilderPrompt> {
  final TextEditingController _controller = TextEditingController();
  String? generatedOutput;
  bool isLoading = false;

  final List<String> suggestions = [
    "Diversified ETH L2 strategy",
    "Conservative BTC-focused fund",
    "AI tokens with high volatility",
    "ETH staking yield with low gas fees"
  ];

  void _simulateAIResponse(String prompt) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      generatedOutput = "Strategy: $prompt\nTop Assets: ETH, ARB, OP\nProjected Sharpe: 1.5\nExpected CAGR: 36%";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
      elevation: 3,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("AI Strategy Builder",
                    style: theme.textTheme.titleMedium),
                const Icon(Icons.smart_toy_outlined, color: Colors.deepPurple),
              ],
            ),
            const SizedBox(height: 16),
            Text("Describe Your Strategy Idea",
                style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "e.g. High momentum DeFi strategy with medium volatility",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _simulateAIResponse(_controller.text),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: suggestions.map((s) {
                return ActionChip(
                  label: Text(s),
                  onPressed: () {
                    _controller.text = s;
                    _simulateAIResponse(s);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (generatedOutput != null && !isLoading)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(generatedOutput!,
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.analytics),
                          label: const Text("Simulate"),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.bar_chart),
                          label: const Text("Backtest"),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.bookmark_border),
                          label: const Text("Save"),
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
