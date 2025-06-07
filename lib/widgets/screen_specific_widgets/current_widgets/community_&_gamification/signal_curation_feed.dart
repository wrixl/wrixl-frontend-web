
// lib/widgets/screen_specific_widgets/current_widgets/community_&_gamification/signal_curation_feed.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class SignalCurationFeedWidget extends StatefulWidget {
  const SignalCurationFeedWidget({super.key});

  @override
  State<SignalCurationFeedWidget> createState() => _SignalCurationFeedWidgetState();
}

class _SignalProposal {
  final String title;
  final String category;
  final String proposer;
  final int upvotes;
  final DateTime submittedAt;
  final String description;

  _SignalProposal({
    required this.title,
    required this.category,
    required this.proposer,
    required this.upvotes,
    required this.submittedAt,
    required this.description,
  });
}

class _SignalCurationFeedWidgetState extends State<SignalCurationFeedWidget> {
  final List<_SignalProposal> _proposals = [
    _SignalProposal(
      title: "L2 Rotation Incoming?",
      category: "Narrative",
      proposer: "@evie.eth",
      upvotes: 83,
      submittedAt: DateTime.now().subtract(const Duration(hours: 3)),
      description: "Multiple L2s show renewed velocity on-chain. Might front-run L1 weakness."
    ),
    _SignalProposal(
      title: "DeFi Reawakening",
      category: "Sector",
      proposer: "@vaultboi",
      upvotes: 41,
      submittedAt: DateTime.now().subtract(const Duration(hours: 6)),
      description: "Stables inflow rising in Curve, Aave. Potential rebound setup."
    ),
    _SignalProposal(
      title: "SocialFi Spike",
      category: "Trend",
      proposer: "@kairo",
      upvotes: 37,
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      description: "Farcaster and friend.tech metrics suggest a new round of hype."
    ),
  ];

  void _upvote(int index) {
    setState(() {
      _proposals[index] = _SignalProposal(
        title: _proposals[index].title,
        category: _proposals[index].category,
        proposer: _proposals[index].proposer,
        upvotes: _proposals[index].upvotes + 1,
        submittedAt: _proposals[index].submittedAt,
        description: _proposals[index].description,
      );
    });
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Signal Curation Feed', style: theme.textTheme.titleMedium),
                const Icon(Icons.insights, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _proposals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = _proposals[index];
                  return GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => NewWidgetModal(
                        title: p.title,
                        size: WidgetModalSize.medium,
                        onClose: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title, style: theme.textTheme.headlineSmall),
                              const SizedBox(height: 12),
                              Text(p.description, style: theme.textTheme.bodyMedium),
                              const SizedBox(height: 16),
                              Text("Submitted by ${p.proposer} in ${p.category}",
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.title,
                                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(p.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 13)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(p.category.toUpperCase(),
                                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
                                    const SizedBox(width: 12),
                                    Text(_timeAgo(p.submittedAt),
                                      style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor)),
                                    const SizedBox(width: 12),
                                    Text("by ${p.proposer}",
                                      style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_upward),
                                tooltip: "Upvote",
                                onPressed: () => _upvote(index),
                              ),
                              Text("${p.upvotes}", style: theme.textTheme.labelMedium),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
