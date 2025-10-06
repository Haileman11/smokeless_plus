import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:smokeless_plus/services/language_service.dart';
import 'package:smokeless_plus/services/subscription_service.dart';
import 'package:smokeless_plus/services/theme_service.dart';


class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final language = context.watch<LanguageProvider>();
    final subscriptionProvider = context.watch<SubscriptionProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Premium",
          style: Theme.of(context).textTheme.titleMedium
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: subscriptionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (subscriptionProvider.isPremium)
                    _buildPremiumStatus(isDarkMode, subscriptionProvider)
                  else
                    _buildSubscriptionPlans(isDarkMode, language, subscriptionProvider),
                  
                  const SizedBox(height: 20),
                  _buildFeaturesList(isDarkMode, subscriptionProvider),
                  
                  const SizedBox(height: 30),
                  _buildRestoreButton(isDarkMode, subscriptionProvider),
                  
                  const SizedBox(height: 20),
                  _buildTermsAndPrivacy(isDarkMode),
                ],
              ),
            ),
    );
  }

  Widget _buildPremiumStatus(bool isDarkMode, SubscriptionProvider subscriptionProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE74C3C).withAlpha(26),
            Color(0xFFE74C3C).withAlpha(13),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.verified,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 15),
          const Text(
            'Premium Active',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subscriptionProvider.getSubscriptionStatusText(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subscriptionProvider.getExpirationText(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans(bool isDarkMode, LanguageProvider language, SubscriptionProvider subscriptionProvider) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE74C3C).withAlpha(26),
                Color(0xFFE74C3C).withAlpha(13),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child:  Column(
            children: [
              Icon(
                Icons.star,
                color: Theme.of(context).iconTheme.color ,
                size: 50,
              ),
              SizedBox(height: 15),
              Text(
                'Upgrade to Premium',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Get unlimited access to all features',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Subscription Plans
        if (subscriptionProvider.availablePackages.isNotEmpty)
          ...subscriptionProvider.availablePackages.map((package) {
            return _buildSubscriptionCard(package, isDarkMode, subscriptionProvider);
          }).toList()        
      ],
    );
  }

  Widget _buildSubscriptionCard(Package package, bool isDarkMode, SubscriptionProvider subscriptionProvider) {
    final isYearly = package.identifier.contains('annual') || package.identifier.contains('yearly');
    final isLifetime = package.identifier.contains('lifetime');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: isYearly ? Theme.of(context).colorScheme.primary : Colors.grey.withOpacity(0.3),
          width: isYearly ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardTheme.color,
      ),
      child: Column(
        children: [
          if (isYearly)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration:  BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: const Text(
                'Most Popular',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package.storeProduct.title.split(' (')[0],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            package.storeProduct.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          package.storeProduct.priceString,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        if (!isLifetime)
                          Text(
                            isYearly ? '/year' : '/month',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => presentPaywall(subscriptionProvider, package.presentedOfferingContext.offeringIdentifier),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Subscribe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(bool isDarkMode, SubscriptionProvider subscriptionProvider) {
    final features = subscriptionProvider.getPremiumFeatures();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Premium Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          ...features.map((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                   Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRestoreButton(bool isDarkMode, SubscriptionProvider subscriptionProvider) {
    return TextButton(
      onPressed: () => _restorePurchases(subscriptionProvider),
      child: Text(
        'Restore Purchases',
        style: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacy(bool isDarkMode) {
    return Column(
      children: [
        Text(
          'By subscribing, you agree to our Terms of Service and Privacy Policy',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.white54 : Colors.black45,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Open terms of service
              },
              child:  Text(
                'Terms',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Text(
              ' • ',
              style: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.black45,
              ),
            ),
            TextButton(
              onPressed: () {
                // Open privacy policy
              },
              child: Text(
                'Privacy',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _purchasePackage(Package package, SubscriptionProvider subscriptionProvider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await subscriptionProvider.purchaseSubscription(package);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome to Premium! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchase failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _restorePurchases(SubscriptionProvider subscriptionProvider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await subscriptionProvider.restorePurchases();
      
      if (success && subscriptionProvider.isPremium) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchases restored successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No purchases found to restore.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error restoring purchases: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  void presentPaywall(SubscriptionProvider subscriptionProvider, String offeringId,) async {
    final Offering offering= await subscriptionProvider.getOffering(offeringId) as Offering;
    final paywallResult = await RevenueCatUI.presentPaywall(offering: offering);
    print('Paywall result: $paywallResult');
  }
}