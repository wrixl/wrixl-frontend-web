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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        _buildFilterChips(),
        const SizedBox(height: 12),
        Expanded(child: _buildFeed()),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Narrative Intelligence Feed',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: 'Social and influencer narrative pulse',
          child: const Icon(Icons.info_outline, size: 18),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Tokens', 'Memes', 'Influencers', 'Chains', 'Alt L1s'];
    return Wrap(
      spacing: 8,
      children: filters.map((filter) {
        final selected = _activeFilter == filter;
        return ChoiceChip(
          label: Text(filter),
          selected: selected,
          onSelected: (_) => setState(() => _activeFilter = filter),
        );
      }).toList(),
    );
  }

  Widget _buildFeed() {
    return ListView.separated(
      itemCount: _posts.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final post = _posts[index];
        return ListTile(
          leading: Icon(post.icon, color: Colors.orange),
          title: Text('${post.username} • ${post.timestamp}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.content),
              const SizedBox(height: 4),
              Text(
                '🏷️ ${post.tags.join(", ")}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                '💬 ${post.source} | 🧠 Trend Score: ${post.trendScore} | ${post.tokens.map((e) => '\$$e').join(" ")}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
