import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/milestone_card_widget.dart';
import './widgets/milestone_detail_modal.dart';
import './widgets/progress_header_widget.dart';

class HealthMilestones extends StatefulWidget {
  const HealthMilestones({Key? key}) : super(key: key);

  @override
  State<HealthMilestones> createState() => _HealthMilestonesState();
}

class _HealthMilestonesState extends State<HealthMilestones> {
  bool _isLoading = false;

  // Mock data for health milestones
  final List<Map<String, dynamic>> _milestones = [
    {
      "id": 1,
      "timeframe": "20 minutes",
      "title": "Heart Rate & Blood Pressure Normalize",
      "description":
          "Your heart rate and blood pressure drop to normal levels, reducing immediate cardiovascular stress.",
      "scientificExplanation":
          "Nicotine's stimulant effects on the cardiovascular system begin to subside. The sympathetic nervous system activity decreases, allowing heart rate and blood pressure to return to baseline levels.",
      "isAchieved": true,
      "achievedAt": DateTime.now().subtract(const Duration(days: 45)),
      "tips": [
        "Take deep breathing exercises to enhance the calming effect",
        "Stay hydrated to support healthy blood circulation",
        "Monitor your pulse to see the immediate improvement"
      ],
      "motivationalMessage":
          "In just 20 minutes, your body has already started its incredible healing journey!"
    },
    {
      "id": 2,
      "timeframe": "12 hours",
      "title": "Carbon Monoxide Levels Drop",
      "description":
          "Carbon monoxide levels in your blood drop to normal, and oxygen levels increase significantly.",
      "scientificExplanation":
          "Carbon monoxide has a half-life of 4-6 hours in the bloodstream. After 12 hours, CO levels normalize, allowing hemoglobin to carry oxygen more efficiently throughout your body.",
      "isAchieved": true,
      "achievedAt": DateTime.now().subtract(const Duration(days: 44)),
      "tips": [
        "Get some fresh air to accelerate oxygen replenishment",
        "Practice light physical activity to improve circulation",
        "Notice improved energy levels and mental clarity"
      ],
      "motivationalMessage":
          "Your blood is now carrying life-giving oxygen instead of toxic carbon monoxide!"
    },
    {
      "id": 3,
      "timeframe": "24 hours",
      "title": "Heart Attack Risk Begins to Decrease",
      "description":
          "Your risk of heart attack starts to decrease as your cardiovascular system begins to recover.",
      "scientificExplanation":
          "The acute cardiovascular stress from nicotine and carbon monoxide exposure is eliminated. Platelet aggregation decreases, reducing the risk of blood clots and acute coronary events.",
      "isAchieved": true,
      "achievedAt": DateTime.now().subtract(const Duration(days: 43)),
      "tips": [
        "Maintain a heart-healthy diet rich in antioxidants",
        "Start gentle exercise to strengthen your heart",
        "Get adequate sleep to support cardiovascular recovery"
      ],
      "motivationalMessage":
          "Every hour smoke-free is an hour of protection for your heart!"
    },
    {
      "id": 4,
      "timeframe": "48 hours",
      "title": "Taste and Smell Improve",
      "description":
          "Damaged nerve endings begin to regrow, and your sense of taste and smell start to improve.",
      "scientificExplanation":
          "Smoking damages the olfactory receptors and taste buds. After 48 hours, these sensory organs begin regenerating, leading to enhanced taste and smell perception.",
      "isAchieved": true,
      "achievedAt": DateTime.now().subtract(const Duration(days: 42)),
      "tips": [
        "Try new foods to experience enhanced flavors",
        "Enjoy the aroma of flowers, coffee, and fresh air",
        "Use this improved sense to avoid smoking triggers"
      ],
      "motivationalMessage":
          "Welcome back to a world of rich flavors and beautiful scents!"
    },
    {
      "id": 5,
      "timeframe": "72 hours",
      "title": "Nicotine Completely Eliminated",
      "description":
          "All nicotine is eliminated from your body, and breathing becomes easier as bronchial tubes relax.",
      "scientificExplanation":
          "Nicotine has a half-life of 1-2 hours, and after 72 hours, it's completely metabolized and eliminated. Bronchial tubes begin to relax and open, improving airflow to the lungs.",
      "isAchieved": true,
      "achievedAt": DateTime.now().subtract(const Duration(days: 41)),
      "tips": [
        "Practice deep breathing exercises to maximize lung capacity",
        "Notice easier breathing during physical activities",
        "Stay strong through any remaining withdrawal symptoms"
      ],
      "motivationalMessage":
          "Your body is now completely nicotine-free! The hardest part is behind you."
    },
    {
      "id": 6,
      "timeframe": "2 weeks",
      "title": "Circulation Improves Dramatically",
      "description":
          "Blood circulation improves significantly, and lung function increases by up to 30%.",
      "scientificExplanation":
          "Endothelial function improves as the vascular system recovers from chronic nicotine exposure. Lung function increases as cilia regrow and mucus clearance improves.",
      "isAchieved": true,
      "achievedAt": DateTime.now().subtract(const Duration(days: 30)),
      "tips": [
        "Engage in regular cardio exercise to boost circulation",
        "Notice improved stamina and reduced shortness of breath",
        "Your hands and feet should feel warmer"
      ],
      "motivationalMessage":
          "Your circulation is flowing freely, bringing life to every cell in your body!"
    },
    {
      "id": 7,
      "timeframe": "1 month",
      "title": "Lung Function Significantly Improves",
      "description":
          "Cilia in your lungs regrow, improving their ability to clean and reduce infection risk.",
      "scientificExplanation":
          "Ciliary function is restored, improving mucociliary clearance. This reduces the risk of respiratory infections and improves overall lung health and capacity.",
      "isAchieved": true,
      "achievedAt": DateTime.now().subtract(const Duration(days: 15)),
      "tips": [
        "Practice breathing exercises to strengthen lung capacity",
        "Notice reduced coughing and clearer breathing",
        "Avoid secondhand smoke to protect your healing lungs"
      ],
      "motivationalMessage":
          "Your lungs are cleaning themselves and getting stronger every day!"
    },
    {
      "id": 8,
      "timeframe": "3 months",
      "title": "Stroke Risk Reduces Substantially",
      "description":
          "Your risk of stroke decreases significantly as blood circulation continues to improve.",
      "scientificExplanation":
          "Continued improvement in endothelial function and reduced inflammation lead to better cerebrovascular health and significantly reduced stroke risk.",
      "isAchieved": false,
      "tips": [
        "Maintain a healthy diet low in sodium and saturated fats",
        "Stay physically active to support brain health",
        "Monitor blood pressure regularly"
      ],
      "motivationalMessage":
          "You're building a stronger, healthier brain with every smoke-free day!"
    },
    {
      "id": 9,
      "timeframe": "9 months",
      "title": "Lung Cilia Fully Regenerated",
      "description":
          "Lung cilia are fully regenerated, dramatically improving lung cleaning and reducing infection risk.",
      "scientificExplanation":
          "Complete regeneration of ciliary epithelium occurs, restoring normal mucociliary clearance and significantly reducing respiratory infection risk.",
      "isAchieved": false,
      "tips": [
        "Celebrate this major milestone in lung recovery",
        "Continue avoiding respiratory irritants",
        "Consider lung function testing to see improvements"
      ],
      "motivationalMessage":
          "Your lungs are now equipped with their full natural defense system!"
    },
    {
      "id": 10,
      "timeframe": "1 year",
      "title": "Heart Disease Risk Halved",
      "description":
          "Your risk of coronary heart disease is now half that of a continuing smoker.",
      "scientificExplanation":
          "Significant improvement in endothelial function, reduced inflammation, and normalized lipid profiles contribute to a 50% reduction in coronary heart disease risk.",
      "isAchieved": false,
      "tips": [
        "Celebrate this incredible achievement",
        "Continue heart-healthy lifestyle choices",
        "Share your success story to inspire others"
      ],
      "motivationalMessage":
          "You've cut your heart disease risk in half! Your heart thanks you every day."
    },
    {
      "id": 11,
      "timeframe": "5 years",
      "title": "Stroke Risk Equals Non-Smoker",
      "description":
          "Your risk of stroke is now the same as someone who has never smoked.",
      "scientificExplanation":
          "Complete vascular recovery occurs over 5 years, with stroke risk returning to baseline levels of never-smokers due to normalized endothelial function and reduced inflammation.",
      "isAchieved": false,
      "tips": [
        "Maintain your smoke-free lifestyle",
        "Continue regular health check-ups",
        "Be proud of this incredible health transformation"
      ],
      "motivationalMessage":
          "You've achieved the ultimate goal - your stroke risk is now that of a never-smoker!"
    },
    {
      "id": 12,
      "timeframe": "10 years",
      "title": "Lung Cancer Risk Halved",
      "description":
          "Your risk of lung cancer is now half that of a continuing smoker.",
      "scientificExplanation":
          "DNA repair mechanisms and cellular regeneration significantly reduce cancer risk. Pre-cancerous lesions may have resolved, and overall lung cancer risk approaches that of never-smokers.",
      "isAchieved": false,
      "tips": [
        "Continue regular cancer screenings",
        "Maintain a healthy lifestyle with antioxidant-rich foods",
        "Celebrate this monumental health achievement"
      ],
      "motivationalMessage":
          "A decade of healing has transformed your health - you've halved your cancer risk!"
    }
  ];

