import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/common/bank_setup_prompt.dart';

class TermsPoliciesScreen extends StatelessWidget {
  const TermsPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: const Text('Terms and Policies'),
      ),
      body: BankConnectionAware(
        builder: (context, hasLinkedAccount) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!hasLinkedAccount) ...[
                    const BankSetupPromptCard(
                      message:
                          'Link your first bank account to unlock PocketPact. Until then, pacts and allocation features stay unavailable.',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  const _PolicyIntro(),
                  const SizedBox(height: AppSpacing.md),
                  const _PolicySection(
                    title: '1. Overview',
                    content:
                        'PocketPact helps friends and groups create savings pacts, track progress, and stay accountable. By using PocketPact, you agree to use the app responsibly and provide accurate information where required.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _PolicySection(
                    title: '2. Account and Identity',
                    content:
                        'You are responsible for maintaining the confidentiality of your account credentials. You must not impersonate another person or use unauthorized account access. You may request account deactivation at any time.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _PolicySection(
                    title: '3. Savings Data and Contributions',
                    content:
                        'Pact goals, contribution totals, and progress indicators are provided for planning and motivation. They are not financial advice. You remain solely responsible for your own financial decisions and transactions.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _PolicySection(
                    title: '4. Bank Linking and Third-Party Services',
                    content:
                        'If you link a financial account, PocketPact may rely on third-party providers to access account data securely. PocketPact does not store your banking passwords. Data access is limited to features required for app functionality.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _PolicySection(
                    title: '5. Privacy and Data Use',
                    content:
                        'PocketPact stores profile and pact-related data to deliver core features such as progress tracking, reminders, and friend collaboration. We use this data only to operate and improve the service and do not sell personal data.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _PolicySection(
                    title: '6. User Conduct',
                    content:
                        'You agree not to abuse the app, spam other users, attempt unauthorized data access, or use the service for illegal activity. We may restrict access for misuse or policy violations.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _PolicySection(
                    title: '7. Service Availability',
                    content:
                        'We aim for reliable uptime, but features may be updated, changed, or temporarily unavailable due to maintenance or technical issues. PocketPact is provided on an as-is basis without guaranteed uninterrupted service.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _PolicySection(
                    title: '8. Changes to Terms',
                    content:
                        'These terms may be updated as PocketPact evolves. Material updates will be reflected in-app with a revised effective date. Continued use of the app after updates indicates acceptance of the revised terms.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _PolicyFootnote(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PolicyIntro extends StatelessWidget {
  const _PolicyIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.cardLarge,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryPurpleDark,
            AppColors.primaryPurple,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PocketPact Terms and Policies',
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Effective date: April 28, 2026',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This page is a sample policy for development and demo purposes.',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.card,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyFootnote extends StatelessWidget {
  const _PolicyFootnote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Questions about these terms can be directed to support@pocketpact.app.',
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
