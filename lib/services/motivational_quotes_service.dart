import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

/// Service for managing daily motivational quotes with automatic refresh
class MotivationalQuotesService {
  static const String _keyCurrentQuoteIndex = 'current_quote_index';
  static const String _keyLastQuoteUpdate = 'last_quote_update';
  static const String _keyMorningQuoteIndex = 'morning_quote_index';
  static const String _keyEveningQuoteIndex = 'evening_quote_index';
  static const String _keyLastMorningUpdate = 'last_morning_update';
  static const String _keyLastEveningUpdate = 'last_evening_update';

  // Comprehensive collection of motivational quotes for quitting smoking
  static const List<Map<String, String>> _motivationalQuotes = [
    // Health & Recovery Quotes
    {
      "message":
          "Every smoke-free breath is a victory celebration in your lungs. Your body is healing with each passing moment.",
      "author": "Dr. Sarah Williams"
    },
    {
      "message":
          "Your heart is beating stronger today than it was yesterday. Every day smoke-free is a gift to your cardiovascular system.",
      "author": "Cardiologist Dr. James Lee"
    },
    {
      "message":
          "The oxygen in your blood is increasing, your circulation is improving, and your energy levels are soaring.",
      "author": "Health Coach Maria"
    },
    {
      "message":
          "Your taste buds are awakening to flavors you haven't experienced in years. Life is becoming more vivid.",
      "author": "Wellness Expert John"
    },
    {
      "message":
          "Every cough that subsides, every deep breath that feels clearer - your lungs are thanking you for this decision.",
      "author": "Pulmonologist Dr. Chen"
    },
    {
      "message":
          "Your immune system is strengthening every day. You're building a fortress of health around yourself.",
      "author": "Dr. Michael Roberts"
    },
    {
      "message":
          "The nicotine is leaving your system, making room for natural energy and genuine vitality to return.",
      "author": "Addiction Specialist Dr. Taylor"
    },
    {
      "message":
          "Your skin is regaining its natural glow, your complexion improving with each smoke-free day.",
      "author": "Dermatologist Dr. Kim"
    },
    {
      "message":
          "Sleep is becoming more restful, dreams more vivid, and mornings more energetic. Your body is healing overnight.",
      "author": "Sleep Specialist Dr. Brown"
    },
    {
      "message":
          "Your blood pressure is stabilizing, your pulse is becoming steady. Your heart is finding its natural rhythm.",
      "author": "Dr. Patricia Davis"
    },

    // Strength & Willpower Quotes
    {
      "message":
          "You are stronger than your cravings. Every time you resist, your willpower muscle grows more powerful.",
      "author": "Life Coach Amanda"
    },
    {
      "message":
          "Cravings are temporary visitors - they come, they peak, and they always leave. You are the permanent resident of your life.",
      "author": "Mindfulness Expert David"
    },
    {
      "message":
          "Each 'no' to a cigarette is a 'yes' to your future self. You're making deposits in the bank of your health.",
      "author": "Motivational Speaker Lisa"
    },
    {
      "message":
          "The urge to smoke lasts minutes, but your decision to quit will last a lifetime. Choose the permanent over the temporary.",
      "author": "Recovery Coach Mark"
    },
    {
      "message":
          "You've already proven you can go hours without smoking. Now you're proving you can go days, weeks, and years.",
      "author": "Therapist Dr. Wilson"
    },
    {
      "message":
          "Every challenging moment you overcome makes you more resilient. You're building unshakeable inner strength.",
      "author": "Resilience Coach Sara"
    },
    {
      "message":
          "The part of you that wanted to quit is stronger than the part that wanted to smoke. Trust your deeper wisdom.",
      "author": "Counselor Dr. Martinez"
    },
    {
      "message":
          "You're not giving up something - you're gaining everything: health, money, time, and self-respect.",
      "author": "Success Coach Jennifer"
    },
    {
      "message":
          "Breaking free from addiction is the ultimate act of self-love. You deserve this freedom.",
      "author": "Self-Care Expert Rachel"
    },
    {
      "message":
          "Every smoke-free moment is proof of your incredible willpower. You are more powerful than you know.",
      "author": "Empowerment Coach Mike"
    },

    // Financial & Practical Benefits
    {
      "message":
          "The money staying in your wallet is earning interest in your health account. This is the best investment you'll ever make.",
      "author": "Financial Wellness Expert Tom"
    },
    {
      "message":
          "Calculate not just the money saved, but the priceless gift of time you're adding to your life.",
      "author": "Life Planner Susan"
    },
    {
      "message":
          "Every dollar not spent on cigarettes is a dollar invested in your dreams and future goals.",
      "author": "Investment Advisor Carol"
    },
    {
      "message":
          "The money you're saving could fund a vacation, a hobby, or a dream you've put on hold. Your future self will thank you.",
      "author": "Budget Coach Daniel"
    },
    {
      "message":
          "Freedom isn't free, but quitting smoking is the one freedom that actually saves you money while saving your life.",
      "author": "Freedom Fighter Alex"
    },
    {
      "message":
          "Your bank account is growing while your health risks are shrinking. That's what I call a win-win situation.",
      "author": "Wellness Financial Planner Beth"
    },
    {
      "message":
          "Think of all the beautiful experiences you can buy with the money you're no longer burning away.",
      "author": "Experience Designer Maya"
    },
    {
      "message":
          "Every cigarette not bought is money earned. Every smoke-free day is profit for your future.",
      "author": "Entrepreneur Coach Steve"
    },
    {
      "message":
          "The compound interest on your health and wealth starts accumulating from the moment you quit.",
      "author": "Lifestyle Investment Expert Kim"
    },
    {
      "message":
          "You're not just saving money - you're investing in decades of additional earning potential by staying healthy.",
      "author": "Career Strategist Linda"
    },

    // Time & Life Extension Quotes
    {
      "message":
          "Every day smoke-free adds approximately 2 hours to your life expectancy. You're literally buying yourself time.",
      "author": "Longevity Expert Dr. Adams"
    },
    {
      "message":
          "Time is the most precious currency, and quitting smoking is your way of earning more of it.",
      "author": "Time Management Coach Paul"
    },
    {
      "message":
          "You're not just extending your life - you're improving the quality of every year, month, and day you have left.",
      "author": "Quality of Life Specialist Dr. Green"
    },
    {
      "message":
          "Imagine all the grandchildren's birthdays, sunsets, and adventures you'll experience because you chose to quit.",
      "author": "Life Coach Melissa"
    },
    {
      "message":
          "Each smoke-free day is like adding pages to the book of your life story. Make them beautiful chapters.",
      "author": "Life Story Coach Emma"
    },
    {
      "message":
          "You're giving yourself the gift of being present for life's most precious moments.",
      "author": "Mindfulness Teacher Robert"
    },
    {
      "message":
          "The minutes you're not spending smoking can now be spent living, loving, and creating memories.",
      "author": "Memory Coach Diana"
    },
    {
      "message":
          "Your life timeline just got extended. Use this bonus time to chase dreams and build legacies.",
      "author": "Legacy Coach Brian"
    },
    {
      "message":
          "Every smoke-free breath is a moment reclaimed from the past and invested in your future.",
      "author": "Future Self Coach Hannah"
    },
    {
      "message":
          "You're not just living longer - you're living stronger, healthier, and with more vitality in every moment.",
      "author": "Vitality Expert Dr. Foster"
    },

    // Family & Relationships
    {
      "message":
          "Your family breathes easier knowing you're smoke-free. You're giving them the gift of your longevity.",
      "author": "Family Therapist Dr. Johnson"
    },
    {
      "message":
          "The best inheritance you can leave your children is the example of choosing health over addiction.",
      "author": "Parenting Expert Dr. White"
    },
    {
      "message":
          "Your loved ones no longer worry about losing you to smoking-related illness. That peace of mind is priceless.",
      "author": "Relationship Counselor Janet"
    },
    {
      "message":
          "Every hug is cleaner, every kiss is sweeter, every moment together is no longer clouded by smoke.",
      "author": "Love Coach Patricia"
    },
    {
      "message":
          "You're modeling strength and self-care for everyone who looks up to you.",
      "author": "Role Model Coach Anthony"
    },
    {
      "message":
          "The people who love you are celebrating your decision to choose life, health, and presence.",
      "author": "Celebration Coach Monica"
    },
    {
      "message":
          "Your smoke-free home is now a sanctuary of clean air and healthy living for everyone in it.",
      "author": "Home Wellness Expert Tracy"
    },
    {
      "message":
          "You're giving your children and grandchildren the gift of fresh air and a healthy role model.",
      "author": "Children's Health Advocate Dr. Lopez"
    },
    {
      "message":
          "Every family gathering is now free from the separation that smoking used to create.",
      "author": "Family Unity Coach Richard"
    },
    {
      "message":
          "The love in your life multiplies when you choose to love yourself enough to quit smoking.",
      "author": "Self-Love Coach Vanessa"
    },

    // Personal Achievement & Pride
    {
      "message":
          "You've just conquered one of the most challenging addictions. If you can do this, you can do anything.",
      "author": "Achievement Coach Tyler"
    },
    {
      "message":
          "This is your personal Mount Everest, and you're climbing it one smoke-free day at a time.",
      "author": "Personal Challenge Coach Rosa"
    },
    {
      "message":
          "You've graduated from addiction to freedom. Wear this accomplishment with pride.",
      "author": "Pride Coach Kenneth"
    },
    {
      "message":
          "Every person you inspire with your quit story multiplies the impact of your brave decision.",
      "author": "Inspiration Speaker Dr. Clark"
    },
    {
      "message":
          "You've proven that you have the strength to change your life. What other dreams will you conquer next?",
      "author": "Dream Achievement Coach Sophia"
    },
    {
      "message":
          "This victory over smoking is evidence of your incredible capacity for positive transformation.",
      "author": "Transformation Coach Gregory"
    },
    {
      "message":
          "You're not the same person who used to smoke. You've evolved into someone stronger and healthier.",
      "author": "Evolution Coach Miranda"
    },
    {
      "message":
          "Your success story is being written with every smoke-free choice. Make it a bestseller.",
      "author": "Success Story Coach Nathan"
    },
    {
      "message":
          "The discipline you've developed in quitting smoking will serve you well in every area of life.",
      "author": "Discipline Coach Oliver"
    },
    {
      "message":
          "You've broken free from chains that held millions captive. You are now truly free.",
      "author": "Freedom Coach Isabella"
    },

    // Motivation for Difficult Moments
    {
      "message":
          "Cravings are like ocean waves - they build, peak, and then always crash down. Ride them out.",
      "author": "Craving Management Expert Dr. Stone"
    },
    {
      "message":
          "This moment of difficulty will pass, but your quit will last forever if you don't give up.",
      "author": "Persistence Coach Frank"
    },
    {
      "message":
          "The urge you're feeling right now is addiction's last desperate attempt to control you. You're stronger.",
      "author": "Addiction Recovery Specialist Dr. Reed"
    },
    {
      "message":
          "Every craving you survive makes the next one weaker. You're wearing down the addiction, not the other way around.",
      "author": "Resilience Training Coach Julie"
    },
    {
      "message":
          "What feels unbearable right now felt the same way yesterday, and you made it through. You can do it again.",
      "author": "Endurance Coach Marcus"
    },
    {
      "message":
          "The discomfort you feel is temporary, but the regret of giving up would be permanent.",
      "author": "Regret Prevention Coach Zoe"
    },
    {
      "message":
          "You've survived 100% of your worst cravings so far. Your track record is perfect.",
      "author": "Survival Statistics Coach Ian"
    },
    {
      "message":
          "This challenging moment is actually your strength training session. Each rep makes you stronger.",
      "author": "Mental Strength Coach Ruby"
    },
    {
      "message":
          "The part of you that wants to smoke is shrinking while the part that wants to stay quit is growing.",
      "author": "Inner Strength Coach Felix"
    },
    {
      "message":
          "Breathe through this craving. On the other side is pride, health, and continued freedom.",
      "author": "Breathing Coach Penelope"
    },

    // Long-term Vision & Future Self
    {
      "message":
          "Your 80-year-old self is thanking you right now for the decision to quit smoking today.",
      "author": "Future Self Coach Dr. Parker"
    },
    {
      "message":
          "Imagine running up stairs without breathing hard, tasting food fully, and sleeping deeply. This is your new reality.",
      "author": "New Reality Coach Samantha"
    },
    {
      "message":
          "The person you're becoming is someone who chooses health, values life, and honors their body.",
      "author": "Identity Coach Vincent"
    },
    {
      "message":
          "Years from now, this quit date will be one of the most important dates in your life story.",
      "author": "Life Story Date Coach Gabrielle"
    },
    {
      "message":
          "You're not just changing a habit - you're changing your entire life trajectory toward health and happiness.",
      "author": "Life Trajectory Coach Jordan"
    },
    {
      "message":
          "The compound benefits of quitting smoking will be felt for decades to come. This is long-term thinking at its best.",
      "author": "Long-term Benefits Coach Ethan"
    },
    {
      "message":
          "Your future adventures, relationships, and achievements are all made possible by this brave decision to quit.",
      "author": "Future Adventures Coach Crystal"
    },
    {
      "message":
          "The legacy you're creating is one of strength, wisdom, and the courage to change when change is needed.",
      "author": "Legacy Creation Coach Derek"
    },
    {
      "message":
          "Every smoke-free day is a building block in the foundation of your healthiest, happiest life.",
      "author": "Life Foundation Coach Amber"
    },
    {
      "message":
          "You're creating a future where smoking is just a memory, and health and vitality are your daily reality.",
      "author": "Future Creation Coach Phoenix"
    },
  ];

