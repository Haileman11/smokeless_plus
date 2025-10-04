import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

  // const  quotes = [
  //   // Health & Recovery Quotes
  //   {
  //     "message":
  //         "Every smoke-free breath is a victory celebration in your lungs. Your body is healing with each passing moment.",
  //     "author": "Dr. Sarah Williams"
  //   },
  //   {
  //     "message":
  //         "Your heart is beating stronger today than it was yesterday. Every day smoke-free is a gift to your cardiovascular system.",
  //     "author": "Cardiologist Dr. James Lee"
  //   },
  //   {
  //     "message":
  //         "The oxygen in your blood is increasing, your circulation is improving, and your energy levels are soaring.",
  //     "author": "Health Coach Maria"
  //   },
  //   {
  //     "message":
  //         "Your taste buds are awakening to flavors you haven't experienced in years. Life is becoming more vivid.",
  //     "author": "Wellness Expert John"
  //   },
  //   {
  //     "message":
  //         "Every cough that subsides, every deep breath that feels clearer - your lungs are thanking you for this decision.",
  //     "author": "Pulmonologist Dr. Chen"
  //   },
  //   {
  //     "message":
  //         "Your immune system is strengthening every day. You're building a fortress of health around yourself.",
  //     "author": "Dr. Michael Roberts"
  //   },
  //   {
  //     "message":
  //         "The nicotine is leaving your system, making room for natural energy and genuine vitality to return.",
  //     "author": "Addiction Specialist Dr. Taylor"
  //   },
  //   {
  //     "message":
  //         "Your skin is regaining its natural glow, your complexion improving with each smoke-free day.",
  //     "author": "Dermatologist Dr. Kim"
  //   },
  //   {
  //     "message":
  //         "Sleep is becoming more restful, dreams more vivid, and mornings more energetic. Your body is healing overnight.",
  //     "author": "Sleep Specialist Dr. Brown"
  //   },
  //   {
  //     "message":
  //         "Your blood pressure is stabilizing, your pulse is becoming steady. Your heart is finding its natural rhythm.",
  //     "author": "Dr. Patricia Davis"
  //   },

  //   // Strength & Willpower Quotes
  //   {
  //     "message":
  //         "You are stronger than your cravings. Every time you resist, your willpower muscle grows more powerful.",
  //     "author": "Life Coach Amanda"
  //   },
  //   {
  //     "message":
  //         "Cravings are temporary visitors - they come, they peak, and they always leave. You are the permanent resident of your life.",
  //     "author": "Mindfulness Expert David"
  //   },
  //   {
  //     "message":
  //         "Each 'no' to a cigarette is a 'yes' to your future self. You're making deposits in the bank of your health.",
  //     "author": "Motivational Speaker Lisa"
  //   },
  //   {
  //     "message":
  //         "The urge to smoke lasts minutes, but your decision to quit will last a lifetime. Choose the permanent over the temporary.",
  //     "author": "Recovery Coach Mark"
  //   },
  //   {
  //     "message":
  //         "You've already proven you can go hours without smoking. Now you're proving you can go days, weeks, and years.",
  //     "author": "Therapist Dr. Wilson"
  //   },
  //   {
  //     "message":
  //         "Every challenging moment you overcome makes you more resilient. You're building unshakeable inner strength.",
  //     "author": "Resilience Coach Sara"
  //   },
  //   {
  //     "message":
  //         "The part of you that wanted to quit is stronger than the part that wanted to smoke. Trust your deeper wisdom.",
  //     "author": "Counselor Dr. Martinez"
  //   },
  //   {
  //     "message":
  //         "You're not giving up something - you're gaining everything: health, money, time, and self-respect.",
  //     "author": "Success Coach Jennifer"
  //   },
  //   {
  //     "message":
  //         "Breaking free from addiction is the ultimate act of self-love. You deserve this freedom.",
  //     "author": "Self-Care Expert Rachel"
  //   },
  //   {
  //     "message":
  //         "Every smoke-free moment is proof of your incredible willpower. You are more powerful than you know.",
  //     "author": "Empowerment Coach Mike"
  //   },

  //   // Financial & Practical Benefits
  //   {
  //     "message":
  //         "The money staying in your wallet is earning interest in your health account. This is the best investment you'll ever make.",
  //     "author": "Financial Wellness Expert Tom"
  //   },
  //   {
  //     "message":
  //         "Calculate not just the money saved, but the priceless gift of time you're adding to your life.",
  //     "author": "Life Planner Susan"
  //   },
  //   {
  //     "message":
  //         "Every dollar not spent on cigarettes is a dollar invested in your dreams and future goals.",
  //     "author": "Investment Advisor Carol"
  //   },
  //   {
  //     "message":
  //         "The money you're saving could fund a vacation, a hobby, or a dream you've put on hold. Your future self will thank you.",
  //     "author": "Budget Coach Daniel"
  //   },
  //   {
  //     "message":
  //         "Freedom isn't free, but quitting smoking is the one freedom that actually saves you money while saving your life.",
  //     "author": "Freedom Fighter Alex"
  //   },
  //   {
  //     "message":
  //         "Your bank account is growing while your health risks are shrinking. That's what I call a win-win situation.",
  //     "author": "Wellness Financial Planner Beth"
  //   },
  //   {
  //     "message":
  //         "Think of all the beautiful experiences you can buy with the money you're no longer burning away.",
  //     "author": "Experience Designer Maya"
  //   },
  //   {
  //     "message":
  //         "Every cigarette not bought is money earned. Every smoke-free day is profit for your future.",
  //     "author": "Entrepreneur Coach Steve"
  //   },
  //   {
  //     "message":
  //         "The compound interest on your health and wealth starts accumulating from the moment you quit.",
  //     "author": "Lifestyle Investment Expert Kim"
  //   },
  //   {
  //     "message":
  //         "You're not just saving money - you're investing in decades of additional earning potential by staying healthy.",
  //     "author": "Career Strategist Linda"
  //   },

  //   // Time & Life Extension Quotes
  //   {
  //     "message":
  //         "Every day smoke-free adds approximately 2 hours to your life expectancy. You're literally buying yourself time.",
  //     "author": "Longevity Expert Dr. Adams"
  //   },
  //   {
  //     "message":
  //         "Time is the most precious currency, and quitting smoking is your way of earning more of it.",
  //     "author": "Time Management Coach Paul"
  //   },
  //   {
  //     "message":
  //         "You're not just extending your life - you're improving the quality of every year, month, and day you have left.",
  //     "author": "Quality of Life Specialist Dr. Green"
  //   },
  //   {
  //     "message":
  //         "Imagine all the grandchildren's birthdays, sunsets, and adventures you'll experience because you chose to quit.",
  //     "author": "Life Coach Melissa"
  //   },
  //   {
  //     "message":
  //         "Each smoke-free day is like adding pages to the book of your life story. Make them beautiful chapters.",
  //     "author": "Life Story Coach Emma"
  //   },
  //   {
  //     "message":
  //         "You're giving yourself the gift of being present for life's most precious moments.",
  //     "author": "Mindfulness Teacher Robert"
  //   },
  //   {
  //     "message":
  //         "The minutes you're not spending smoking can now be spent living, loving, and creating memories.",
  //     "author": "Memory Coach Diana"
  //   },
  //   {
  //     "message":
  //         "Your life timeline just got extended. Use this bonus time to chase dreams and build legacies.",
  //     "author": "Legacy Coach Brian"
  //   },
  //   {
  //     "message":
  //         "Every smoke-free breath is a moment reclaimed from the past and invested in your future.",
  //     "author": "Future Self Coach Hannah"
  //   },
  //   {
  //     "message":
  //         "You're not just living longer - you're living stronger, healthier, and with more vitality in every moment.",
  //     "author": "Vitality Expert Dr. Foster"
  //   },

  //   // Family & Relationships
  //   {
  //     "message":
  //         "Your family breathes easier knowing you're smoke-free. You're giving them the gift of your longevity.",
  //     "author": "Family Therapist Dr. Johnson"
  //   },
  //   {
  //     "message":
  //         "The best inheritance you can leave your children is the example of choosing health over addiction.",
  //     "author": "Parenting Expert Dr. White"
  //   },
  //   {
  //     "message":
  //         "Your loved ones no longer worry about losing you to smoking-related illness. That peace of mind is priceless.",
  //     "author": "Relationship Counselor Janet"
  //   },
  //   {
  //     "message":
  //         "Every hug is cleaner, every kiss is sweeter, every moment together is no longer clouded by smoke.",
  //     "author": "Love Coach Patricia"
  //   },
  //   {
  //     "message":
  //         "You're modeling strength and self-care for everyone who looks up to you.",
  //     "author": "Role Model Coach Anthony"
  //   },
  //   {
  //     "message":
  //         "The people who love you are celebrating your decision to choose life, health, and presence.",
  //     "author": "Celebration Coach Monica"
  //   },
  //   {
  //     "message":
  //         "Your smoke-free home is now a sanctuary of clean air and healthy living for everyone in it.",
  //     "author": "Home Wellness Expert Tracy"
  //   },
  //   {
  //     "message":
  //         "You're giving your children and grandchildren the gift of fresh air and a healthy role model.",
  //     "author": "Children's Health Advocate Dr. Lopez"
  //   },
  //   {
  //     "message":
  //         "Every family gathering is now free from the separation that smoking used to create.",
  //     "author": "Family Unity Coach Richard"
  //   },
  //   {
  //     "message":
  //         "The love in your life multiplies when you choose to love yourself enough to quit smoking.",
  //     "author": "Self-Love Coach Vanessa"
  //   },

  //   // Personal Achievement & Pride
  //   {
  //     "message":
  //         "You've just conquered one of the most challenging addictions. If you can do this, you can do anything.",
  //     "author": "Achievement Coach Tyler"
  //   },
  //   {
  //     "message":
  //         "This is your personal Mount Everest, and you're climbing it one smoke-free day at a time.",
  //     "author": "Personal Challenge Coach Rosa"
  //   },
  //   {
  //     "message":
  //         "You've graduated from addiction to freedom. Wear this accomplishment with pride.",
  //     "author": "Pride Coach Kenneth"
  //   },
  //   {
  //     "message":
  //         "Every person you inspire with your quit story multiplies the impact of your brave decision.",
  //     "author": "Inspiration Speaker Dr. Clark"
  //   },
  //   {
  //     "message":
  //         "You've proven that you have the strength to change your life. What other dreams will you conquer next?",
  //     "author": "Dream Achievement Coach Sophia"
  //   },
  //   {
  //     "message":
  //         "This victory over smoking is evidence of your incredible capacity for positive transformation.",
  //     "author": "Transformation Coach Gregory"
  //   },
  //   {
  //     "message":
  //         "You're not the same person who used to smoke. You've evolved into someone stronger and healthier.",
  //     "author": "Evolution Coach Miranda"
  //   },
  //   {
  //     "message":
  //         "Your success story is being written with every smoke-free choice. Make it a bestseller.",
  //     "author": "Success Story Coach Nathan"
  //   },
  //   {
  //     "message":
  //         "The discipline you've developed in quitting smoking will serve you well in every area of life.",
  //     "author": "Discipline Coach Oliver"
  //   },
  //   {
  //     "message":
  //         "You've broken free from chains that held millions captive. You are now truly free.",
  //     "author": "Freedom Coach Isabella"
  //   },

  //   // Motivation for Difficult Moments
  //   {
  //     "message":
  //         "Cravings are like ocean waves - they build, peak, and then always crash down. Ride them out.",
  //     "author": "Craving Management Expert Dr. Stone"
  //   },
  //   {
  //     "message":
  //         "This moment of difficulty will pass, but your quit will last forever if you don't give up.",
  //     "author": "Persistence Coach Frank"
  //   },
  //   {
  //     "message":
  //         "The urge you're feeling right now is addiction's last desperate attempt to control you. You're stronger.",
  //     "author": "Addiction Recovery Specialist Dr. Reed"
  //   },
  //   {
  //     "message":
  //         "Every craving you survive makes the next one weaker. You're wearing down the addiction, not the other way around.",
  //     "author": "Resilience Training Coach Julie"
  //   },
  //   {
  //     "message":
  //         "What feels unbearable right now felt the same way yesterday, and you made it through. You can do it again.",
  //     "author": "Endurance Coach Marcus"
  //   },
  //   {
  //     "message":
  //         "The discomfort you feel is temporary, but the regret of giving up would be permanent.",
  //     "author": "Regret Prevention Coach Zoe"
  //   },
  //   {
  //     "message":
  //         "You've survived 100% of your worst cravings so far. Your track record is perfect.",
  //     "author": "Survival Statistics Coach Ian"
  //   },
  //   {
  //     "message":
  //         "This challenging moment is actually your strength training session. Each rep makes you stronger.",
  //     "author": "Mental Strength Coach Ruby"
  //   },
  //   {
  //     "message":
  //         "The part of you that wants to smoke is shrinking while the part that wants to stay quit is growing.",
  //     "author": "Inner Strength Coach Felix"
  //   },
  //   {
  //     "message":
  //         "Breathe through this craving. On the other side is pride, health, and continued freedom.",
  //     "author": "Breathing Coach Penelope"
  //   },

  //   // Long-term Vision & Future Self
  //   {
  //     "message":
  //         "Your 80-year-old self is thanking you right now for the decision to quit smoking today.",
  //     "author": "Future Self Coach Dr. Parker"
  //   },
  //   {
  //     "message":
  //         "Imagine running up stairs without breathing hard, tasting food fully, and sleeping deeply. This is your new reality.",
  //     "author": "New Reality Coach Samantha"
  //   },
  //   {
  //     "message":
  //         "The person you're becoming is someone who chooses health, values life, and honors their body.",
  //     "author": "Identity Coach Vincent"
  //   },
  //   {
  //     "message":
  //         "Years from now, this quit date will be one of the most important dates in your life story.",
  //     "author": "Life Story Date Coach Gabrielle"
  //   },
  //   {
  //     "message":
  //         "You're not just changing a habit - you're changing your entire life trajectory toward health and happiness.",
  //     "author": "Life Trajectory Coach Jordan"
  //   },
  //   {
  //     "message":
  //         "The compound benefits of quitting smoking will be felt for decades to come. This is long-term thinking at its best.",
  //     "author": "Long-term Benefits Coach Ethan"
  //   },
  //   {
  //     "message":
  //         "Your future adventures, relationships, and achievements are all made possible by this brave decision to quit.",
  //     "author": "Future Adventures Coach Crystal"
  //   },
  //   {
  //     "message":
  //         "The legacy you're creating is one of strength, wisdom, and the courage to change when change is needed.",
  //     "author": "Legacy Creation Coach Derek"
  //   },
  //   {
  //     "message":
  //         "Every smoke-free day is a building block in the foundation of your healthiest, happiest life.",
  //     "author": "Life Foundation Coach Amber"
  //   },
  //   {
  //     "message":
  //         "You're creating a future where smoking is just a memory, and health and vitality are your daily reality.",
  //     "author": "Future Creation Coach Phoenix"
  //   },
  // ];
