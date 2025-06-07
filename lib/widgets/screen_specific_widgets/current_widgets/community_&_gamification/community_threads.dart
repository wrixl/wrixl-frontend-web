// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\community_threads.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class CommunityThreadsWidget extends StatefulWidget {
  const CommunityThreadsWidget({Key? key}) : super(key: key);

  @override
  State<CommunityThreadsWidget> createState() => _CommunityThreadsWidgetState();
}

class _CommunityThreadsWidgetState extends State<CommunityThreadsWidget> {
  final List<Map<String, dynamic>> threads = [
    {
      'context': '📈 Signal: AI Momentum Surge',
      'comment': 'AI layer 1s are showing a breakout pattern. This one looks primed.',
      'replies': 13,
      'likes': 27,
      'activeAgo': '5m',
      'highlight': 'Top Weekly Take',
      'pinned': true
    },
    {
      'context': '🗳️ Vote: Add RWA Token Index',
      'comment': 'Real-world assets are growing fast — makes sense to include.',
      'replies': 8,
      'likes': 14,
      'activeAgo': '22m',
      'highlight': null,
      'pinned': false
    },
    {
      'context': '🎯 Mission: Earn 100 XP this week',
      'comment': 'I’m 75 XP in. Final push tomorrow. Who’s with me?',
      'replies': 19,
      'likes': 31,
      'activeAgo': '1h',
      'highlight': 'Wrixler’s Choice',
      'pinned': false
    },
  ];

  void _openThreadModal(Map<String, dynamic> thread) {
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: thread['context'],
        size: WidgetModalSize.medium,
        onClose: () => Navigator.of(context).pop(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(thread['comment'], style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            const Text('🧵 Full thread replies coming soon...', style: TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }

  Widget _buildThreadCard(Map<String, dynamic> thread) {
    final highlight = thread['highlight'];
    final isPinned = thread['pinned'];
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _openThreadModal(thread),
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isPinned ? Colors.amber.withOpacity(0.1) : scheme.surface,
          border: Border.all(color: scheme.outline.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(thread['context'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              thread['comment'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.message_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text('${thread['replies']}'),
                  const SizedBox(width: 12),
                  const Icon(Icons.thumb_up_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text('${thread['likes']}'),
                ]),
                Row(children: [
                  Icon(Icons.circle, size: 10, color: Colors.green.shade400),
                  const SizedBox(width: 4),
                  Text('Active ${thread['activeAgo']}', style: Theme.of(context).textTheme.bodySmall)
                ])
              ],
            ),
            if (highlight != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(highlight, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: scheme.surface,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Community Threads', style: theme.textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Join the top takes on this week’s signals, votes & missions.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: threads.map(_buildThreadCard).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