  /// Get a quote that refreshes automatically 2 times per day (morning and evening)
  static Future<Map<String, String>> getDailyMotivationalQuote() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    // Determine if it's morning (6 AM - 6 PM) or evening (6 PM - 6 AM)
    final isMorning = now.hour >= 6 && now.hour < 18;

    if (isMorning) {
      return await _getMorningQuote(prefs, now);
    } else {
      return await _getEveningQuote(prefs, now);
    }
  }

  /// Get morning motivational quote (refreshes at 6 AM)
  static Future<Map<String, String>> _getMorningQuote(
      SharedPreferences prefs, DateTime now) async {
    final lastMorningUpdate = prefs.getString(_keyLastMorningUpdate);
    final morningQuoteIndex = prefs.getInt(_keyMorningQuoteIndex) ?? 0;

    // Check if we need to refresh the morning quote (new day after 6 AM)
    bool shouldRefresh = false;

    if (lastMorningUpdate == null) {
      shouldRefresh = true;
    } else {
      final lastUpdate = DateTime.parse(lastMorningUpdate);
      final today6AM = DateTime(now.year, now.month, now.day, 6, 0);
      final lastUpdate6AM =
          DateTime(lastUpdate.year, lastUpdate.month, lastUpdate.day, 6, 0);

      // Refresh if we've passed 6 AM on a new day
      shouldRefresh = now.isAfter(today6AM) && today6AM.isAfter(lastUpdate6AM);
    }

    int quoteIndex = morningQuoteIndex;

    if (shouldRefresh) {
      // Generate a new morning quote index
      quoteIndex =
          _generateNewQuoteIndex(morningQuoteIndex, _motivationalQuotes.length);

      // Save the new quote index and update time
      await prefs.setInt(_keyMorningQuoteIndex, quoteIndex);
      await prefs.setString(_keyLastMorningUpdate, now.toIso8601String());
    }

    return _motivationalQuotes[quoteIndex];
  }

  /// Get evening motivational quote (refreshes at 6 PM)
  static Future<Map<String, String>> _getEveningQuote(
      SharedPreferences prefs, DateTime now) async {
    final lastEveningUpdate = prefs.getString(_keyLastEveningUpdate);
    final eveningQuoteIndex = prefs.getInt(_keyEveningQuoteIndex) ??
        1; // Start with different quote than morning

    // Check if we need to refresh the evening quote (new day after 6 PM or first time)
    bool shouldRefresh = false;

    if (lastEveningUpdate == null) {
      shouldRefresh = true;
    } else {
      final lastUpdate = DateTime.parse(lastEveningUpdate);

      // For evening, we check if it's after 6 PM and we haven't updated today
      if (now.hour >= 18) {
        final today6PM = DateTime(now.year, now.month, now.day, 18, 0);
        final lastUpdateDate =
            DateTime(lastUpdate.year, lastUpdate.month, lastUpdate.day);
        final todayDate = DateTime(now.year, now.month, now.day);

        shouldRefresh =
            todayDate.isAfter(lastUpdateDate) && now.isAfter(today6PM);
      }
    }

    int quoteIndex = eveningQuoteIndex;

    if (shouldRefresh) {
      // Generate a new evening quote index (different from morning)
      final morningIndex = prefs.getInt(_keyMorningQuoteIndex) ?? 0;
      quoteIndex = _generateNewQuoteIndex(
          eveningQuoteIndex, _motivationalQuotes.length,
          avoidIndex: morningIndex);

      // Save the new quote index and update time
      await prefs.setInt(_keyEveningQuoteIndex, quoteIndex);
      await prefs.setString(_keyLastEveningUpdate, now.toIso8601String());
    }

    return _motivationalQuotes[quoteIndex];
  }

  /// Generate a new quote index, ensuring it's different from the previous one
  static int _generateNewQuoteIndex(int previousIndex, int totalQuotes,
      {int? avoidIndex}) {
    final random = Random();
    int newIndex;

    // Ensure we don't get the same quote as before
    do {
      newIndex = random.nextInt(totalQuotes);
    } while (newIndex == previousIndex ||
        (avoidIndex != null && newIndex == avoidIndex));

    return newIndex;
  }

  /// Get a random motivational quote (for immediate refresh or special occasions)
  static Map<String, String> getRandomQuote() {
    final random = Random();
    final index = random.nextInt(_motivationalQuotes.length);
    return _motivationalQuotes[index];
  }

  /// Get quote by category for specific situations
  static List<Map<String, String>> getQuotesByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return _motivationalQuotes
            .where((quote) =>
                quote['author']!.contains('Dr.') ||
                quote['message']!.contains('health') ||
                quote['message']!.contains('lung') ||
                quote['message']!.contains('heart'))
            .toList();

      case 'strength':
        return _motivationalQuotes
            .where((quote) =>
                quote['message']!.contains('strong') ||
                quote['message']!.contains('willpower') ||
                quote['message']!.contains('strength'))
            .toList();

      case 'financial':
        return _motivationalQuotes
            .where((quote) =>
                quote['message']!.contains('money') ||
                quote['message']!.contains('dollar') ||
                quote['message']!.contains('save') ||
                quote['message']!.contains('invest'))
            .toList();

      case 'craving':
        return _motivationalQuotes
            .where((quote) =>
                quote['message']!.contains('craving') ||
                quote['message']!.contains('urge') ||
                quote['message']!.contains('difficult') ||
                quote['message']!.contains('moment'))
            .toList();

      case 'family':
        return _motivationalQuotes
            .where((quote) =>
                quote['message']!.contains('family') ||
                quote['message']!.contains('children') ||
                quote['message']!.contains('loved') ||
                quote['message']!.contains('hug'))
            .toList();

      default:
        return _motivationalQuotes;
    }
  }

  /// Force refresh the current quote (user can manually refresh)
  static Future<Map<String, String>> forceRefreshQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final isMorning = now.hour >= 6 && now.hour < 18;

    if (isMorning) {
      final currentIndex = prefs.getInt(_keyMorningQuoteIndex) ?? 0;
      final newIndex =
          _generateNewQuoteIndex(currentIndex, _motivationalQuotes.length);

      await prefs.setInt(_keyMorningQuoteIndex, newIndex);
      await prefs.setString(_keyLastMorningUpdate, now.toIso8601String());

      return _motivationalQuotes[newIndex];
    } else {
      final currentIndex = prefs.getInt(_keyEveningQuoteIndex) ?? 1;
      final morningIndex = prefs.getInt(_keyMorningQuoteIndex) ?? 0;
      final newIndex = _generateNewQuoteIndex(
          currentIndex, _motivationalQuotes.length,
          avoidIndex: morningIndex);

      await prefs.setInt(_keyEveningQuoteIndex, newIndex);
      await prefs.setString(_keyLastEveningUpdate, now.toIso8601String());

      return _motivationalQuotes[newIndex];
    }
  }

  /// Get total number of available quotes
  static int getTotalQuotesCount() {
    return _motivationalQuotes.length;
  }

  /// Get information about quote refresh schedule
  static Future<Map<String, dynamic>> getQuoteScheduleInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final isMorning = now.hour >= 6 && now.hour < 18;

    DateTime nextRefreshTime;
    String nextRefreshPeriod;

    if (isMorning) {
      // Next refresh is at 6 PM today
      nextRefreshTime = DateTime(now.year, now.month, now.day, 18, 0);
      nextRefreshPeriod = 'Evening';
    } else {
      // Next refresh is at 6 AM tomorrow
      final tomorrow = now.add(Duration(days: 1));
      nextRefreshTime =
          DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 6, 0);
      nextRefreshPeriod = 'Morning';
    }

    final timeUntilRefresh = nextRefreshTime.difference(now);

    return {
      'currentPeriod': isMorning ? 'Morning' : 'Evening',
      'nextRefreshTime': nextRefreshTime,
      'nextRefreshPeriod': nextRefreshPeriod,
      'hoursUntilRefresh': timeUntilRefresh.inHours,
      'minutesUntilRefresh': timeUntilRefresh.inMinutes % 60,
      'totalQuotes': _motivationalQuotes.length,
      'refreshFrequency': '2 times per day (6 AM & 6 PM)',
    };
  }

  /// Clear all quote preferences (for testing or reset)
  static Future<void> clearQuotePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentQuoteIndex);
    await prefs.remove(_keyLastQuoteUpdate);
    await prefs.remove(_keyMorningQuoteIndex);
    await prefs.remove(_keyEveningQuoteIndex);
    await prefs.remove(_keyLastMorningUpdate);
    await prefs.remove(_keyLastEveningUpdate);
  }
}
