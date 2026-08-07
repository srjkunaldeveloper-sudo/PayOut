import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/bills/presentation/bill_details_screen.dart';

class ConsumerNumberScreen extends StatefulWidget {
  final String categoryName;

  const ConsumerNumberScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<ConsumerNumberScreen> createState() => _ConsumerNumberScreenState();
}

class _ConsumerNumberScreenState extends State<ConsumerNumberScreen> {
  final TextEditingController _consumerController = TextEditingController();
  String? _selectedProvider;
  bool _isValid = false;

  List<String> _getProviders() {
    switch (widget.categoryName) {
      case 'Electricity':
        return ['State Power Grid', 'Clean Energy Corp', 'City Electric Systems'];
      case 'Water':
        return ['Aqua Water Systems', 'City Water Authority', 'County Water Supply'];
      case 'Gas':
        return ['National Gas Supply', 'Metro Gas Ltd', 'EcoGas Energy'];
      case 'Broadband':
        return ['Comcast Xfinity', 'AT&T Broadband', 'Verizon Fios'];
      case 'DTH':
        return ['DirecTV', 'Dish Network', 'Sky Cable'];
      case 'FASTag':
        return ['FASTag Toll Pass', 'Easy Toll Access', 'Metro Toll Authority'];
      default:
        return ['Generic Utility Provider A', 'Generic Utility Provider B'];
    }
  }

  void _validateInput(String val) {
    setState(() {
      _isValid = val.length >= 6 && _selectedProvider != null;
    });
  }

  @override
  void dispose() {
    _consumerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providers = _getProviders();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.categoryName),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s12),
              const Text(
                'Select Provider',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: EdgeInsets.zero,
                child: DropdownButtonFormField<String>(
                  value: _selectedProvider,
                  items: providers.map((prov) {
                    return DropdownMenuItem<String>(
                      value: prov,
                      child: Text(
                        prov,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedProvider = val;
                    });
                    _validateInput(_consumerController.text);
                  },
                  decoration: InputDecoration(
                    hintText: 'Select your utility biller',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              const Text(
                'Account / Consumer ID',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              TextField(
                controller: _consumerController,
                onChanged: _validateInput,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter 6 to 12 digit Account Number',
                  prefixIcon: Icon(Icons.tag_rounded, color: AppColors.textSecondary),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continue',
                  onPressed: _isValid
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillDetailsScreen(
                                categoryName: widget.categoryName,
                                providerName: _selectedProvider!,
                                consumerNumber: _consumerController.text,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
