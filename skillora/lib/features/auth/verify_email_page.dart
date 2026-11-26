import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with SingleTickerProviderStateMixin {
  static const _cooldownSeconds = 30;

  // Satu momen: lingkaran membesar, lalu centang digambar.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );
  late final Animation<double> _circle = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
  );
  late final Animation<double> _check = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
  );

  Timer? _timer;
  int _cooldown = _cooldownSeconds;
  bool _introStarted = false;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_introStarted) return;
    _introStarted = true;
    if (reduceMotion(context)) {
      _intro.value = 1;
    } else {
      _intro.forward();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _intro.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    _cooldown = _cooldownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _cooldown -= 1);
      if (_cooldown <= 0) t.cancel();
    });
  }

  void _resend() {
    // TODO: ganti dengan Supabase, mis.
    // await supabase.auth.resend(type: OtpType.signup, email: widget.email);
    setState(_startCooldown);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email verifikasi dikirim ulang')),
    );
  }

  void _openMailApp() {
    // TODO: buka aplikasi email, mis. dengan paket url_launcher / open_mail_app.
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _cooldown <= 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Column(
              children: [
                const AuthHeader(
                  title: 'Verifikasi email',
                  subtitle: 'Periksa kotak masuk email kamu',
                ),
                const SizedBox(height: 36),
                ScaleTransition(
                  scale: Tween<double>(begin: 0.6, end: 1).animate(_circle),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: AppColors.mist,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: AnimatedBuilder(
                      animation: _check,
                      builder: (context, _) => CustomPaint(
                        size: const Size(64, 64),
                        painter: _CheckPainter(_check.value, AppColors.success),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Tautan verifikasi telah dikirim',
                  textAlign: TextAlign.center,
                  style: AppText.sectionTitle,
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Silakan periksa email '),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const TextSpan(text: ' dan ikuti instruksinya.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: AppText.body,
                ),
                const SizedBox(height: 28),
                PrimaryButton(label: 'BUKA EMAIL', onPressed: _openMailApp),
                const SizedBox(height: 8),
                AppTextLink(
                  label: canResend
                      ? 'Kirim ulang email'
                      : 'Kirim ulang email dalam $_cooldown dtk',
                  onTap: canResend ? _resend : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Menggambar centang secara bertahap (progress 0..1).
class _CheckPainter extends CustomPainter {
  _CheckPainter(this.progress, this.color);

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.20, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.72)
      ..lineTo(size.width * 0.80, size.height * 0.30);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(_CheckPainter old) =>
      old.progress != progress || old.color != color;
}
