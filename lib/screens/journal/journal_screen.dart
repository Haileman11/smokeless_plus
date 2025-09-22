import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smokeless_plus/services/theme_service.dart';
import '../../services/app_state.dart';
import '../../models/journal_entry.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';

class JournalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final localizations = AppLocalizations.of(context);
final themeService = Provider.of<ThemeService>(context);
    final textColor = themeService.isDarkMode ? AppColors.background : AppColors.textPrimary;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     localizations.journalTitle,
      //     style: AppTextStyles.h3.copyWith(color: textColor),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   foregroundColor: AppColors.textPrimary,
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add entry button
            CustomButton(
              text: localizations.addEntry,
              icon: Icons.add,
              onPressed: () => _showAddEntryDialog(context),
              isLarge: true,
            ),
            SizedBox(height: 24),

            // Recent entries
            if (appState.journalEntries.isEmpty)
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Icon(Icons.book_outlined, size: 64, color: AppColors.textMuted),
                    SizedBox(height: 16),
                    Text(
                      'No journal entries yet',
                      style: AppTextStyles.h4.copyWith(color: AppColors.textMuted),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start writing your quit journey!',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else ...[
              Text(
                localizations.recentEntries,
                style: AppTextStyles.h3,
              ),
              SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: appState.journalEntries.length,
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final entry = appState.journalEntries[index];
                  return _buildJournalEntryCard(entry, localizations);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJournalEntryCard(JournalEntry entry, AppLocalizations localizations) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (entry.mood != null) ...[
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getMoodColor(entry.mood!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getMoodEmoji(entry.mood!),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  _getLocalizedMood(localizations, entry.mood!),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _getMoodColor(entry.mood!),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
              ],
              Text(
                _formatDate(entry.date),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          if (entry.mood != null) SizedBox(height: 12),
          if (entry.notes.isNotEmpty)
            Text(
              entry.notes,
              style: AppTextStyles.bodyMedium,
            ),
        ],
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    final notesController = TextEditingController();
    final localizations = AppLocalizations.of(context);
    MoodType? selectedMood;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(localizations.addEntry),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.howAreYouFeeling,
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: MoodType.values.map((mood) {
                    final isSelected = selectedMood == mood;
                    return GestureDetector(
                      onTap: () => setState(() => selectedMood = mood),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? _getMoodColor(mood).withOpacity(0.2)
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? _getMoodColor(mood) : AppColors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_getMoodEmoji(mood), style: TextStyle(fontSize: 16)),
                            SizedBox(width: 4),
                            Text(
                              _getLocalizedMood(localizations, mood),
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected ? _getMoodColor(mood) : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: localizations.writeYourThoughts,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (notesController.text.isNotEmpty || selectedMood != null) {
                  final appState = Provider.of<AppState>(context, listen: false);
                  await appState.addJournalEntry(
                    selectedMood,
                    notesController.text,
                    DateTime.now(),
                  );
                  
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.entrySaved),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: Text(localizations.save),
            ),
          ],
        ),
      ),
    );
  }

  String _getMoodEmoji(MoodType mood) {
    switch (mood) {
      case MoodType.terrible:
        return '😞';
      case MoodType.bad:
        return '😔';
      case MoodType.okay:
        return '😐';
      case MoodType.good:
        return '😊';
      case MoodType.great:
        return '😄';
    }
  }

  Color _getMoodColor(MoodType mood) {
    switch (mood) {
      case MoodType.terrible:
        return Colors.red;
      case MoodType.bad:
        return Colors.orange;
      case MoodType.okay:
        return Colors.grey;
      case MoodType.good:
        return Colors.blue;
      case MoodType.great:
        return Colors.green;
    }
  }

  String _getLocalizedMood(AppLocalizations localizations, MoodType mood) {
    switch (mood) {
      case MoodType.terrible:
        return localizations.moodTerrible;
      case MoodType.bad:
        return localizations.moodBad;
      case MoodType.okay:
        return localizations.moodOkay;
      case MoodType.good:
        return localizations.moodGood;
      case MoodType.great:
        return localizations.moodGreat;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}