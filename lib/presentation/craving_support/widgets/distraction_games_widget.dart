import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DistractionGamesWidget extends StatefulWidget {
  const DistractionGamesWidget({Key? key}) : super(key: key);

  @override
  State<DistractionGamesWidget> createState() => _DistractionGamesWidgetState();
}

class _DistractionGamesWidgetState extends State<DistractionGamesWidget> {
  int _selectedGameIndex = 0;

  final List<Map<String, dynamic>> _games = [
    {
      "id": 1,
      "name": "Color Focus",
      "description": "Find all items of a specific color around you",
      "icon": "palette",
      "duration": "2-5 minutes",
      "difficulty": "Easy"
    },
    {
      "id": 2,
      "name": "Counting Game",
      "description": "Count backwards from 100 by 7s",
      "icon": "calculate",
      "duration": "3-5 minutes",
      "difficulty": "Medium"
    },
    {
      "id": 3,
      "name": "Memory Palace",
      "description": "Visualize your childhood home room by room",
      "icon": "home",
      "duration": "5-10 minutes",
      "difficulty": "Easy"
    },
    {
      "id": 4,
      "name": "Word Association",
      "description": "Create a chain of related words",
      "icon": "psychology",
      "duration": "3-7 minutes",
      "difficulty": "Easy"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Distraction Games',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),

          // Game selection tabs
          Container(
            height: 6.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _games.length,
              itemBuilder: (context, index) {
                final game = _games[index];
                final isSelected = index == _selectedGameIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGameIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: game["icon"] as String,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          game["name"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Selected game content
          Expanded(
            child: _buildGameContent(_games[_selectedGameIndex]),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(Map<String, dynamic> game) {
    switch (game["id"] as int) {
      case 1:
        return _buildColorFocusGame();
      case 2:
        return _buildCountingGame();
      case 3:
        return _buildMemoryPalaceGame();
      case 4:
        return _buildWordAssociationGame();
      default:
        return Container();
    }
  }

  Widget _buildColorFocusGame() {
    final colors = [
      {'name': 'Red', 'color': Colors.red},
      {'name': 'Blue', 'color': Colors.blue},
      {'name': 'Green', 'color': Colors.green},
      {'name': 'Yellow', 'color': Colors.yellow},
      {'name': 'Purple', 'color': Colors.purple},
      {'name': 'Orange', 'color': Colors.orange},
    ];

    final randomColor = colors[Random().nextInt(colors.length)];

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'palette',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Color Focus Challenge',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (randomColor['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: randomColor['color'] as Color,
                width: 2,
              ),
            ),
            child: Text(
              'Find 5 ${randomColor['name']} objects around you',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Look around your environment and identify 5 objects that are ${randomColor['name'].toString().toLowerCase()}. Take your time and focus on each object.',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Refresh the game with a new color
              });
            },
            child: Text('New Color Challenge'),
          ),
        ],
      ),
    );
  }

  Widget _buildCountingGame() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'calculate',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Counting Challenge',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Count backwards from 100 by 7s',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            '100, 93, 86, 79, 72...',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondary,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'This mental math exercise requires focus and concentration, helping distract from cravings.',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Show hint
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hint: 100-7=93, 93-7=86, 86-7=79...'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  child: Text('Show Hint'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Start new challenge
                    setState(() {});
                  },
                  child: Text('New Challenge'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryPalaceGame() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'home',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Memory Palace',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Visualize your childhood home',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '1. Close your eyes and imagine walking through your childhood home\n\n2. Start at the front door and move room by room\n\n3. Notice details: colors, furniture, decorations\n\n4. Spend time in each room remembering specific objects\n\n5. Try to recall sounds, smells, and feelings',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Great job! Memory exercises strengthen focus and reduce cravings.'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: Text('Complete Exercise'),
          ),
        ],
      ),
    );
  }

  Widget _buildWordAssociationGame() {
    final startWords = [
      'Ocean',
      'Mountain',
      'Forest',
      'City',
      'Garden',
      'Library',
      'Kitchen',
      'Music'
    ];
    final randomWord = startWords[Random().nextInt(startWords.length)];

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'psychology',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Word Association',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Starting word:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  randomWord,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Create a chain of related words. Each new word should connect to the previous one.',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              'Example: Ocean → Water → Rain → Clouds → Sky → Birds → Freedom',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Generate new starting word
              });
            },
            child: Text('New Starting Word'),
          ),
        ],
      ),
    );
  }
}
