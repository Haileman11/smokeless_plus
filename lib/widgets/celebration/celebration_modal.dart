import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';

class ShareTemplate {
  final String id;
  final String title;
  final String text;

  ShareTemplate({required this.id, required this.title, required this.text});
}

class CelebrationModal extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final Map<String, dynamic> stats;
  final Map<String, dynamic>? profile;

  const CelebrationModal({
    Key? key,
    required this.isOpen,
    required this.onClose,
    required this.stats,
    this.profile,
  }) : super(key: key);

  @override
  _CelebrationModalState createState() => _CelebrationModalState();
}

class _CelebrationModalState extends State<CelebrationModal> {
  int _selectedTemplate = 0;

  String _getCurrencySymbol(String currency) {
    final symbols = {
      'USD': '\$', 'EUR': '€', 'GBP': '£', 'MAD': 'MAD', 'CAD': 'C\$',
      'AUD': 'A\$', 'JPY': '¥', 'CHF': 'CHF', 'CNY': '¥', 'SEK': 'kr',
      'NOK': 'kr', 'MXN': '\$', 'INR': '₹', 'BRL': 'R\$', 'ZAR': 'R'
    };
    return symbols[currency] ?? currency ?? '\$';
  }

  String _getFormattedTimeSmokeFree() {
    final days = widget.stats['days'] ?? 0;
    final hours = widget.stats['hours'] ?? 0;
    final minutes = widget.stats['minutes'] ?? 0;
    
    if (days > 0) {
      return '$days days, $hours hours';
    } else if (hours > 0) {
      return '$hours hours, $minutes minutes';
    } else {
      return '$minutes minutes';
    }
  }

  String _getFormattedMoneySaved() {
    final money = widget.stats['moneySaved'] ?? 0;
    return money.toStringAsFixed(2);
  }

  int _getCigsAvoided() {
    return widget.stats['cigsAvoided'] ?? 0;
  }

  int _getLifeRegainedHours() {
    final totalMinutes = (widget.stats['minutes'] ?? 0) + 
                        ((widget.stats['hours'] ?? 0) * 60) + 
                        ((widget.stats['days'] ?? 0) * 24 * 60);
    return (totalMinutes / 60).round();
  }

  List<ShareTemplate> _getShareTemplates() {
    final currencySymbol = _getCurrencySymbol(widget.profile?['currency'] ?? 'USD');
    final daysSinceQuit = widget.stats['daysSinceQuit'] ?? 0;
    
    return [
      ShareTemplate(
        id: 'achievement',
        title: '🏆 Achievement Unlock',
        text: '''🎉 SMOKE-FREE ACHIEVEMENT UNLOCKED! 🎉

⏰ Time smoke-free: ${_getFormattedTimeSmokeFree()}
💰 Money saved: $currencySymbol${_getFormattedMoneySaved()}
🚭 Cigarettes avoided: ${_getCigsAvoided()}

Every day without smoking is a victory! 💪

#SmokeFree #QuitSmoking #HealthJourney #Achievement #StrongerEveryDay''',
      ),
      ShareTemplate(
        id: 'milestone',
        title: '🚭 Smoke-Free Milestone',
        text: '''🌟 ${daysSinceQuit >= 7 ? 'ONE WEEK' : daysSinceQuit >= 1 ? 'DAY $daysSinceQuit' : 'DAY ONE'} SMOKE-FREE! 🌟

✅ ${_getFormattedTimeSmokeFree()} without a single cigarette
✅ Saved $currencySymbol${_getFormattedMoneySaved()} 
✅ Avoided ${_getCigsAvoided()} cigarettes
✅ ${_getLifeRegainedHours()} hours of life regained

The journey continues! 🚀

#SmokeFreeLife #HealthFirst #QuitSmoking #Milestone #Progress''',
      ),
      ShareTemplate(
        id: 'motivation',
        title: '💪 Motivation Share',
        text: '''🔥 QUITTING SMOKING UPDATE 🔥

Day $daysSinceQuit of being smoke-free and feeling incredible!

🎯 Progress so far:
• Time: ${_getFormattedTimeSmokeFree()}
• Money: $currencySymbol${_getFormattedMoneySaved()} saved
• Health: ${_getCigsAvoided()} cigarettes NOT smoked

To anyone thinking about quitting - YOU CAN DO THIS! 💚

#QuitSmoking #HealthJourney #SmokeFree #Motivation #YouCanDoIt''',
      ),
    ];
  }