  int get _achievedCount =>
      _milestones.where((m) => m['isAchieved'] == true).length;
  double get _progressPercentage => (_achievedCount / _milestones.length) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Health Milestones'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshMilestones,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: Theme.of(context).colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMilestones,
        color: Theme.of(context).colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // Progress header
            SliverToBoxAdapter(
              child: ProgressHeaderWidget(
                progressPercentage: _progressPercentage,
                achievedCount: _achievedCount,
                totalCount: _milestones.length,
              ),
            ),
            // Timeline section header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'timeline',
                      color: Theme.of(context).colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Recovery Timeline',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Loading indicator
            if (_isLoading)
              SliverToBoxAdapter(
                child: Container(
                  height: 20.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            // Milestones list
            if (!_isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final milestone = _milestones[index];
                    final isAchieved = milestone['isAchieved'] ?? false;

                    return Column(
                      children: [
                        MilestoneCardWidget(
                          milestone: milestone,
                          isAchieved: isAchieved,
                          onTap: () =>
                              _showMilestoneDetail(milestone, isAchieved),
                          onLongPress: isAchieved
                              ? () => _showSharingOptions(milestone)
                              : null,
                        ),
                        // Timeline connector (except for last item)
                        if (index < _milestones.length - 1)
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            width: 2,
                            height: 3.h,
                            color: Theme.of(context).colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                      ],
                    );
                  },
                  childCount: _milestones.length,
                ),
              ),
            // Bottom spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shareProgress,
        icon: CustomIconWidget(
          iconName: 'share',
          color: Colors.white,
          size: 5.w,
        ),
        label: Text('Share Progress'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  Future<void> _refreshMilestones() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Check for newly achieved milestones based on quit date
    // In a real app, this would calculate based on actual quit date

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Milestones updated successfully!'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _showMilestoneDetail(Map<String, dynamic> milestone, bool isAchieved) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MilestoneDetailModal(
        milestone: milestone,
        isAchieved: isAchieved,
        onShare: () {
          Navigator.pop(context);
          _shareMilestone(milestone);
        },
      ),
    );
  }

  void _showSharingOptions(Map<String, dynamic> milestone) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Achievement',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Share to Social Media'),
              onTap: () {
                Navigator.pop(context);
                _shareMilestone(milestone);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'note_add',
                color: Theme.of(context).colorScheme.secondary,
                size: 6.w,
              ),
              title: Text('Add Personal Note'),
              onTap: () {
                Navigator.pop(context);
                _addPersonalNote(milestone);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _shareProgress() {
    final achievedMilestones =
        _milestones.where((m) => m['isAchieved'] == true).length;
    final progressText =
        "🎉 Health Update: I've achieved $achievedMilestones out of ${_milestones.length} health milestones on my smoke-free journey! "
        "${_progressPercentage.toInt()}% recovered and feeling amazing! 💪 #QuitSmoking #HealthJourney #SmokeFree";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Progress shared successfully!'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // In a real app, this would open the shared content
          },
        ),
      ),
    );
  }

  void _shareMilestone(Map<String, dynamic> milestone) {
    final shareText =
        "🎉 Milestone Achieved! ${milestone['title']} - ${milestone['timeframe']} smoke-free! "
        "${milestone['description']} #QuitSmoking #HealthMilestone #SmokeFree";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Milestone shared successfully!'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  void _addPersonalNote(Map<String, dynamic> milestone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Personal Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add a personal note about achieving: ${milestone['title']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'How did this milestone make you feel?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Personal note saved!'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
            child: Text('Save Note'),
          ),
        ],
      ),
    );
  }
}
