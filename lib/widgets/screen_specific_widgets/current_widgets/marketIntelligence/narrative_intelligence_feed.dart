// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\narrative_intelligence_feed.dart

import 'package:flutter/material.dart';

class NarrativeIntelligenceFeed extends StatefulWidget {
  const NarrativeIntelligenceFeed({super.key});

  @override
  State<NarrativeIntelligenceFeed> createState() => _NarrativeIntelligenceFeedState();
}

class _NarrativePost {
  final String username;
  final String timestamp;
  final String content;
  final List<String> tags;
  final String source;
  final String trendScore;
  final List<String> tokens;
  final IconData icon;

  _NarrativePost({
    required this.username,
    required this.timestamp,
    required this.content,
    required this.tags,
    required this.source,
    required this.trendScore,
    required this.tokens,
    required this.icon,
  });
}

class _NarrativeIntelligenceFeedState extends State<NarrativeIntelligenceFeed> {
  final List<_NarrativePost> _posts = [
    _NarrativePost(
      username: '@blockalpha_bot',
      timestamp: '12m ago',
      content: 'Narratives rotating to Telegram coins again: WIF, JUP, POPCAT all breaking 1D mention highs.',
      tags: ['Telegram', 'Memecoins'],
      source: 'Twitter',
      trendScore: '↗ Medium',
      tokens: ['WIF', 'JUP'],
      icon: Icons.whatshot,
    ),
    _NarrativePost(
      username: '@defiguru',
      timestamp: '28m ago',
      content: 'AI narrative picking up again. FET and AGIX are leading mentions on Telegram.',
      tags: ['AI', 'Automation'],
      source: 'Telegram',
      trendScore: '🔥 High',
      tokens: ['FET', 'AGIX'],
      icon: Icons.trending_up,
    ),
  ];

  String _activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '🧠 Narrative Intelligence Feed',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Social and influencer narrative pulse',
                  child: const Icon(Icons.info_outline, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFilterChips(),
            const SizedBox(height: 12),
            Expanded(child: _buildFeed()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Tokens', 'Memes', 'Influencers', 'Chains', 'Alt L1s'];
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((filter) {
        final selected = _activeFilter == filter;
        return ChoiceChip(
          label: Text(filter),
          selected: selected,
          onSelected: (_) => setState(() => _activeFilter = filter),
          selectedColor: theme.colorScheme.primary.withOpacity(0.2),
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
          labelStyle: TextStyle(
            color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeed() {
    return ListView.separated(
      itemCount: _posts.length,
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (_, index) {
        final post = _posts[index];
        final theme = Theme.of(context);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(post.icon, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${post.username} • ${post.timestamp}',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(post.content, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: post.tags.map((tag) => Chip(label: Text(tag, style: const TextStyle(fontSize: 12)))).toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '💬 ${post.source} | 🧠 Trend Score: ${post.trendScore} | ${post.tokens.map((e) => '\$$e').join(" ")}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
