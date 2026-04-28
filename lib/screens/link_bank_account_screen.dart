// Link Bank Account Screen
// Allows users to connect their bank account using Plaid
// Shows connection status and provides option to link or unlink
// Features Pacty mascot to reassure users about security

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/plaid_service.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/common/pacty_helper.dart';
import '../utils/pacty_messages.dart';

class LinkBankAccountScreen extends StatefulWidget {
  const LinkBankAccountScreen({super.key});

  @override
  State<LinkBankAccountScreen> createState() => _LinkBankAccountScreenState();
}

class _LinkBankAccountScreenState extends State<LinkBankAccountScreen> {
  final PlaidService _plaidService = PlaidService();
  final String _userId = const Uuid().v4(); // Generate unique user ID
  bool _isLinked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLinkStatus();
  }

  Future<void> _checkLinkStatus() async {
    final hasAccount = await _plaidService.hasLinkedAccount();
    setState(() {
      _isLinked = hasAccount;
      _isLoading = false;
    });
  }

  Future<void> _linkAccount() async {
    setState(() => _isLoading = true);
    
    try {
      final success = await _plaidService.linkBankAccount(
        context: context,
        userId: _userId,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        
        if (success) {
          setState(() => _isLinked = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bank account linked successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bank linking cancelled or failed'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error in _linkAccount: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _unlinkAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlink Bank Account'),
        content: const Text('Are you sure you want to unlink your bank account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Unlink', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      await _plaidService.unlinkAccount();
      setState(() {
        _isLinked = false;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bank account unlinked')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Link Bank Account',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pacty Helper - Security Reassurance
                  if (!_isLinked) ...[
                    PactyHelperCompact(
                      message: PactyMessages.bankLinking[0].message,
                      emotion: PactyMessages.bankLinking[0].emotion,
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _isLinked ? Icons.check_circle : Icons.account_balance,
                          size: 64,
                          color: _isLinked ? AppColors.accentGold : Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isLinked
                              ? 'Bank Account Connected'
                              : 'Connect Your Bank',
                          style: AppTextStyles.h3.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLinked
                              ? 'Your bank account is securely connected'
                              : 'Link your bank account to track savings automatically',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Benefits Section
                  if (!_isLinked) ...[
                    const Text(
                      'Why connect your bank?',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      Icons.sync,
                      'Auto-verification',
                      'Contributions are verified automatically',
                    ),
                    _buildBenefitItem(
                      Icons.security,
                      'Secure & Private',
                      'Bank-level encryption protects your data',
                    ),
                    _buildBenefitItem(
                      Icons.speed,
                      'Instant Updates',
                      'Real-time tracking of your savings progress',
                    ),
                    _buildBenefitItem(
                      Icons.insights,
                      'Smart Insights',
                      'Get personalized savings recommendations',
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Powered by Plaid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 16, color: AppColors.grey400),
                      const SizedBox(width: 8),
                      Text(
                        'Secured by Plaid',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLinked ? _unlinkAccount : _linkAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLinked 
                            ? AppColors.error 
                            : AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _isLinked ? 'Unlink Bank Account' : 'Connect Bank Account',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  if (!_isLinked) ...[
                    const SizedBox(height: 16),
                    Text(
                      'You\'ll be redirected to securely log in to your bank',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