  Future<void> _copyToClipboard() async {
    try {
      final templates = _getShareTemplates();
      final currentTemplate = templates[_selectedTemplate];
      
      await Clipboard.setData(ClipboardData(text: currentTemplate.text));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied! 📋 Your achievement text has been copied to clipboard!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copy failed - Please copy the text manually'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _shareToSocial(String platform) async {
    try {
      final templates = _getShareTemplates();
      final currentTemplate = templates[_selectedTemplate];
      final text = Uri.encodeComponent(currentTemplate.text);
      final currentUrl = Uri.encodeComponent('https://smokelessplus.app');
      
      String? url;
      switch (platform) {
        case 'twitter':
          url = 'https://twitter.com/intent/tweet?text=$text';
          break;
        case 'facebook':
          url = 'https://www.facebook.com/sharer/sharer.php?u=$currentUrl&quote=$text';
          break;
        case 'whatsapp':
          url = 'https://wa.me/?text=$text';
          break;
        case 'telegram':
          url = 'https://t.me/share/url?url=$currentUrl&text=$text';
          break;
      }

      if (url != null && await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sharing success! 🎉 Your achievement is being shared on $platform!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share to $platform'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return SizedBox.shrink();

    final templates = _getShareTemplates();
    final currentTemplate = templates[_selectedTemplate];
    final currencySymbol = _getCurrencySymbol(widget.profile?['currency'] ?? 'USD');

    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.orange, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Celebrate Your Achievement!',
                      style: AppTextStyles.h2,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Achievement Summary Card
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.shade500,
                      Colors.green.shade600,
                      Colors.teal.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      _getFormattedTimeSmokeFree(),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🚭 Smoke-Free!',
                      style: TextStyle(
                        color: Colors.green.shade100,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 1,
                      color: Colors.green.shade400,
                      margin: EdgeInsets.symmetric(vertical: 8),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '$currencySymbol${_getFormattedMoneySaved()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Money Saved',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade100,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.green.shade400,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '${_getCigsAvoided()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Cigarettes Avoided',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Template Selector
              Text(
                'Choose your sharing style:',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Row(
                children: List.generate(templates.length, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < templates.length - 1 ? 8 : 0),
                      child: OutlinedButton(
                        onPressed: () => setState(() => _selectedTemplate = index),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _selectedTemplate == index 
                            ? AppColors.primary
                            : null,
                          foregroundColor: _selectedTemplate == index 
                            ? Colors.white
                            : AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        ),
                        child: Text(
                          templates[index].title,
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 24),

              // Preview
              Text(
                'Preview:',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  currentTemplate.text,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: Icon(Icons.copy, size: 18),
                      label: Text('Copy'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _shareToSocial('twitter'),
                      icon: Icon(Icons.share, size: 18),
                      label: Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Social sharing options
              Text(
                'Share on social media:',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton('Twitter', Icons.alternate_email, () => _shareToSocial('twitter'), Colors.blue),
                  _buildSocialButton('Facebook', Icons.facebook, () => _shareToSocial('facebook'), Colors.blue.shade800),
                  _buildSocialButton('WhatsApp', Icons.chat, () => _shareToSocial('whatsapp'), Colors.green),
                  _buildSocialButton('Telegram', Icons.send, () => _shareToSocial('telegram'), Colors.blue.shade600),
                ],
              ),

              SizedBox(height: 16),

              // Close button
              OutlinedButton(
                onPressed: widget.onClose,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, VoidCallback onPressed, Color color) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: color.withOpacity(0.1),
            foregroundColor: color,
            padding: EdgeInsets.all(12),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}