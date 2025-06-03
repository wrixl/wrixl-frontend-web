// lib\widgets\screen_specific_widgets\current_widgets\strategies\ai_strategy_builder_prompt.dart


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

    // Simulate AI response delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      generatedOutput = "Strategy: $prompt\nTop Assets: ETH, ARB, OP\nProjected Sharpe: 1.5\nExpected CAGR: 36%";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Describe Your Strategy Idea",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
          Card(
            margin: const EdgeInsets.only(top: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(generatedOutput!, style: const TextStyle(fontSize: 16)),
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
          ),
      ],
    );
  }
}
