import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/models/game.dart';

import '../../../core/app_export.dart';

class DistractionGamesWidget extends StatefulWidget {
  const DistractionGamesWidget({Key? key}) : super(key: key);

  @override
  State<DistractionGamesWidget> createState() => _DistractionGamesWidgetState();
}

class _DistractionGamesWidgetState extends State<DistractionGamesWidget> {
  int _selectedGameIndex = 0;
  late final List<Game> _games;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _games = [
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
  ].map((e) => Game.fromJson(e)).toList();
}
  

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Distraction Games',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),

          // Game selection tabs
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w,),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _games.asMap().entries.map((entry) {
                      final index = entry.key;
                      final game = entry.value;
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
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: game.icon,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                game.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.onPrimary
                                          : Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
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

  Widget _buildGameContent(Game game) {
    switch (game.id) {
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
        color: Theme.of(context).colorScheme.surface,
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
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            AppLocalizations.of(context)!.colorFocusChallenge,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
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
              AppLocalizations.of(context)!.findFiveObjects(randomColor['name'] as String),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            AppLocalizations.of(context)!.lookAroundAndIdentifyFiveObjects(randomColor['name'] as String),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
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
            child: Text(AppLocalizations.of(context)!.newColorChallenge),
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
        color: Theme.of(context).colorScheme.surface,
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
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            AppLocalizations.of(context)!.countingChallenge,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              AppLocalizations.of(context)!.countingChallenge,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            '100, 93, 86, 79, 72...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w300,
                ),
          ),
          SizedBox(height: 2.h),
          Text(
            AppLocalizations.of(context)!.countingGameDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
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
                  child: Text(AppLocalizations.of(context)!.showHint),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Start new challenge
                    setState(() {});
                  },
                  child: Text(AppLocalizations.of(context)!.newChallenge),
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
        color: Theme.of(context).colorScheme.surface,
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
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            AppLocalizations.of(context)!.memoryPalace,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              AppLocalizations.of(context)!.visualizeChildhoodHome,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
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
                    AppLocalizations.of(context)!.instructions,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    AppLocalizations.of(context)!.memoryPalaceInstructions,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
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
                      AppLocalizations.of(context)!.memoryPalaceCompletionMessage),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.completeExercise),
          ),
        ],
      ),
    );
  }

  Widget _buildWordAssociationGame() {
    final startWords = [
      AppLocalizations.of(context)!.ocean,
      AppLocalizations.of(context)!.mountain,
      AppLocalizations.of(context)!.forest,
      AppLocalizations.of(context)!.city,
      AppLocalizations.of(context)!.garden,
      AppLocalizations.of(context)!.library,
      AppLocalizations.of(context)!.kitchen,
      AppLocalizations.of(context)!.music,
    ];
    final randomWord = startWords[Random().nextInt(startWords.length)];

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            AppLocalizations.of(context)!.wordAssociation,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.startingWord,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  randomWord,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            AppLocalizations.of(context)!.wordAssociationInstructions,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.wordAssociationExample,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
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
            child: Text(AppLocalizations.of(context)!.newStartingWord),
          ),
        ],
      ),
    );
  }
}