// void main() {

//   final Map<String, dynamic> arbContent = {
//     "@@locale": "en",
//   };

//   for (var i = 0; i < quotes.length; i++) {
//     final key = 'quote_${(i + 1).toString().padLeft(3, '0')}';
//     arbContent[key] = {
//       "message": quotes[i]["message"],
//       "author": quotes[i]["author"],
//     };
//   }

//   final file = File('intl_en.arb');
//   file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(arbContent));

//   print('✅ intl_en.arb file generated with ${quotes.length} quotes.');
// }


/// Change this to your translation API endpoint
// const libreTranslateUrl = 'https://libretranslate.de/translate'; // Or your self-hosted endpoint
const libreTranslateUrl = "http://localhost:5050/translate";

/// Languages you want to translate to
const targetLanguages = ['es', 'fr', 'de','zh', 'hi', 'ar', 'it', 'ja', 'pt', 'ru', 'zh']; // Spanish, French, German, Chinese, Hindi, Arabic, Italian, Japanese, Portuguese, Russian

/// Your original quotes in English


// Future<void> main() async {
//   for (final lang in targetLanguages) {
  
//     print('🌐 Translating to $lang...');
//     final Map<String, dynamic> arb = {"@@locale": lang};

//     for (int i = 0; i < quotes.length; i++) {
//       final id = (i + 1).toString().padLeft(3, '0');
//       final messageKey = 'quote_${id}_message';
//       final authorKey = 'quote_${id}_author';

