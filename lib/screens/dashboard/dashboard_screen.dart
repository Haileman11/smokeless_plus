import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/common/custom_button.dart';
import '../craving_sos/craving_sos_screen.dart';
import '../../widgets/celebration/confetti_animation.dart';
import '../../widgets/celebration/celebration_modal.dart';
import '../../models/user_profile.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _triggerConfetti = false;
  bool _showCelebration = false;
  String _selectedPeriod = '1week';
  
  final List<Map<String, dynamic>> _periods = [
    {'id': '1week', 'label': '1 Week', 'days': 7},
    {'id': '1month', 'label': '1 Month', 'days': 30}, 
    {'id': '1year', 'label': '1 Year', 'days': 365},
    {'id': '5years', 'label': '5 Years', 'days': 365 * 5},
    {'id': '10years', 'label': '10 Years', 'days': 365 * 10},
    {'id': '20years', 'label': '20 Years', 'days': 365 * 20},
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final localizations = AppLocalizations.of(context);
    
    if (appState.profile == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 64, color: AppColors.textMuted),
              SizedBox(height: 16),
              Text(
                localizations.completeProfile,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final stats = appState.getQuitStats();
    final isInFuture = stats['isInFuture'] ?? false;

    if (isInFuture) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 80, color: AppColors.primary),
                SizedBox(height: 24),
                Text(
                  localizations.quitJourneyBeginsSoon,
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  localizations.prepareForJourney,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Header
              Text(
                localizations.welcomeBack,
                style: AppTextStyles.h2,
              ),
              SizedBox(height: 8),
              Text(
                localizations.motivationalQuote,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 32),

              // Enhanced Main stats with React-style gradient
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${stats['days']} ${localizations.timeSmokeFreeDaysLabel}',
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontSize: 42,
                      ),
                    ),
                    Text(
                      localizations.timeSmokeFreeDays,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${stats['hours']} ${localizations.timeSmokeFreHours}',
                          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '${stats['minutes']} ${localizations.timeSmokeFreMinutes}',
                          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Enhanced Emergency CravingSOS Button
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red.shade50, Colors.red.shade100],
                  ),
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red.shade500,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.sos,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.emergency,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          Text(
                            'Having a craving? Get help right now.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showCravingSOS(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Help Me'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // React-style TimePeriodStats: Period Selector + Projected Benefits
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Return on Investment',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Period Selector Grid (2 rows x 3 cols)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _periods.length,
                    itemBuilder: (context, index) {
                      final period = _periods[index];
                      final isSelected = _selectedPeriod == period['id'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPeriod = period['id'];
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue.shade500 : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? Colors.blue.shade500 : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              period['label'],
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSelected ? Colors.white : Colors.grey.shade600,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  
                  // Projected Benefits Grid (4 cards)
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _buildProjectedStatsCards(appState.profile),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Enhanced Celebration button
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.green.shade50, Colors.green.shade100],
                  ),
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Celebrate Your Win!',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            'Share your amazing progress with others.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showCelebrationModal(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade500,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Celebrate'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Enhanced Insight with gradient
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.success.withOpacity(0.1),
                      AppColors.success.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.lightbulb_outline, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        appState.getPersonalizedInsight(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                ],
              ),
            ),
          ),
          
          // Confetti Animation Overlay
          ConfettiAnimation(
            trigger: _triggerConfetti,
            onComplete: () => setState(() => _triggerConfetti = false),
          ),
          
          // Celebration Modal
          if (_showCelebration)
            CelebrationModal(
              isOpen: _showCelebration,
              onClose: () => setState(() => _showCelebration = false),
              stats: stats,
              profile: {
                'currency': appState.profile?.currency ?? 'USD',
              },
            ),
        ],
      ),
    );
  }

  void _showCravingSOS() {
    showDialog(
      context: context,
      builder: (context) => CravingSOSScreen(
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
  
  void _showCelebrationModal() {
    setState(() {
      _triggerConfetti = true;
      _showCelebration = true;
    });
  }
  
  Widget _buildGradientStatCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradientColors,
    required Color iconColor,
    required Color textColor,
    required Color borderColor,
    String? testId,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue),
          child: Opacity(
            opacity: animationValue,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Add subtle feedback animation
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.15),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: textColor.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        value,
                        style: AppTextStyles.h2.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Map<String, dynamic> _calculateProjectedStats(int days, UserProfile? profile) {
    if (profile == null) {
      return {
        'cigsAvoided': 0,
        'moneySaved': '0.00',
        'lifeGained': '0m',
        'yearsGained': '+0.00',
        'currencySymbol': '\$'
      };
    }
    final cigsAvoided = days * profile.baselineCigsPerDay;
    final moneySaved = (cigsAvoided / profile.cigsPerPack) * profile.pricePerPack;
    final lifeGainedMinutes = cigsAvoided * profile.avgMinutesPerCig;
    
    // Format life gained as React does: "XdYhZm"
    final lifeGainedDays = (lifeGainedMinutes / (24 * 60)).floor();
    final remainingMinutes = lifeGainedMinutes % (24 * 60);
    final lifeGainedHours = (remainingMinutes / 60).floor();
    final lifeGainedMins = (remainingMinutes % 60).floor();
    
    String lifeGainedFormatted;
    if (lifeGainedDays > 0) {
      lifeGainedFormatted = '${lifeGainedDays}d ${lifeGainedHours}h ${lifeGainedMins}m';
    } else if (lifeGainedHours > 0) {
      lifeGainedFormatted = '${lifeGainedHours}h ${lifeGainedMins}m';
    } else {
      lifeGainedFormatted = '${lifeGainedMins}m';
    }
    
    // Years gained calculation like React
    final yearsGained = lifeGainedMinutes / (365.25 * 24 * 60);
    
    final currencySymbol = _getCurrencySymbol(profile.currency);
    
    return {
      'cigsAvoided': cigsAvoided,
      'moneySaved': moneySaved.toStringAsFixed(2),
      'lifeGained': lifeGainedFormatted,
      'yearsGained': '+${yearsGained.toStringAsFixed(2)}',
      'currencySymbol': currencySymbol
    };
  }
  
  String _getCurrencySymbol(String currency) {
    final symbols = {
      'USD': '\$', 'EUR': '€', 'GBP': '£', 'JPY': '¥',
      'CAD': 'C\$', 'AUD': 'A\$', 'CHF': 'CHF', 'CNY': '¥',
      'SEK': 'kr', 'NOK': 'kr', 'MXN': '\$', 'INR': '₹',
      'BRL': 'R\$', 'ZAR': 'R', 'KRW': '₩', 'SGD': 'S\$'
    };
    return symbols[currency] ?? currency;
  }
  
  List<Widget> _buildProjectedStatsCards(UserProfile? profile) {
    final selectedPeriodData = _periods.firstWhere(
      (p) => p['id'] == _selectedPeriod,
      orElse: () => _periods[0],
    );
    final projectedStats = _calculateProjectedStats(selectedPeriodData['days'], profile);
    
    return [
      _buildGradientStatCard(
        title: 'Money saved',
        value: '${projectedStats['currencySymbol']}${projectedStats['moneySaved']}',
        icon: Icons.attach_money,
        gradientColors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)], // React green-50 to green-100
        iconColor: Color(0xFF22C55E), // React green-500
        textColor: Color(0xFF15803D), // React green-700
        borderColor: Color(0xFFBBF7D0), // React green-200
        testId: 'projected-money-saved',
      ),
      _buildGradientStatCard(
        title: 'Cigarettes avoided',
        value: projectedStats['cigsAvoided'].toString(),
        icon: Icons.smoke_free,
        gradientColors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)], // React blue-50 to blue-100
        iconColor: Color(0xFF3B82F6), // React blue-500
        textColor: Color(0xFF1D4ED8), // React blue-700
        borderColor: Color(0xFFBFDBFE), // React blue-200
        testId: 'projected-cigs-avoided',
      ),
      _buildGradientStatCard(
        title: 'Life regained',
        value: projectedStats['lifeGained'],
        icon: Icons.access_time,
        gradientColors: [Color(0xFFFAF5FF), Color(0xFFF3E8FF)], // React purple-50 to purple-100
        iconColor: Color(0xFFA855F7), // React purple-500
        textColor: Color(0xFF7C3AED), // React purple-700
        borderColor: Color(0xFFD8B4FE), // React purple-200
        testId: 'projected-life-gained',
      ),
      _buildGradientStatCard(
        title: 'Years gained',
        value: projectedStats['yearsGained'],
        icon: Icons.favorite,
        gradientColors: [Color(0xFFFEF2F2), Color(0xFFFECECE)], // React red-50 to red-100
        iconColor: Color(0xFFEF4444), // React red-500
        textColor: Color(0xFFB91C1C), // React red-700
        borderColor: Color(0xFFFECACA), // React red-200
        testId: 'years-gained',
      ),
    ];
  }
}