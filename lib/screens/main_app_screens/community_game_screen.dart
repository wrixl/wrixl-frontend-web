// lib\screens\dashboard\community_game_screen.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/claimable_perks.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/community_challenges.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/community_threads.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/my_badge_collection.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/referral_impact_tracker.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/rewards_dashboard.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/rewards_inventory.dart';

// Widgets
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/signal_arena.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/portfolio_arena.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/signal_curation_feed.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/signals_dao_voting.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/top_sector_rankings.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/user_impact_score.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/user_leaderboard.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/weekly_quest_progress.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/wrixler_rank_tier.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/community_&_gamification/xp_level_progress.dart';


class CommunityGameScreen extends StatefulWidget {
  const CommunityGameScreen({Key? key}) : super(key: key);

  @override
  State<CommunityGameScreen> createState() => _CommunityGameScreenState();
}

class _CommunityGameScreenState extends State<CommunityGameScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _tabKeys = ['Predict', 'Vote', 'Earn', 'Rank'];
  late TabController _tabController;
  late String selectedTabKey;
  late String selectedPreset;
  bool _isEditing = false;

  final Map<String, List<String>> availablePresets = {
    for (var tab in ['Predict', 'Vote', 'Earn', 'Rank'])
      tab: ['Default', 'Alt', 'Custom']
  };

  final Map<String, DashboardScreenController> _controllers = {};
  final Map<String, Future<void>> _initFutures = {};

  @override
  void initState() {
    super.initState();
    selectedTabKey = _tabKeys[0];
    selectedPreset = 'Default';
    _tabController = TabController(length: _tabKeys.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _initializeController(selectedTabKey, selectedPreset);
  }

  void _onTabChanged() {
    final newTab = _tabKeys[_tabController.index];
    setState(() {
      selectedTabKey = newTab;
      selectedPreset = 'Default';
    });
    _initializeController(newTab, selectedPreset);
  }

  void _syncEditingState() {
    _controllers[selectedTabKey]?.controller.isEditing = _isEditing;
  }

  Future<void> _initializeController(String tab, String preset) async {
    final controller = DashboardScreenController(
      screenId: 'community_game',
      preset: '${preset}_$tab',
      context: context,
      getDefaultItems: (DeviceSizeClass sizeClass) => _getItemsForTab(tab),
    );
    _controllers[tab] = controller;
    _initFutures[tab] =
        controller.initialize().then((_) => _syncEditingState());
    setState(() {});
  }

  List<DashboardItem> _getItemsForTab(String tab) {
    final configsByTab = {
      'Predict': [
        {'id': 'Signal Arena','x': 0, 'y': 0, 'w': 6, 'h': 4, 'minW': 6},
        {'id': 'Portfolio Arena', 'x': 0, 'y': 4, 'w': 12, 'h': 4,'minW': 6},
      ],
      'Vote': [
        {'id': 'Signals DAO Voting', 'x': 0, 'y': 0, 'w': 12, 'h': 4, 'minW': 6},
        {'id': 'Signal Curation Feed', 'x': 0, 'y': 4, 'w': 8, 'h': 4, 'minW': 6},
        {'id': 'Referral Impact Tracker', 'x': 8, 'y': 4, 'w': 4, 'h': 3, 'minW': 3},
      ],
      'Earn': [
        {'id': 'Rewards Dashboard', 'x': 0, 'y': 0, 'w': 8, 'h': 4,'minW': 6},
        {'id': 'Rewards Inventory', 'x': 8, 'y': 0, 'w': 4, 'h': 3, 'minW': 3},
        {'id': 'Claimable Perks', 'x': 0, 'y': 4, 'w': 6, 'h': 2, 'minW': 4},
        {'id': 'User Impact Score', 'x': 6, 'y': 4, 'w': 6, 'h': 2, 'minW': 4},
      ],
      'Rank': [
        {'id': 'User Leaderboard', 'x': 0, 'y': 0, 'w': 4, 'h': 3, 'minW': 3},
        {'id': 'Community Challenges', 'x': 4, 'y': 0, 'w': 8, 'h': 3, 'minW': 6},
        {'id': 'My Badge Collection', 'x': 0, 'y': 3, 'w': 4, 'h': 3, 'minW': 3},
        {'id': 'XP & Level Progress', 'x': 4, 'y': 3, 'w': 4, 'h': 2, 'minW': 3},
        {'id': 'Weekly Quest Progress', 'x': 0, 'y': 6, 'w': 8, 'h': 3, 'minW': 6},
        {'id': 'Wrixler Rank Tier', 'x': 8, 'y': 3, 'w': 4, 'h': 3, 'minW': 3},
        {'id': 'Top Sector Rankings', 'x': 0, 'y': 9, 'w': 8, 'h': 3, 'minW': 6},
        {'id': 'Community Threads', 'x': 0, 'y': 12, 'w': 12, 'h': 6, 'minW': 6},
      ]
    };

    return (configsByTab[tab] ?? [])
        .map((cfg) => DashboardItem(
              identifier: cfg['id'].toString(),
              width: cfg['w'] as int,
              height: cfg['h'] as int,
              minWidth: cfg['minW'] as int,
              minHeight: (cfg['minH'] ?? 1) as int,
              startX: cfg['x'] as int,
              startY: cfg['y'] as int,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabKeys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Community & Gamification"),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabKeys.map((t) => Tab(text: t)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabKeys.map((tabKey) {
            final controller = _controllers[tabKey];
            final future = _initFutures[tabKey];
            final presets = availablePresets[tabKey]!;

            if (controller == null || future == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return DashboardScaffold(
              title: 'Community - $tabKey',
              presets: presets,
              selectedPreset: selectedPreset,
              isEditing: _isEditing,
              onPresetChanged: (val) async {
                setState(() {
                  selectedPreset = val;
                  _isEditing = false;
                });
                await _initializeController(tabKey, val);
              },
              onToggleEditing: () {
                if (selectedPreset != 'Custom') {
                  setState(() {
                    selectedPreset = 'Custom';
                    _isEditing = false;
                  });
                  _initializeController(tabKey, selectedPreset);
                } else {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _syncEditingState();
                  });
                }
              },
              child: FutureBuilder<void>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Dashboard<DashboardItem>(
                    key: ValueKey('$tabKey|$selectedPreset|$_isEditing'),
                    dashboardItemController: controller.controller,
                    slotCount: 12,
                    slotAspectRatio: 1,
                    horizontalSpace: 40,
                    verticalSpace: 40,
                    padding: const EdgeInsets.all(16),
                    shrinkToPlace: false,
                    slideToTop: false,
                    absorbPointer: false,
                    animateEverytime: false,
                    physics: const BouncingScrollPhysics(),
                    slotBackgroundBuilder: SlotBackgroundBuilder.withFunction(
                        (_, __, ___, ____, _____) => null),
                    editModeSettings: EditModeSettings(
                      longPressEnabled: true,
                      panEnabled: true,
                      draggableOutside: true,
                      autoScroll: true,
                      resizeCursorSide: 10,
                      backgroundStyle: EditModeBackgroundStyle(
                        lineColor: Colors.grey,
                        lineWidth: 0.5,
                        dualLineHorizontal: true,
                        dualLineVertical: true,
                      ),
                    ),
                    itemBuilder: (item) {
                      final id = item.identifier;
                      final isHidden = !controller.isVisible(id);
                      if (!_isEditing && isHidden)
                        return const SizedBox.shrink();

                      Widget child;
                      switch (id) {
                        case 'Signal Arena':
                          child = const SignalArenaWidget();
                          break;
                        case 'Portfolio Arena':
                          child = const PortfolioArenaWidget();
                          break;
                        case 'Signals DAO Voting':
                          child = const SignalsDAOVotingWidget();
                          break;
                        case 'Signal Curation Feed':
                          child = const SignalCurationFeedWidget();
                          break;
                        case 'Referral Impact Tracker':
                          child = const ReferralImpactTrackerWidget();
                          break;
                        case 'Rewards Dashboard':
                          child = const RewardsDashboardWidget();
                          break;
                        case 'Rewards Inventory':
                          child = const RewardsInventoryWidget();
                          break;
                        case 'Claimable Perks':
                          child = const ClaimablePerksWidget();
                          break;
                        case 'User Impact Score':
                          child = const UserImpactScoreWidget();
                          break;
                        case 'User Leaderboard':
                          child = const UserLeaderboardWidget();
                          break;
                        case 'Community Challenges':
                          child = const CommunityChallengesWidget();
                          break;
                        case 'My Badge Collection':
                          child = const MyBadgeCollectionWidget();
                          break;
                        case 'XP & Level Progress':
                          child = XPLevelProgressWidget(
                            currentXP: 1720,
                            nextLevelXP: 2000,
                            currentTier: 'Silver',
                            nextTier: 'Gold',
                            tierIcon: '🥈',
                            onEarnXPPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => NewWidgetModal(
                                  title: 'How to Earn XP',
                                  size: WidgetModalSize.medium,
                                  onClose: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    'Complete predictions, votes, and challenges to earn XP!',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          );
                          break;


                          break;
                        case 'Weekly Quest Progress':
                          child = const WeeklyQuestProgressWidget();
                          break;
                        case 'Wrixler Rank Tier':
                          child = const WrixlerRankTierWidget();
                          break;
                        case 'Top Sector Rankings':
                          child = const TopSectorRankingsWidget();
                          break;
                        case 'Community Threads':
                          child = const CommunityThreadsWidget();
                          break;

                        default:
                          child = Text(
                            'Widget $id\n'
                            'x:${item.layoutData?.startX} y:${item.layoutData?.startY}\n'
                            'w:${item.layoutData?.width} h:${item.layoutData?.height}',
                            textAlign: TextAlign.center,
                          );
                      }

                      return WidgetCard(
                        item: item,
                        child: child,
                        isEditMode: _isEditing,
                        isHidden: isHidden,
                        onToggleVisibility: () => setState(() => controller.toggleVisibility(id)),
                        modalTitle: 'Widget $id',
                        modalSize: WidgetModalSize.medium,
                      );
                    }

                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
