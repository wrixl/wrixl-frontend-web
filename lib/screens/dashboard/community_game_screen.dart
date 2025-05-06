// lib\screens\dashboard\community_game_screen.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';

class CommunityGameScreen extends StatefulWidget {
  const CommunityGameScreen({Key? key}) : super(key: key);

  @override
  State<CommunityGameScreen> createState() => _CommunityGameScreenState();
}

class _CommunityGameScreenState extends State<CommunityGameScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Predict'),
    Tab(text: 'Vote'),
    Tab(text: 'Earn'),
    Tab(text: 'Rank'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return _buildMobileLayout(context);
    } else {
      return _buildDesktopTabletLayout(context);
    }
  }

  Widget _buildDesktopTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Community & Gamification"),
        elevation: 0,
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final layout = LayoutHelper.fromDimensions(
              constraints.maxWidth, constraints.maxHeight);
          return TabBarView(
            controller: _tabController,
            children: [
              _tabContent(layout, _predictCards(layout)),
              _tabContent(layout, _voteCards(layout)),
              _tabContent(layout, _earnCards(layout)),
              _tabContent(layout, _rankCards(layout)),
            ],
          );
        },
      ),
    );
  }

  Widget _tabContent(LayoutHelper layout, List<_CardData> cards) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: LayoutHelper.fixedOuterScreenMargin,
        vertical: 24,
      ),
      child: Wrap(
        spacing: layout.cardGutter,
        runSpacing: layout.verticalRowSpacing,
        children: cards
            .map((card) => WrixlCard(
                  width: card.width,
                  height: card.height,
                  openOnTap: true,
                  modalTitle: card.modalTitle,
                  modalSize: card.modalSize,
                  child: Text("${card.modalTitle} Placeholder"),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final layout = LayoutHelper.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Community & Gamification"),
        elevation: 0,
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _mobileTabContent(layout, _predictCards(layout)),
          _mobileTabContent(layout, _voteCards(layout)),
          _mobileTabContent(layout, _earnCards(layout)),
          _mobileTabContent(layout, _rankCards(layout)),
        ],
      ),
    );
  }

  Widget _mobileTabContent(LayoutHelper layout, List<_CardData> cards) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: LayoutHelper.fixedOuterScreenMargin,
        vertical: 24,
      ),
      child: Column(
        children: cards
            .map((card) => Padding(
                  padding: EdgeInsets.only(bottom: layout.verticalRowSpacing),
                  child: WrixlCard(
                    width: layout.oneColumnWidth,
                    height: card.height,
                    openOnTap: true,
                    modalTitle: card.modalTitle,
                    modalSize: card.modalSize,
                    child: Text("${card.modalTitle} Placeholder"),
                  ),
                ))
            .toList(),
      ),
    );
  }

  List<_CardData> _predictCards(LayoutHelper layout) => [
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Signal Prediction Market",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.threeColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Portfolio Prediction Arena",
          modalSize: ModalSize.fullscreen,
        ),
      ];

  List<_CardData> _voteCards(LayoutHelper layout) => [
        _CardData(
          width: layout.threeColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Signals DAO Voting",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Signal Curation Submissions",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Referral Impact",
          modalSize: ModalSize.medium,
        ),
      ];

  List<_CardData> _earnCards(LayoutHelper layout) => [
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "WRX Rewards Dashboard",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Rewards Inventory",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.shortHeight,
          modalTitle: "Claimable Perks",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.shortHeight,
          modalTitle: "Impact Score",
          modalSize: ModalSize.medium,
        ),
      ];

  List<_CardData> _rankCards(LayoutHelper layout) => [
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "User Leaderboard",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Community Contests",
          modalSize: ModalSize.large,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Badge Collection",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.shortHeight,
          modalTitle: "XP Progress",
          modalSize: ModalSize.small,
        ),
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.moderateHeight,
          modalTitle: "Weekly Mission",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.oneColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Wrixler Rank",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.twoColumnWidth,
          height: layout.mediumHeight,
          modalTitle: "Sector Rankings",
          modalSize: ModalSize.medium,
        ),
        _CardData(
          width: layout.threeColumnWidth,
          height: layout.tallHeight,
          modalTitle: "Discussion Threads",
          modalSize: ModalSize.fullscreen,
        ),
      ];
}

class _CardData {
  final double width;
  final double height;
  final String modalTitle;
  final ModalSize modalSize;

  _CardData({
    required this.width,
    required this.height,
    required this.modalTitle,
    required this.modalSize,
  });
}
