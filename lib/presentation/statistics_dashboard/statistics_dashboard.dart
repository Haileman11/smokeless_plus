import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/chart_selector_widget.dart';
import './widgets/comparison_section_widget.dart';
import './widgets/export_options_widget.dart';
import './widgets/filter_options_widget.dart';
import './widgets/interactive_chart_widget.dart';
import './widgets/metric_card_widget.dart';

class StatisticsDashboard extends StatefulWidget {
  const StatisticsDashboard({super.key});

  @override
  State<StatisticsDashboard> createState() => _StatisticsDashboardState();
}

class _StatisticsDashboardState extends State<StatisticsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedChartIndex = 0;
  String _selectedDateRange = 'Last 30 Days';
  String _selectedMetricType = 'All Metrics';
  String _selectedComparison = 'Personal Goals';
  DateTime _lastUpdated = DateTime.now();

  // Mock data for statistics
  final List<Map<String, dynamic>> _topMetrics = [
    {
      "title": "Days Smoke-Free",
      "value": "127",
      "subtitle": "4 months, 5 days",
      "icon": "calendar_today",
      "backgroundColor": null,
    },
    {
      "title": "Money Saved",
      "value": "\$847",
      "subtitle": "Average \$6.67/day",
      "icon": "attach_money",
      "backgroundColor": null,
    },
    {
      "title": "Cigarettes Avoided",
      "value": "2,540",
      "subtitle": "20 packs avoided",
      "icon": "smoke_free",
      "backgroundColor": null,
    },
    {
      "title": "Life Regained",
      "value": "18.2 hrs",
      "subtitle": "Time not smoking",
      "icon": "favorite",
      "backgroundColor": null,
    },
  ];

  final List<String> _chartTypes = [
    'Daily Streak',
    'Weekly Cravings',
    'Monthly Savings',
    'Health Progress',
  ];

  final Map<String, List<Map<String, dynamic>>> _chartData = {
    'Daily Streak': [
      {"label": "Mon", "value": 1},
      {"label": "Tue", "value": 2},
      {"label": "Wed", "value": 3},
      {"label": "Thu", "value": 4},
      {"label": "Fri", "value": 5},
      {"label": "Sat", "value": 6},
      {"label": "Sun", "value": 7},
    ],
    'Weekly Cravings': [
      {"label": "Week 1", "value": 15},
      {"label": "Week 2", "value": 12},
      {"label": "Week 3", "value": 8},
      {"label": "Week 4", "value": 5},
    ],
    'Monthly Savings': [
      {"label": "Jan", "value": 180},
      {"label": "Feb", "value": 195},
      {"label": "Mar", "value": 220},
      {"label": "Apr", "value": 252},
    ],
    'Health Progress': [
      {"label": "Lung Function", "value": 75},
      {"label": "Heart Health", "value": 85},
      {"label": "Circulation", "value": 90},
      {"label": "Energy Level", "value": 80},
    ],
  };

  final Map<String, dynamic> _userStats = {
    "daysQuit": 127,
    "moneySaved": 847,
    "cigarettesAvoided": 2540,
  };

  final Map<String, dynamic> _averageStats = {
    "daysQuit": 95,
    "moneySaved": 650,
    "cigarettesAvoided": 1900,
  };

  final Map<String, dynamic> _personalGoals = {
    "daysGoal": 365,
    "moneyGoal": 2000,
    "cigarettesGoal": 7300,
  };

  final List<Map<String, dynamic>> _achievements = [
    {
      "id": 1,
      "title": "First Week Champion",
      "description": "Completed your first smoke-free week",
      "icon": "emoji_events",
      "unlocked": true,
      "date": "2024-01-15",
    },
    {
      "id": 2,
      "title": "Money Saver",
      "description": "Saved your first \$500",
      "icon": "savings",
      "unlocked": true,
      "date": "2024-03-10",
    },
    {
      "id": 3,
      "title": "Health Warrior",
      "description": "100 days smoke-free milestone",
      "icon": "favorite",
      "unlocked": true,
      "date": "2024-04-20",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopMetricsSection(),
              _buildTabSection(),
              SizedBox(height: 2.h),
              _buildTabContent(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Statistics Dashboard',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showFilterBottomSheet,
          icon: CustomIconWidget(
            iconName: 'tune',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last updated: ${_formatLastUpdated()}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'wifi',
                      color: Theme.of(context).colorScheme.secondary,
                      size: 12,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Online',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopMetricsSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Key Metrics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: _topMetrics.length,
              itemBuilder: (context, index) {
                final metric = _topMetrics[index];
                return MetricCardWidget(
                  title: metric['title'] as String,
                  value: metric['value'] as String,
                  subtitle: metric['subtitle'] as String,
                  iconName: metric['icon'] as String,
                  backgroundColor: metric['backgroundColor'] as Color?,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Charts'),
          Tab(text: 'Comparison'),
          Tab(text: 'Export'),
        ],
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 60.h,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildChartsTab(),
          _buildComparisonTab(),
          _buildExportTab(),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    return Column(
      children: [
        ChartSelectorWidget(
          chartTypes: _chartTypes,
          selectedIndex: _selectedChartIndex,
          onSelectionChanged: (index) {
            setState(() {
              _selectedChartIndex = index;
            });
          },
        ),
        Expanded(
          child: PageView.builder(
            itemCount: _chartTypes.length,
            controller: PageController(initialPage: _selectedChartIndex),
            onPageChanged: (index) {
              setState(() {
                _selectedChartIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final chartType = _chartTypes[index];
              return InteractiveChartWidget(
                chartType: chartType,
                chartData: _chartData[chartType] ?? [],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ComparisonSectionWidget(
            userStats: _userStats,
            averageStats: _averageStats,
            personalGoals: _personalGoals,
          ),
          _buildAchievementsSection(),
        ],
      ),
    );
  }

  Widget _buildExportTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ExportOptionsWidget(
            onExportInfographic: _exportInfographic,
            onExportCSV: _exportCSV,
            onShareStats: _shareStats,
          ),
          _buildExportHistorySection(),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Achievements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ..._achievements.map((achievement) {
              return Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: achievement['icon'] as String,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement['title'] as String,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            achievement['description'] as String,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      achievement['date'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExportHistorySection() {
    final List<Map<String, dynamic>> exportHistory = [
      {
        "type": "CSV Report",
        "date": "2024-09-20",
        "size": "2.3 KB",
        "icon": "table_chart",
      },
      {
        "type": "Infographic",
        "date": "2024-09-18",
        "size": "1.8 MB",
        "icon": "image",
      },
      {
        "type": "CSV Report",
        "date": "2024-09-15",
        "size": "2.1 KB",
        "icon": "table_chart",
      },
    ];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...exportHistory.map((export) {
              return Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: export['icon'] as String,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            export['type'] as String,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${export['date']} • ${export['size']}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          _downloadExportedFile(export['type'] as String),
                      icon: CustomIconWidget(
                        iconName: 'download',
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: FilterOptionsWidget(
                selectedDateRange: _selectedDateRange,
                selectedMetricType: _selectedMetricType,
                selectedComparison: _selectedComparison,
                onDateRangeChanged: (value) {
                  setState(() {
                    _selectedDateRange = value;
                  });
                  Navigator.pop(context);
                },
                onMetricTypeChanged: (value) {
                  setState(() {
                    _selectedMetricType = value;
                  });
                  Navigator.pop(context);
                },
                onComparisonChanged: (value) {
                  setState(() {
                    _selectedComparison = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _lastUpdated = DateTime.now();
    });
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _exportInfographic() async {
    try {
      final infographicData = _generateInfographicData();
      await _downloadFile(infographicData, 'quit_smoking_infographic.json');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Infographic exported successfully!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to export infographic'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _exportCSV() async {
    try {
      final csvData = _generateCSVData();
      await _downloadFile(csvData, 'quit_smoking_statistics.csv');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('CSV report exported successfully!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to export CSV report'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _shareStats() async {
    final shareText = _generateShareText();

    if (kIsWeb) {
      await _copyToClipboard(shareText);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Statistics copied to clipboard!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } else {
      // On mobile, this would trigger the native share sheet
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Share functionality would open native share sheet'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  Future<void> _downloadExportedFile(String fileType) async {
    try {
      String content;
      String filename;

      if (fileType == 'CSV Report') {
        content = _generateCSVData();
        filename = 'quit_smoking_statistics.csv';
      } else {
        content = _generateInfographicData();
        filename = 'quit_smoking_infographic.json';
      }

      await _downloadFile(content, filename);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$fileType downloaded successfully!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download $fileType'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }

  Future<void> _copyToClipboard(String text) async {
    if (kIsWeb) {
      await html.window.navigator.clipboard?.writeText(text);
    }
  }

  String _generateInfographicData() {
    final data = {
      "title": "My Quit Smoking Journey",
      "metrics": _topMetrics,
      "achievements": _achievements,
      "generated_date": DateTime.now().toIso8601String(),
      "user_stats": _userStats,
    };
    return jsonEncode(data);
  }

  String _generateCSVData() {
    final buffer = StringBuffer();
    buffer.writeln('Metric,Value,Description');
    buffer.writeln(
        'Days Smoke-Free,${_userStats['daysQuit']},Total days without smoking');
    buffer.writeln(
        'Money Saved,\$${_userStats['moneySaved']},Total money saved from not buying cigarettes');
    buffer.writeln(
        'Cigarettes Avoided,${_userStats['cigarettesAvoided']},Total cigarettes not smoked');
    buffer.writeln('');
    buffer.writeln('Achievement,Date,Description');

    for (final achievement in _achievements) {
      buffer.writeln(
          '${achievement['title']},${achievement['date']},${achievement['description']}');
    }

    return buffer.toString();
  }

  String _generateShareText() {
    return '''🚭 My Quit Smoking Progress 🚭

✅ ${_userStats['daysQuit']} days smoke-free
💰 \$${_userStats['moneySaved']} saved
🚫 ${_userStats['cigarettesAvoided']} cigarettes avoided

Every day smoke-free is a victory! 💪

#QuitSmoking #HealthyLifestyle #SmokeFree''';
  }
}