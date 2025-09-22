import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/user_profile.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../constants/currencies.dart';
import '../../widgets/common/custom_button.dart';
import '../../l10n/app_localizations.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String reason;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  const ProfileSetupScreen({
    Key? key,
    required this.reason,
    required this.onComplete,
    required this.onBack,
  }) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime _quitDate = DateTime.now();
  TimeOfDay _quitTime = TimeOfDay.now();
  int _cigsPerDay = 20;
  int _yearsSmokingSmoking = 5;
  double _pricePerPack = 30.0;
  int _cigsPerPack = 20;
  String _currency = 'MAD';
  String _planType = 'coldTurkey'; // coldTurkey or gradual
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onBack,
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          localizations.setupProfile,
          style: AppTextStyles.h3,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.tellUsAboutSmoking ?? 'Tell us about your smoking habit',
                style: AppTextStyles.h2,
              ),
              SizedBox(height: 8),
              Text(
                localizations.helpCalculateStats ?? 'This helps us calculate your personalized statistics',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 32),

              // Quit Date
              _buildSection(
                title: localizations.quitDate,
                child: GestureDetector(
                  key: Key('input-quit-date'),
                  onTap: _selectQuitDate,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(_quitDate)),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Quit Time
              _buildSection(
                title: localizations.quitTime,
                child: GestureDetector(
                  key: Key('input-quit-time'),
                  onTap: _selectQuitTime,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_quitTime.format(context)),
                        Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Smoking History
              _buildSection(
                title: localizations.smokingHistory,
                child: Column(
                  children: [
                    _buildSlider(
                      label: localizations.cigarettesPerDay,
                      value: _cigsPerDay.toDouble(),
                      min: 1,
                      max: 60,
                      divisions: 59,
                      testId: 'slider-cigarettes-per-day',
                      onChanged: (value) => setState(() => _cigsPerDay = value.round()),
                    ),
                    SizedBox(height: 16),
                    _buildSlider(
                      label: localizations.yearsSmokingLabel,
                      value: _yearsSmokingSmoking.toDouble(),
                      min: 1,
                      max: 50,
                      divisions: 49,
                      testId: 'slider-years-smoking',
                      onChanged: (value) => setState(() => _yearsSmokingSmoking = value.round()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Quit Strategy
              _buildSection(
                title: localizations.quitStrategy ?? 'Quit Strategy',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            key: Key('card-plan-coldTurkey'),
                            onTap: () => setState(() => _planType = 'coldTurkey'),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _planType == 'coldTurkey' ? AppColors.primary : AppColors.border,
                                  width: _planType == 'coldTurkey' ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: _planType == 'coldTurkey' ? AppColors.primary.withOpacity(0.1) : null,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.flash_on,
                                    color: _planType == 'coldTurkey' ? AppColors.primary : AppColors.textSecondary,
                                    size: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    localizations.coldTurkey ?? 'Cold Turkey',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: _planType == 'coldTurkey' ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    localizations.quitImmediately ?? 'Quit immediately',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            key: Key('card-plan-gradual'),
                            onTap: () => setState(() => _planType = 'gradual'),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _planType == 'gradual' ? AppColors.primary : AppColors.border,
                                  width: _planType == 'gradual' ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: _planType == 'gradual' ? AppColors.primary.withOpacity(0.1) : null,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.trending_down,
                                    color: _planType == 'gradual' ? AppColors.primary : AppColors.textSecondary,
                                    size: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    localizations.gradual ?? 'Gradual',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: _planType == 'gradual' ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    localizations.reduceSlowly ?? 'Reduce slowly',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Cost Information
              _buildSection(
                title: localizations.costInformation ?? 'Cost Information',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            key: Key('input-price-per-pack'),
                            initialValue: _pricePerPack.toString(),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: localizations.pricePerPack,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onChanged: (value) {
                              final price = double.tryParse(value);
                              if (price != null) {
                                setState(() {
                                  _pricePerPack = price;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            key: Key('select-currency'),
                            value: _currency,
                            decoration: InputDecoration(
                              labelText: localizations.currency,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: worldCurrencies.map((currency) {
                              return DropdownMenuItem(
                                value: currency['code'],
                                child: Text('${currency['symbol']} ${currency['code']}'),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _currency = value!),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildSlider(
                      label: localizations.cigarettesPerPack,
                      value: _cigsPerPack.toDouble(),
                      min: 10,
                      max: 30,
                      divisions: 20,
                      testId: 'slider-cigarettes-per-pack',
                      onChanged: (value) => setState(() => _cigsPerPack = value.round()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Real-time Savings Calculation
              _buildSavingsCard(),
              SizedBox(height: 40),

              CustomButton(
                text: localizations.letsGo,
                onPressed: _isLoading ? null : _completeSetup,
                isLoading: _isLoading,
                isLarge: true,
                dataTestId: 'button-complete-setup',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h4),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    String? testId,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Text('${value.round()}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 8),
        Slider(
          key: testId != null ? Key(testId) : null,
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _selectQuitDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _quitDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _quitDate = picked);
    }
  }

  Future<void> _selectQuitTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _quitTime,
    );
    if (picked != null) {
      setState(() => _quitTime = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildSavingsCard() {
    final localizations = AppLocalizations.of(context);
    
    // Calculate estimated savings like React version
    final estimatedDailyCost = (_cigsPerDay / _cigsPerPack) * _pricePerPack;
    final estimatedMonthlyCost = estimatedDailyCost * 30;
    final estimatedYearlyCost = estimatedDailyCost * 365;

    final currencySymbol = worldCurrencies.firstWhere(
      (c) => c['code'] == _currency,
      orElse: () => {'symbol': _currency},
    )['symbol'];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.savings, color: AppColors.primary, size: 24),
              SizedBox(width: 8),
              Text(
                localizations.yourPotentialSavings ?? 'Your Potential Savings',
                style: AppTextStyles.h4.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSavingItem(
                  localizations.daily ?? 'Daily',
                  '${currencySymbol}${estimatedDailyCost.toStringAsFixed(2)}',
                  Icons.today,
                  'text-savings-daily',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildSavingItem(
                  localizations.monthly ?? 'Monthly',
                  '${currencySymbol}${estimatedMonthlyCost.toStringAsFixed(0)}',
                  Icons.calendar_month,
                  'text-savings-monthly',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildSavingItem(
                  localizations.yearly ?? 'Yearly',
                  '${currencySymbol}${estimatedYearlyCost.toStringAsFixed(0)}',
                  Icons.calendar_today,
                  'text-savings-yearly',
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.success, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localizations.savingsHint ?? 'These are the amounts you could save by not smoking!',
                    style: AppTextStyles.bodySmall.copyWith(
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
    );
  }

  Widget _buildSavingItem(String period, String amount, IconData icon, String testId) {
    return Container(
      key: Key(testId),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 16),
          SizedBox(height: 4),
          Text(
            period,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            amount,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profile = UserProfile(
        quitDate: _quitDate,
        quitTime: '${_quitTime.hour.toString().padLeft(2, '0')}:${_quitTime.minute.toString().padLeft(2, '0')}',
        baselineCigsPerDay: _cigsPerDay,
        pricePerPack: _pricePerPack,
        cigsPerPack: _cigsPerPack,
        yearsSmoking: _yearsSmokingSmoking,
        currency: _currency,
        reasonForQuitting: widget.reason,
        planType: _planType,
        timezone: 'UTC',
        avgMinutesPerCig: 5.0, // Average time to smoke a cigarette
      );

      final appState = Provider.of<AppState>(context, listen: false);
      await appState.saveProfile(profile);

      widget.onComplete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}