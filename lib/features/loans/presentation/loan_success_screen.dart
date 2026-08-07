import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/states.dart';

class LoanSuccessScreen extends StatelessWidget {
  final String category;
  final String amount;

  const LoanSuccessScreen({
    super.key,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Success', showLeading: false),
      body: SafeArea(
        child: SuccessState(
          title: 'Application Submitted!',
          description: 'Your application for a $category of $amount is being processed. We will notify you once approved.',
          buttonText: 'Back to Home',
          onButtonPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
