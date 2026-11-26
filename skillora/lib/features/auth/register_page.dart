import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_header.dart';
import 'verify_email_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _agreed = false;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    // TODO: ganti dengan Supabase auth, mis.
    // await supabase.auth.signUp(email: ..., password: ..., data: {'name': ...});
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.pushReplacement(
      context,
      appRoute(VerifyEmailPage(email: _email.text.trim())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    title: 'Buat akun',
                    subtitle: 'Mulai berkolaborasi di Ruang Karya',
                  ),
                  const SizedBox(height: 28),
                  AppTextField(
                    label: 'Nama lengkap',
                    hint: 'Nama sesuai profil',
                    controller: _name,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'Nama wajib diisi';
                      if (value.length < 3) return 'Nama minimal 3 huruf';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Email',
                    hint: 'nama@email.com',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'Email wajib diisi';
                      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(value);
                      return ok ? null : 'Format email belum benar';
                    },
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Kata sandi',
                    hint: 'Minimal 8 karakter',
                    controller: _password,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (v) => (v ?? '').length < 8
                        ? 'Kata sandi minimal 8 karakter'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Konfirmasi kata sandi',
                    hint: 'Ulangi kata sandi',
                    controller: _confirm,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _agreed ? _submit() : null,
                    validator: (v) => v != _password.text
                        ? 'Kata sandi tidak sama'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _TermsCheck(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'DAFTAR SEKARANG',
                    loading: _loading,
                    onPressed: _agreed ? _submit : null,
                  ),
                  const SizedBox(height: 8),
                  AppPromptLink(
                    prompt: 'Sudah punya akun? ',
                    action: 'Masuk',
                    onTap: () => Navigator.maybePop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Checkbox kustom: kotak terisi navy dan centang membesar saat dipilih.
class _TermsCheck extends StatelessWidget {
  const _TermsCheck({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      label: 'Saya menyetujui syarat dan ketentuan privasi',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: value ? AppColors.navyDeep : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: value ? AppColors.navyDeep : AppColors.fieldBorder,
                    width: 1.4,
                  ),
                ),
                child: AnimatedScale(
                  scale: value ? 1 : 0,
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutBack,
                  child: const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Saya menyetujui syarat dan ketentuan privasi',
                  style: AppText.subtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
