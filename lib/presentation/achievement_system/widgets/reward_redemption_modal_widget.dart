import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RewardRedemptionModalWidget extends StatefulWidget {
  final int availablePoints;

  const RewardRedemptionModalWidget({
    Key? key,
    required this.availablePoints,
  }) : super(key: key);

  @override
  State<RewardRedemptionModalWidget> createState() =>
      _RewardRedemptionModalWidgetState();
}

class _RewardRedemptionModalWidgetState
    extends State<RewardRedemptionModalWidget> {
  final List<Map<String, dynamic>> rewards = [
    {
      'id': 1,
      'title': 'Premium Motivational Content',
      'description':
          'Access exclusive daily motivational quotes and success stories',
      'points': 500,
      'icon': 'auto_stories',
      'available': true,
    },
    {
      'id': 2,
      'title': 'Ocean Theme',
      'description': 'Beautiful ocean-themed app interface with calming colors',
      'points': 750,
      'icon': 'palette',
      'available': true,
    },
    {
      'id': 3,
      'title': 'Forest Theme',
      'description': 'Nature-inspired green theme for a refreshing experience',
      'points': 750,
      'icon': 'park',
      'available': true,
    },
    {
      'id': 4,
      'title': 'Charity Donation',
      'description': 'Donate \$5 to lung cancer research in your name',
      'points': 1000,
      'icon': 'favorite',
      'available': true,
    },
    {
      'id': 5,
      'title': 'Advanced Statistics',
      'description': 'Unlock detailed health analytics and progress insights',
      'points': 1200,
      'icon': 'analytics',
      'available': true,
    },
    {
      'id': 6,
      'title': 'Personal Coach Session',
      'description': '30-minute virtual session with a certified quit coach',
      'points': 2000,
      'icon': 'support_agent',
      'available': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reward Store',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'stars',
                            color: Theme.of(context).colorScheme.secondary,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${widget.availablePoints} pts',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Redeem your hard-earned points for exclusive rewards and support your quit journey!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Rewards List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                final reward = rewards[index];
                final bool canAfford =
                    widget.availablePoints >= (reward['points'] as int);

                return Container(
                  margin: EdgeInsets.only(bottom: 3.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: canAfford
                          ? Theme.of(context).colorScheme.primary
                              .withValues(alpha: 0.3)
                          : Theme.of(context).colorScheme.outline
                              .withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: canAfford
                            ? Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Reward Icon
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: canAfford
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: reward['icon'] ?? 'card_giftcard',
                          color: canAfford
                              ? Colors.white
                              : Colors.grey.withValues(alpha: 0.5),
                          size: 7.w,
                        ),
                      ),
                      SizedBox(width: 4.w),

                      // Reward Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward['title'] ?? 'Reward',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                color: canAfford
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              reward['description'] ??
                                  'No description available.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                color: canAfford
                                    ? Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.7)
                                    : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: canAfford
                                        ? AppTheme
                                            .lightTheme.colorScheme.secondary
                                            .withValues(alpha: 0.1)
                                        : Colors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${reward['points']} pts',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: canAfford
                                          ? AppTheme
                                              .lightTheme.colorScheme.secondary
                                          : Colors.grey.withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: canAfford
                                      ? () {
                                          _showRedeemConfirmation(
                                              context, reward);
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: canAfford
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.withValues(alpha: 0.3),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 1.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    canAfford ? 'Redeem' : 'Locked',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRedeemConfirmation(
      BuildContext context, Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirm Redemption',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to redeem "${reward['title']}" for ${reward['points']} points?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: Theme.of(context).colorScheme.secondary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'You will have ${widget.availablePoints - (reward['points'] as int)} points remaining.',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
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
                Navigator.pop(context);
                _showRedemptionSuccess(context, reward);
              },
              child: Text('Redeem'),
            ),
          ],
        );
      },
    );
  }

  void _showRedemptionSuccess(
      BuildContext context, Map<String, dynamic> reward) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 10.w,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Reward Redeemed!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'You have successfully redeemed "${reward['title']}". Check your profile for details.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Great!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
