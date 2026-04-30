import 'package:flutter/material.dart';
import '../../services/plaid_service.dart';
import '../../theme/app_design.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import 'custom_button.dart';

typedef BankConnectionWidgetBuilder = Widget Function(
  BuildContext context,
  bool hasLinkedAccount,
);

class BankConnectionAware extends StatefulWidget {
  final BankConnectionWidgetBuilder builder;

  const BankConnectionAware({
    super.key,
    required this.builder,
  });

  @override
  State<BankConnectionAware> createState() => _BankConnectionAwareState();
}

class _BankConnectionAwareState extends State<BankConnectionAware> {
  late Future<bool> _hasLinkedAccountFuture;

  @override
  void initState() {
    super.initState();
    _hasLinkedAccountFuture = PlaidService().hasLinkedAccount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasLinkedAccountFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryPurple,
            ),
          );
        }

        return widget.builder(context, snapshot.data ?? false);
      },
    );
  }
}

class BankSetupPromptCard extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;

  const BankSetupPromptCard({
    super.key,
    this.title = 'Set up your bank account first',
    this.message =
        'Connect at least one bank account to unlock pacts, contributions, and allocation insights.',
    this.buttonLabel = 'Link Bank Account',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.cardLarge,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.lavenderMist,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: AppColors.primaryPurple,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomButton(
            label: buttonLabel,
            icon: Icons.account_balance_rounded,
            onPressed: () => Navigator.pushNamed(context, '/link-bank-account'),
          ),
        ],
      ),
    );
  }
}