import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/presentation/health_score_dashboard/widgets/medical_insights_widget.dart';
import 'package:smokeless_plus/utils/utils.dart';

import '../../../core/app_export.dart';

class SmokingHabitsWidget extends StatefulWidget {
  final int cigarettesPerDay;
  final double costPerPack;
  final double yearsSmoking;
  final String currency;
  final Function(int) onCigarettesChanged;
  final Function(double) onCostChanged;
  final Function(double) onYearsSmokingChanged;
  final Function(String) onCurrencyChanged;

  const SmokingHabitsWidget({
    super.key,
    required this.cigarettesPerDay,
    required this.costPerPack,
    required this.yearsSmoking,
    required this.currency,
    required this.onCigarettesChanged,
    required this.onCostChanged,
    required this.onYearsSmokingChanged,
    required this.onCurrencyChanged,
  });

  @override
  State<SmokingHabitsWidget> createState() => _SmokingHabitsWidgetState();
}

class _SmokingHabitsWidgetState extends State<SmokingHabitsWidget> {
  late int _cigarettesPerDay;
  late TextEditingController _costController;
  late TextEditingController _yearsController;
  late final List<String> _currencies;
  late String _selectedCurrency;
  @override
  void initState() {
    super.initState();
    _cigarettesPerDay = widget.cigarettesPerDay;
    _selectedCurrency = widget.currency;
    _costController = TextEditingController(
      text: widget.costPerPack > 0 ? widget.costPerPack.toStringAsFixed(2) : '',
    );
    _yearsController = TextEditingController(
      text:
          widget.yearsSmoking > 0 ? widget.yearsSmoking.toStringAsFixed(1) : '',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currencies = getLocalizedCurrencyLabels(
      Localizations.localeOf(context).languageCode,
    );
  }

  @override
  void dispose() {
    _costController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  void _updateCigarettes(int value) {
    if (value >= 0 && value <= 100) {
      setState(() {
        _cigarettesPerDay = value;
      });
      widget.onCigarettesChanged(value);
    }
  }

  void _updateCost(String value) {
    final cost = double.tryParse(value) ?? 0.0;
    widget.onCostChanged(cost);
  }

  void _updateYearsSmoking(String value) {
    final years = double.tryParse(value) ?? 0.0;
    widget.onYearsSmokingChanged(years);
  }

  void _updateCurrency(String? value) {
    widget.onCurrencyChanged(value ?? 'USD (\$)');
    setState(() {
      _selectedCurrency = value ?? 'USD (\$)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Years of Smoking - NEW FIELD
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'schedule',
                      color: Theme.of(context).colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.howManyYearsHaveYouBeenSmoking,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          AppLocalizations.of(context)!.yearsSmokedBeforeQuitting,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              TextFormField(
                controller: _yearsController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
                ],
                decoration: InputDecoration(
                  hintText: '0.0',
                  suffixText: 'years',
                  suffixStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: _updateYearsSmoking,
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Cigarettes per day
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'smoking_rooms',
                      color: Theme.of(context).colorScheme.secondary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cigarettes per Day',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'How many cigarettes do you smoke daily?',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decrease button
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: _cigarettesPerDay > 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: _cigarettesPerDay > 0
                          ? () => _updateCigarettes(_cigarettesPerDay - 1)
                          : null,
                      icon: CustomIconWidget(
                        iconName: 'remove',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Count display
                  Container(
                    width: 20.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _cigarettesPerDay.toString(),
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Increase button
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: _cigarettesPerDay < 100
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: _cigarettesPerDay < 100
                          ? () => _updateCigarettes(_cigarettesPerDay + 1)
                          : null,
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Cost per pack
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'attach_money',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cost per Pack',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Average cost of a cigarette pack',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              TextFormField(
                controller: _costController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCurrency,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: _updateCurrency,
                        items: _currencies
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 100),
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: _updateCost,
              ),
            ],
          ),
        ),
        // Live calculation preview - NEW FEATURE
        if (_cigarettesPerDay > 0 &&
            double.tryParse(_yearsController.text) != null &&
            double.tryParse(_yearsController.text)! > 0)
          EstimatedSmokingImpact(
              yearsSmoking: double.tryParse(_yearsController.text) ?? 0.0,
              packCost: double.tryParse(_costController.text) ?? 0.0,
              cigarettesPerDay: _cigarettesPerDay),
      ],
    );
  }
}

class EstimatedSmokingImpact extends StatelessWidget {
  const EstimatedSmokingImpact({
    super.key,
    required this.yearsSmoking,
    required this.packCost,
    required this.cigarettesPerDay,
    this.opacity = 0.1,
  });

  final double yearsSmoking;
  final double packCost;
  final int cigarettesPerDay;

  final double opacity;

  @override
  Widget build(BuildContext context) {
    if (yearsSmoking > 0 && cigarettesPerDay > 0) {
      final totalDays = (yearsSmoking * 365.25).round();
      final totalCigarettes = totalDays * cigarettesPerDay;
      final totalSpent = packCost > 0
          ? (totalCigarettes * (packCost / 20)).toStringAsFixed(0)
          : '0';
      final lifeLostMinutes = totalCigarettes * 11; // 11 minutes per cigarette
      final lifeLostDuration = formatLifeLost(lifeLostMinutes);
      return Container(
        margin: EdgeInsets.only(top: 3.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: opacity * 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calculate',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Estimated Smoking Impact',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            InsightItemWidget(
                text:
                    'Total cigarettes smoked: ${totalCigarettes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                color: Theme.of(context).colorScheme.primary),
            if (packCost > 0)
              InsightItemWidget(
                  text: 'Total money spent: \$$totalSpent',
                  color: Theme.of(context).colorScheme.primary),
            InsightItemWidget(
                text:
                    'Smoking period: ${totalDays.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} days',
                color: Theme.of(context).colorScheme.primary),
            InsightItemWidget(
                text: 'Life lost: $lifeLostDuration',
                color: Theme.of(context).colorScheme.primary),
            //
          ],
        ),
      );
    }

    return SizedBox.shrink();
  }
}