//       final message = await translateText(quotes[i]['message']!, lang);
//       final author = await translateText(quotes[i]['author']!, lang);

//       arb[messageKey] = quotes[i]['message'];
//       arb[authorKey] = quotes[i]['author'];

//       // Optional: add metadata
//       // arb["@${messageKey}"] = {
//       //   "description": "Translated motivational quote message",
//       //   "type": "text"
//       // };
//       // arb["@${authorKey}"] = {
//       //   "description": "Translated author name",
//       //   "type": "text"
//       // };
//     }

//     final file = File('intl_$lang.arb');
//     file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(arb));
//     print('✅ intl_$lang.arb generated.');
//   }
// }

Future<void> main() async {
  final File sourceFile = File('assets/l10n/intl_en.arb');
  final Map<String, dynamic> enJson = jsonDecode(await sourceFile.readAsString());

  // Filter out metadata keys (e.g., keys that start with "@")
  final entriesToTranslate = enJson.entries.where((e) => !e.key.startsWith('@') && e.key != '@@locale');

  for (final lang in targetLanguages) {
    print('🌐 Translating to $lang...');

    final Map<String, dynamic> translatedArb = {'@@locale': lang};

    for (final entry in entriesToTranslate) {
      final placeholders = <String>[];

      // Protect placeholders before sending to LibreTranslate
      final protectedText = protectPlaceholders(entry.value.toString(), placeholders);

      // Translate protected text
      final translatedTextRaw = await translateText(protectedText, lang);

      // Restore placeholders back
      final translatedText = restorePlaceholders(translatedTextRaw, placeholders);

      translatedArb[entry.key] = translatedText;

      // Optional: preserve metadata
      final metadataKey = '@${entry.key}';
      if (enJson.containsKey(metadataKey)) {
        translatedArb[metadataKey] = enJson[metadataKey];
      }
      // final translatedText = await translateText(entry.value.toString(), lang);
      // translatedArb[entry.key] = translatedText;

      // // Optional: preserve metadata
      // final metadataKey = '@${entry.key}';
      // if (enJson.containsKey(metadataKey)) {
      //   translatedArb[metadataKey] = enJson[metadataKey];
      // }
    }

    final outputFile = File('assets/l10n/intl_$lang.arb');
    outputFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(translatedArb));
    print('✅ app_$lang.arb generated.');
  }
}

/// Translate text using LibreTranslate API
Future<String> translateText(String text, String targetLang) async {
  final response = await http.post(
    Uri.parse(libreTranslateUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "q": text,
      "source": "en",
      "target": targetLang,
      "format": "text"
    }),
  );

  if (response.statusCode == 200) {
    final jsonResp = jsonDecode(response.body);
    return jsonResp['translatedText'];
  } else {
    print('Status code: ${response.statusCode}');
    print('❌ Failed to translate: $text');
    return text; // fallback
  }
}
String protectPlaceholders(String text, List<String> placeholders) {
  final regex = RegExp(r'\{[a-zA-Z0-9_]+\}');
  int i = 0;
  return text.replaceAllMapped(regex, (match) {
    placeholders.add(match.group(0)!);
    return '__VAR${i++}__';
  });
}

String restorePlaceholders(String translated, List<String> placeholders) {
  for (int i = 0; i < placeholders.length; i++) {
    translated = translated.replaceFirst('__VAR${i}__', placeholders[i]);
  }
  return translated;
}
