import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/user_data_service.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/achievement_category_tab_widget.dart';
import './widgets/achievement_detail_modal_widget.dart';
import './widgets/points_level_header_widget.dart';
import './widgets/recent_achievements_widget.dart';
import './widgets/reward_redemption_modal_widget.dart';

class AchievementSystem extends StatefulWidget {
  const AchievementSystem({Key? key}) : super(key: key);

  @override
  State<AchievementSystem> createState() => _AchievementSystemState();
}

class _AchievementSystemState extends State<AchievementSystem>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  int _currentBottomIndex = 4; // Achievement System is at index 4
  bool _isLoading = true;

  // Dynamic user data - loaded from UserDataService
  Map<String, dynamic> _userData = {};
  Map<String, dynamic> _achievementData = {
    'unlockedAchievements': [],
    'upcomingAchievements': [],
    'totalPoints': 0,
    'currentLevel': 1,
    'pointsToNextLevel': 200,
    'pointsForNextLevel': 200,
    'totalAchievements': 0,
    'unlockedCount': 0,
  };

  // Achievement categories
  final List<Map<String, String>> categories = [
    {'title': 'All', 'icon': 'emoji_events'},
    {'title': 'Streak', 'icon': 'local_fire_department'},
    {'title': 'Health', 'icon': 'favorite'},
    {'title': 'Financial', 'icon': 'savings'},
    {'title': 'Progress', 'icon': 'trending_up'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load user data and achievements
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final userData = await UserDataService.loadUserData();

      if (userData != null) {
        setState(() {
          _userData = userData;
          _achievementData = userData['achievements'] ?? _achievementData;
        });
      } else {
        // If no user data, redirect to onboarding
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
        return;
      }
    } catch (e) {
      // Show error message but continue with default values
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading achievements. Using default values.'),
          backgroundColor: Colors.orange,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  List<Map<String, dynamic>> get _recentAchievements {
    final unlocked =
        _achievementData['unlockedAchievements'] as List<dynamic>? ?? [];
    // Get the 3 most recent achievements (assuming they're ordered)
    return unlocked.cast<Map<String, dynamic>>().take(3).toList();
  }

  List<Map<String, dynamic>> get _currentCategoryAchievements {
    final unlocked =
        _achievementData['unlockedAchievements'] as List<dynamic>? ?? [];
    final upcoming =
        _achievementData['upcomingAchievements'] as List<dynamic>? ?? [];

    List<Map<String, dynamic>> allAchievements = [
      ...unlocked.cast<Map<String, dynamic>>(),
      ...upcoming.cast<Map<String, dynamic>>(),
    ];

    if (_selectedTabIndex == 0) {
      // Show all achievements
      return allAchievements;
    } else {
      // Filter by category
      String categoryKey = categories[_selectedTabIndex]['title']!;
      return allAchievements
          .where((achievement) => achievement['category'] == categoryKey)
          .toList();
    }
  }

  void _showAchievementDetail(Map<String, dynamic> achievement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AchievementDetailModalWidget(
        achievement: achievement,
      ),
    );
  }

  void _showRewardRedemption() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RewardRedemptionModalWidget(
        availablePoints: _achievementData['totalPoints'] ?? 0,
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Loading Your Achievements...',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Achievement System',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.primaryColor,
            )),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: CustomScrollView(
          slivers: [
            // Points and Level Header
            SliverToBoxAdapter(
              child: PointsLevelHeaderWidget(
                totalPoints: _achievementData['totalPoints'] ?? 0,
                currentLevel: _achievementData['currentLevel'] ?? 1,
                pointsToNextLevel: _achievementData['pointsToNextLevel'] ?? 200,
                pointsForNextLevel:
                    _achievementData['pointsForNextLevel'] ?? 200,
              ),
            ),

            // Achievement Progress Summary
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProgressStat(
                      'Unlocked',
                      '${_achievementData['unlockedCount'] ?? 0}',
                      'emoji_events',
                      AppTheme.successLight,
                    ),
                    _buildProgressStat(
                      'Total',
                      '${_achievementData['totalAchievements'] ?? 0}',
                      'military_tech',
                      AppTheme.lightTheme.primaryColor,
                    ),
                    _buildProgressStat(
                      'Progress',
                      '${((_achievementData['unlockedCount'] ?? 0) / (_achievementData['totalAchievements'] ?? 1) * 100).toInt()}%',
                      'trending_up',
                      AppTheme.accentLight,
                    ),
                  ],
                ),
              ),
            ),

            // Recent Achievements Section
            if (_recentAchievements.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
                  child: Text(
                    'Recent Achievements',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: RecentAchievementsWidget(
                  recentAchievements: _recentAchievements,
                  onAchievementTap: _showAchievementDetail,
                ),
              ),
            ],

            // Category Tabs
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 3.h),
                height: 6.h,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicator: const BoxDecoration(),
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  tabs: categories.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> category = entry.value;
                    return AchievementCategoryTabWidget(
                      title: category['title']!,
                      iconName: category['icon']!,
                      isSelected: _selectedTabIndex == index,
                      onTap: () {
                        _tabController.animateTo(index);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            // Achievement Grid
            if (_currentCategoryAchievements.isEmpty) ...[
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'emoji_events',
                        color: AppTheme.textMediumEmphasisLight,
                        size: 15.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Keep going!\nAchievements will unlock as you progress.',
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.h,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final achievement = _currentCategoryAchievements[index];
                      return AchievementBadgeWidget(
                        achievement: achievement,
                        onTap: () => _showAchievementDetail(achievement),
                      );
                    },
                    childCount: _currentCategoryAchievements.length,
                  ),
                ),
              ),
            ],

            // Bottom spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRewardRedemption,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'card_giftcard',
          color: Colors.white,
          size: 5.w,
        ),
        label: Text(
          'Rewards',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),     
    );
  }

  Widget _buildProgressStat(
      String label, String value, String iconName, Color color) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
