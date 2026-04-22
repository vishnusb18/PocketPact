import 'package:flutter/material.dart';
import '../../theme/app_design.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

enum CustomButtonVariant { primary, secondary, outline, dark }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final CustomButtonVariant variant;
  final double height;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = CustomButtonVariant.primary,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final style = _styleForVariant();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.58,
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: style.background,
            foregroundColor: style.foreground,
            disabledBackgroundColor: style.background,
            disabledForegroundColor: style.foreground,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              side: BorderSide(color: style.border),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: isLoading
                ? SizedBox(
                    key: const ValueKey('loading'),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        style.foreground,
                      ),
                    ),
                  )
                : Row(
                    key: const ValueKey('content'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 19),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.button.copyWith(
                            color: style.foreground,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  _ButtonStyle _styleForVariant() {
    switch (variant) {
      case CustomButtonVariant.primary:
        return const _ButtonStyle(
          background: AppColors.primaryPurple,
          foreground: Colors.white,
          border: AppColors.primaryPurple,
        );
      case CustomButtonVariant.secondary:
        return const _ButtonStyle(
          background: AppColors.lavenderMist,
          foreground: AppColors.primaryPurpleDark,
          border: AppColors.lavenderMist,
        );
      case CustomButtonVariant.outline:
        return const _ButtonStyle(
          background: Colors.white,
          foreground: AppColors.primaryPurple,
          border: AppColors.grey200,
        );
      case CustomButtonVariant.dark:
        return const _ButtonStyle(
          background: AppColors.textPrimary,
          foreground: Colors.white,
          border: AppColors.textPrimary,
        );
    }
  }
}

class _ButtonStyle {
  final Color background;
  final Color foreground;
  final Color border;

  const _ButtonStyle({
    required this.background,
    required this.foreground,
    required this.border,
  });
}
