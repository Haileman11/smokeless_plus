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
                'Tell us about your smoking habit',
                style: AppTextStyles.h2,
              ),
              SizedBox(height: 8),
              Text(
                'This helps us calculate your personalized statistics',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 32),

              // Quit Date
              _buildSection(
                title: localizations.quitDate,
                child: ListTile(
                  title: Text(_formatDate(_quitDate)),
                  trailing: Icon(Icons.calendar_today),
                  onTap: _selectQuitDate,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Quit Time
              _buildSection(
                title: localizations.quitTime,
                child: ListTile(
                  title: Text(_quitTime.format(context)),
                  trailing: Icon(Icons.access_time),
                  onTap: _selectQuitTime,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.border),
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
                      onChanged: (value) => setState(() => _cigsPerDay = value.round()),
                    ),
                    SizedBox(height: 16),
                    _buildSlider(
                      label: localizations.yearsSmokingLabel,
                      value: _yearsSmokingSmoking.toDouble(),
                      min: 1,
                      max: 50,
                      divisions: 49,
                      onChanged: (value) => setState(() => _yearsSmokingSmoking = value.round()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Cost Information
              _buildSection(
                title: 'Cost Information',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: _pricePerPack.toString(),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: localizations.pricePerPack,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onChanged: (value) {
                              final price = double.tryParse(value);
                              if (price != null) _pricePerPack = price;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
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
                      onChanged: (value) => setState(() => _cigsPerPack = value.round()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              CustomButton(
                text: localizations.letsGo,
                onPressed: _isLoading ? null : _completeSetup,
                isLoading: _isLoading,
                isLarge: true,
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