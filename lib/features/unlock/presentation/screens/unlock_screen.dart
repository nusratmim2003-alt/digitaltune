import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../domain/providers/shared_cassette_provider.dart';
import '../../domain/services/cassette_share_service.dart';
import 'cassette_error_screen.dart';

class UnlockScreen extends ConsumerStatefulWidget {
  final String cassetteId;

  const UnlockScreen({super.key, required this.cassetteId});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final int _maxAttempts = 5;

  @override
  void initState() {
    super.initState();
    // Load cassette data when screen opens
    Future.microtask(() {
      ref.read(sharedCassetteProvider.notifier).loadCassette(widget.cassetteId);
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleUnlock() async {
    if (_passwordController.text.isEmpty) {
      AppToast.show(context, 'Please enter a password', isError: true);
      return;
    }

    final notifier = ref.read(sharedCassetteProvider.notifier);
    final success = await notifier.unlockCassette(_passwordController.text);

    if (mounted) {
      if (success) {
        // Navigate to cassette experience
        context.go('/cassette/${widget.cassetteId}');
      } else {
        final state = ref.read(sharedCassetteProvider);

        // Check if too many failed attempts
        if (state.failedAttempts >= _maxAttempts) {
          // Navigate to error screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => CassetteErrorScreen.tooManyAttempts(context),
            ),
          );
        } else {
          // Show error message
          final attemptsRemaining = _maxAttempts - state.failedAttempts;
          AppToast.show(
            context,
            'Wrong password. $attemptsRemaining attempts remaining.',
            isError: true,
          );
          _passwordController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cassetteState = ref.watch(sharedCassetteProvider);

    // Show loading while fetching cassette
    if (cassetteState.isLoading && cassetteState.cassette == null) {
      return Scaffold(
        backgroundColor: AppColors.deepBrown,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Loading cassette...',
                style: AppTypography.body.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      );
    }

    // Show error if cassette invalid
    if (cassetteState.validationResult != null &&
        cassetteState.validationResult != CassetteValidationResult.valid) {
      final validationResult = cassetteState.validationResult!;

      switch (validationResult) {
        case CassetteValidationResult.notFound:
          return CassetteErrorScreen.notFound(context);
        case CassetteValidationResult.deleted:
          return CassetteErrorScreen.deleted(context);
        case CassetteValidationResult.expired:
          return CassetteErrorScreen.expired(context);
        case CassetteValidationResult.maxUnlocksReached:
          return CassetteErrorScreen.maxUnlocksReached(context);
        default:
          return CassetteErrorScreen.notFound(context);
      }
    }

    final cassette = cassetteState.cassette;
    if (cassette == null) {
      return CassetteErrorScreen.notFound(context);
    }

    final isLoading = cassetteState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.deepBrown,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Locked cassette visual
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Header text - warm and emotional
                Text(
                  '${cassette.displaySenderName} sent you a memory',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),

                Text(
                  '${cassette.emotionEmoji} ${cassette.emotionTag}',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.accent,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Enter the password to unlock',
                  style: AppTypography.body.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  enabled: !isLoading,
                  autofocus: true,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                    hintText: 'Enter password',
                    hintStyle: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.3),
                    ),
                    filled: true,
                    fillColor: AppColors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMedium,
                      ),
                      borderSide: BorderSide(
                        color: AppColors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMedium,
                      ),
                      borderSide: BorderSide(
                        color: AppColors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMedium,
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Failed attempts indicator
                if (cassetteState.failedAttempts > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(
                      '${_maxAttempts - cassetteState.failedAttempts} attempts remaining',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error.withValues(alpha: 0.9),
                      ),
                    ),
                  ),

                // Unlock button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Unlock Cassette',
                    onPressed: isLoading ? null : _handleUnlock,
                    isLoading: isLoading,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Help text
                Text(
                  'Ask the sender for the password',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
