import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';

class GameItem {
  final int id;
  final String emoji;
  final String name;

  GameItem({required this.id, required this.emoji, required this.name});
}

class MemoryGameScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const MemoryGameScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  String _gameState = 'showing'; // 'showing', 'remembering', 'complete'
  List<GameItem> _showItems = [];
  List<int> _selectedItems = [];
  int _score = 0;
  int _showTime = 3;
  Timer? _showTimer;

  final List<GameItem> _gameItems = [
    GameItem(id: 1, emoji: "🍎", name: "Apple"),
    GameItem(id: 2, emoji: "🚗", name: "Car"),
    GameItem(id: 3, emoji: "⭐", name: "Star"),
    GameItem(id: 4, emoji: "🌸", name: "Flower"),
    GameItem(id: 5, emoji: "🎸", name: "Guitar"),
    GameItem(id: 6, emoji: "📚", name: "Book"),
    GameItem(id: 7, emoji: "🎯", name: "Target"),
    GameItem(id: 8, emoji: "🏠", name: "House"),
  ];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    // Pick 4 random items to show
    final shuffled = [..._gameItems]..shuffle();
    final selected = shuffled.take(4).toList();
    
    setState(() {
      _showItems = selected;
      _selectedItems = [];
      _score = 0;
      _gameState = 'showing';
      _showTime = 3;
    });

    // Start countdown timer
    _showTimer?.cancel();
    _showTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_showTime > 1) {
        setState(() => _showTime--);
      } else {
        setState(() => _gameState = 'remembering');
        timer.cancel();
      }
    });
  }

  void _handleItemSelect(int itemId) {
    if (_gameState != 'remembering') return;

    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _checkAnswer() {
    final correctIds = _showItems.map((item) => item.id).toList();
    final selectedIds = [..._selectedItems];

    // Check if completely correct
    final isCompletelyCorrect = correctIds.length == selectedIds.length &&
        correctIds.every((id) => selectedIds.contains(id));

    if (isCompletelyCorrect) {
      setState(() {
        _score = 100;
        _gameState = 'complete';
      });
      
      // Complete after showing success
      Future.delayed(Duration(milliseconds: 2000), () {
        widget.onComplete();
        Navigator.of(context).pop();
      });
    } else {
      // Calculate partial score
      int correctSelected = correctIds.where((id) => selectedIds.contains(id)).length;
      int incorrectSelected = selectedIds.where((id) => !correctIds.contains(id)).length;
      int partialScore = ((correctSelected * 25) - (incorrectSelected * 10)).clamp(0, 100);
      
      setState(() => _score = partialScore);
      
      // Show feedback briefly, then restart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Score: $partialScore%. Try again!'),
          backgroundColor: partialScore > 50 ? Colors.orange : Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      
      Future.delayed(Duration(milliseconds: 2000), () {
        if (mounted) _startGame();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Game', style: AppTextStyles.h3),
        backgroundColor: Colors.purple.shade500,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade400, Colors.purple.shade600],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Header
                Text(
                  _gameState == 'showing' 
                    ? 'Remember these items'
                    : _gameState == 'remembering'
                      ? 'Select the items you saw'
                      : 'Congratulations!',
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                // Show time or score
                if (_gameState == 'showing') ...[
                  Text(
                    '$_showTime',
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontSize: 72,
                    ),
                  ),
                  Text(
                    'seconds remaining',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ] else if (_gameState == 'complete') ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 48),
                        SizedBox(height: 8),
                        Text(
                          'Perfect!',
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        Text(
                          'You remembered all items correctly!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 32),

                // Game grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: _gameItems.length,
                    itemBuilder: (context, index) {
                      final item = _gameItems[index];
                      final isShowingItem = _showItems.contains(item);
                      final isSelected = _selectedItems.contains(item.id);
                      final shouldShow = _gameState == 'showing' && isShowingItem;
                      final isSelectable = _gameState == 'remembering';

                      return GestureDetector(
                        onTap: isSelectable ? () => _handleItemSelect(item.id) : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: shouldShow 
                              ? Colors.yellow.withOpacity(0.3)
                              : isSelected
                                ? Colors.white.withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: shouldShow 
                                ? Colors.yellow
                                : isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.emoji,
                                style: TextStyle(fontSize: 40),
                              ),
                              SizedBox(height: 8),
                              Text(
                                item.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
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

                SizedBox(height: 24),

                // Control buttons
                if (_gameState == 'remembering') ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Try Again',
                          onPressed: _startGame,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          textColor: Colors.purple.shade600,
                          icon: Icons.refresh,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Submit',
                          onPressed: _selectedItems.isNotEmpty ? _checkAnswer : null,
                          backgroundColor: Colors.white,
                          textColor: Colors.purple.shade600,
                          icon: Icons.check,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}