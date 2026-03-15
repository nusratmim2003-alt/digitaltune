import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../data/services/bdapps_auth_service.dart';
import '../../domain/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _onContinue() async {
    final phone = _phoneController.text.trim();
    final bdapps = ref.read(bdappsAuthServiceProvider);

    if (phone.isEmpty) {
      AppToast.show(context, 'মোবাইল নম্বর দিন', isError: true);
      return;
    }

    if (!bdapps.isSupportedRobiAirtelNumber(phone)) {
      AppToast.show(context, 'সঠিক Robi/Airtel নম্বর দিন (016/018)',
          isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isSubscribed = await bdapps.checkAlreadySubscribed(phone);

      if (isSubscribed) {
        await ref.read(authProvider.notifier).loginWithPhone(phone);
        if (mounted) context.go('/');
        return;
      }

      final otpData = await bdapps.sendOtp(phone);
      final success = otpData['success'] == true;
      final referenceNo = otpData['referenceNo']?.toString().trim() ?? '';
      final message = otpData['message']?.toString() ?? '';
      final statusDetail = otpData['statusDetail']?.toString() ?? '';

      if (success && referenceNo.isNotEmpty) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OtpVerifyPage(phone: phone, referenceNo: referenceNo),
          ),
        );
      } else {
        final errorMsg = message.isNotEmpty
            ? message
            : (statusDetail.isNotEmpty ? statusDetail : 'OTP পাঠানো যায়নি');
        AppToast.show(context, errorMsg, isError: true);
      }
    } catch (e) {
      AppToast.show(context, 'নেটওয়ার্ক সমস্যা হয়েছে', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text('স্বাগতম', style: AppTypography.h1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Robi/Airtel নম্বর দিয়ে লগইন করুন',
                style: AppTypography.body.copyWith(color: AppColors.lightBrown),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'মোবাইল নম্বর',
                  hintText: '018********',
                  prefixIcon: const Icon(Icons.phone_android_rounded),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'পরবর্তী',
                onPressed: _isLoading ? null : _onContinue,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Flow: Number → Check subscription → OTP → Verify → Login',
                textAlign: TextAlign.center,
                style:
                    AppTypography.caption.copyWith(color: AppColors.mutedText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpVerifyPage extends ConsumerStatefulWidget {
  final String phone;
  final String referenceNo;

  const OtpVerifyPage({
    super.key,
    required this.phone,
    required this.referenceNo,
  });

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 4) {
      AppToast.show(context, 'OTP সঠিকভাবে দিন', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bdapps = ref.read(bdappsAuthServiceProvider);
      final data = await bdapps.verifyOtp(
        otp: otp,
        referenceNo: widget.referenceNo,
        phone: widget.phone,
      );

      final statusCode =
          data['statusCode']?.toString().trim().toUpperCase() ?? '';

      if (statusCode == 'S1000') {
        await bdapps.waitForSubscriptionSync(widget.phone);
        await ref.read(authProvider.notifier).loginWithPhone(widget.phone);
        if (!mounted) return;
        context.go('/');
      } else {
        final message = data['message']?.toString() ??
            data['statusDetail']?.toString() ??
            'OTP ভুল হয়েছে';
        AppToast.show(context, message, isError: true);
      }
    } catch (_) {
      AppToast.show(context, 'নেটওয়ার্ক সমস্যা হয়েছে', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP যাচাই'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const Icon(Icons.sms_outlined, size: 64, color: AppColors.accent),
              const SizedBox(height: AppSpacing.lg),
              Text('OTP দিন',
                  style: AppTypography.h2, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${widget.phone} নম্বরে কোড পাঠানো হয়েছে',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.mutedText),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                enabled: !_isLoading,
                style: const TextStyle(fontSize: 28, letterSpacing: 10),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '******',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'যাচাই করুন',
                onPressed: _isLoading ? null : _verifyOtp,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextButton(
                text: 'ভুল নম্বর? পিছনে যান',
                onPressed: _isLoading ? null : () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
