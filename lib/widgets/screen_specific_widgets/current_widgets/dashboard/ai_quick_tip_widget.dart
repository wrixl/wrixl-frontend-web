// lib/widgets/screen_specific_widgets/current_widgets/ai_quick_tip_widget.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class AIQuickTipWidget extends StatefulWidget {
  const AIQuickTipWidget({super.key});

  @override
  State<AIQuickTipWidget> createState() => _AIQuickTipWidgetState();
}

class _AIQuickTipModel {
  final IconData icon;
  final String emoji;
  final String category;
  final String summary;
  final String whyThisMatters;
  final String actionCTA;

  _AIQuickTipModel({
    required this.icon,
    required this.emoji,
    required this.category,
    required this.summary,
    required this.whyThisMatters,
    required this.actionCTA,
  });

  String get highlightLine =>
      "$whyThisMatters${actionCTA.endsWith('.') ? '' : '.'} $actionCTA";
}

class _AIQuickTipWidgetState extends State<AIQuickTipWidget> {
  final PageController _controller = PageController(viewportFraction: 1);
  final Set<int> viewedTips = {};

  final List<_AIQuickTipModel> tips = [
    _AIQuickTipModel(
      icon: Icons.visibility,
      emoji: "🐳",
      category: "Whale Warning",
      summary: "Whales moved \$1.2M out of \$SUI.",
      whyThisMatters: "Large outflows often precede volatility.",
      actionCTA: "Watch Smart Tracker or mirror exits.",
    ),
    _AIQuickTipModel(
      icon: Icons.lightbulb,
      emoji: "💡",
      category: "Strategy Insight",
      summary: "LSD tokens lead in yield portfolios.",
      whyThisMatters: "These tokens thrive in passive income allocations.",
      actionCTA: "Review Builder for LSD exposure.",
    ),
    _AIQuickTipModel(
      icon: Icons.warning,
      emoji: "⚠️",
      category: "Risk Alert",
      summary: "ETH stakers rotating to stablecoins.",
      whyThisMatters: "Signals de-risking and momentum decay.",
      actionCTA: "Consider hedging ETH exposure.",
    ),
  ];

  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _startAutoCycle();
  }

  void _startAutoCycle() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      final nextPage = (_currentPage + 1) % tips.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  void _onTipChanged(int index) {
    setState(() {
      _currentPage = index;
      viewedTips.add(index);
    });
  }

  void _showModal(_AIQuickTipModel tip) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: "${tip.emoji} ${tip.category}",
        size: WidgetModalSize.small,
        onClose: () => Navigator.pop(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tip.summary,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 12),
            Text("Why this matters:",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                )),
            const SizedBox(height: 4),
            Text(tip.whyThisMatters,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                )),
            const SizedBox(height: 8),
            Text("Suggested Action:",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                )),
            const SizedBox(height: 4),
            Text(tip.actionCTA,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12), // Outer edge padding
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.outline.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 5),
            child: SizedBox(
              height: 110,
              child: PageView.builder(
                controller: _controller,
                itemCount: tips.length,
                onPageChanged: _onTipChanged,
                itemBuilder: (_, index) {
                  final tip = tips[index];
                  return GestureDetector(
                    onTap: () => _showModal(tip),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(tip.icon, color: scheme.primary, size: 28),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${tip.emoji} ${tip.category}",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w600,
                                  )),
                              const SizedBox(height: 6),
                              Text(tip.summary,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 6),
                              Text(tip.highlightLine,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurface.withOpacity(0.75),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _controller,
            count: tips.length,
            effect: WormEffect(
              dotHeight: 6,
              dotWidth: 6,
              spacing: 6,
              activeDotColor: scheme.primary,
              dotColor: scheme.onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
