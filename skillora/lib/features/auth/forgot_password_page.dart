import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_header.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  // Amplop melayang pelan naik-turun, hanya selama halaman terbuka.
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );
  late final Animation<double> _floatCurve =
      CurvedAnimation(parent: _float, curve: Curves.easeInOut);

  bool _floatStarted = false;
  bool _loading = false;
  bool _sent = false;
  String _sentTo = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_floatStarted) return;
    _floatStarted = true;
    if (!reduceMotion(context)) _float.repeat(reverse: true);
  }

  @override
  void dispose() {
    _float.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    // TODO: ganti dengan Supabase, mis.
    // await supabase.auth.resetPasswordForEmail(_email.text.trim());
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
      _sentTo = _email.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title: 'Lupa kata sandi',
                  subtitle: 'Pulihkan akses akunmu',
                ),
                const SizedBox(height: 36),
                Center(
                  child: AnimatedBuilder(
                    animation: _floatCurve,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, -8 * _floatCurve.value),
                      child: child,
                    ),
                    child: _MailBadge(sent: _sent),
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  layoutBuilder: (current, previous) => Stack(
                    alignment: Alignment.topLeft,
                    children: [...previous, if (current != null) current],
                  ),
                  child: _sent
                      ? _Copy(
                          key: const ValueKey('sent'),
                          title: 'Tautan reset sudah dikirim',
                          body: 'Kami mengirim tautan ke $_sentTo. '
                              'Cek kotak masuk atau folder spam.',
                        )
                      : const _Copy(
                          key: ValueKey('ask'),
                          title: 'Masukkan email terdaftar',
                          body: 'Kami akan mengirim tautan untuk '
                              'mengatur ulang kata sandi.',
                        ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: _sent
                      ? const SizedBox(width: double.infinity, height: 20)
                      : Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Form(
                            key: _formKey,
                            child: AppTextField(
                              label: 'Alamat email',
                              hint: 'nama@email.com',
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.email],
                              onSubmitted: (_) => _submit(),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Email wajib diisi';
                                final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                    .hasMatch(value);
                                return ok ? null : 'Format email belum benar';
                              },
                            ),
                          ),
                        ),
                ),
                if (_sent)
                  PrimaryButton(
                    label: 'KEMBALI KE MASUK',
                    onPressed: () => Navigator.maybePop(context),
                  )
                else
                  PrimaryButton(
                    label: 'KIRIM TAUTAN RESET',
                    loading: _loading,
                    onPressed: _submit,
                  ),
                const SizedBox(height: 8),
                Center(
                  child: AppTextLink(
                    label: _sent ? 'Salah email? Ubah' : 'Kembali ke halaman masuk',
                    onTap: _sent
                        ? () => setState(() => _sent = false)
                        : () => Navigator.maybePop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Copy extends StatelessWidget {
  const _Copy({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.sectionTitle),
          const SizedBox(height: 6),
          Text(body, style: AppText.body),
        ],
      ),
    );
  }
}

/// Lingkaran biru dengan amplop. Berubah jadi centang saat tautan terkirim.
class _MailBadge extends StatelessWidget {
  const _MailBadge({required this.sent});

  final bool sent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        color: AppColors.mist,
        shape: BoxShape.circle,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: Icon(
          sent ? Icons.check_rounded : Icons.mail_outline_rounded,
          key: ValueKey(sent),
          size: sent ? 68 : 60,
          color: sent ? AppColors.success : Colors.white.withValues(alpha: 0.92),
        ),
      ),
    );
  }
}
