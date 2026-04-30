import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/common/bank_setup_prompt.dart';
import '../widgets/common/custom_button.dart';

class AddFriendScreen extends StatelessWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Friends'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColors.primaryPurple,
            labelColor: AppColors.primaryPurpleDark,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Requests'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: BankConnectionAware(
          builder: (context, hasLinkedAccount) {
            return Column(
              children: [
                if (!hasLinkedAccount)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      0,
                    ),
                    child: BankSetupPromptCard(
                      message:
                          'Set up your first bank account before you start building pacts with friends.',
                    ),
                  ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      _UserList(mode: _FriendListMode.requests),
                      _UserList(mode: _FriendListMode.friends),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          elevation: 3,
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: const Text('Invite'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
      ),
    );
  }
}

enum _FriendListMode { requests, friends }

class _UserList extends StatelessWidget {
  final _FriendListMode mode;

  const _UserList({required this.mode});

  @override
  Widget build(BuildContext context) {
    final users = mode == _FriendListMode.requests ? _requests : _friends;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        96,
      ),
      itemCount: users.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _SocialHeader(mode: mode);
        }

        final user = users[index - 1];
        return _FriendCard(
          user: user,
          actionLabel: mode == _FriendListMode.requests ? 'Add to pact' : 'Invite',
          actionIcon: mode == _FriendListMode.requests
              ? Icons.handshake_rounded
              : Icons.add_circle_outline_rounded,
        );
      },
    );
  }
}

class _SocialHeader extends StatelessWidget {
  final _FriendListMode mode;

  const _SocialHeader({required this.mode});

  @override
  Widget build(BuildContext context) {
    final isRequests = mode == _FriendListMode.requests;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRequests ? 'Friend requests' : 'Your pact circle',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            isRequests
                ? 'Add people you trust before you start saving together.'
                : 'Invite friends into a shared goal when the timing is right.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendCard extends StatelessWidget {
  final _FriendUser user;
  final String actionLabel;
  final IconData actionIcon;

  const _FriendCard({
    required this.user,
    required this.actionLabel,
    required this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.card,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Avatar(user: user),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  user.handle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  user.bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 116),
            child: CustomButton(
              label: actionLabel,
              icon: actionIcon,
              height: 42,
              variant: CustomButtonVariant.secondary,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final _FriendUser user;

  const _Avatar({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            user.color,
            AppColors.primaryPurpleLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: user.color.withOpacity(0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          user.name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _FriendUser {
  final String name;
  final String handle;
  final String bio;
  final Color color;

  const _FriendUser({
    required this.name,
    required this.handle,
    required this.bio,
    required this.color,
  });
}

const List<_FriendUser> _requests = [
  _FriendUser(
    name: 'TechGuru87',
    handle: '@TechMaster',
    bio: 'Budget tracking, gadget deals, and weekly savings challenges.',
    color: Color(0xFF7B2CBF),
  ),
  _FriendUser(
    name: 'ArtisticSoul',
    handle: '@SoulfulArt',
    bio: 'Saving toward a studio setup with steady monthly pacts.',
    color: Color(0xFFB388EB),
  ),
  _FriendUser(
    name: 'FitnessFreak',
    handle: '@FitFreak',
    bio: 'Building healthy routines and a travel fund with friends.',
    color: Color(0xFF9D4EDD),
  ),
];

const List<_FriendUser> _friends = [
  _FriendUser(
    name: 'Katie',
    handle: '@katie',
    bio: 'Active in Summer Vacation Fund and weekly savings pacts.',
    color: Color(0xFF7B2CBF),
  ),
  _FriendUser(
    name: 'James',
    handle: '@james',
    bio: 'Keeps the group accountable with no-spend challenges.',
    color: Color(0xFF5A189A),
  ),
  _FriendUser(
    name: 'Emma',
    handle: '@emma',
    bio: 'Usually first to contribute when a pact starts.',
    color: Color(0xFFB388EB),
  ),
];
