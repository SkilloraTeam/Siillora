import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';
import '../shell/main_shell.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  // Satu animasi pembuka: lingkaran muncul -> teks naik -> kartu naik.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final Animation<double> _artAnim = _interval(0.0, 0.7);
  late final Animation<double> _copyAnim = _interval(0.15, 0.75);
  late final Animation<double> _cardAnim = _interval(0.3, 1.0);

  bool _introStarted = false;
  bool _loading = false;

  Animation<double> _interval(double begin, double end) => CurvedAnimation(
        parent: _intro,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      );

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
    _intro.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    // TODO: ganti dengan Supabase auth, mis.
    // await supabase.auth.signInWithPassword(email: ..., password: ...);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.pushReplacement(context, appRoute(const MainShell()));
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email wajib diisi';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'Format email belum benar';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.navy,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: FadeTransition(
                      opacity: _cardAnim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.06),
                          end: Offset.zero,
                        ).animate(_cardAnim),
                        child: _buildCard(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          right: -64,
          top: 24,
          child: FadeTransition(
            opacity: _artAnim,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1).animate(_artAnim),
              child: const _Rings(),
            ),
          ),
        ),
        FadeTransition(
          opacity: _copyAnim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.12),
              end: Offset.zero,
            ).animate(_copyAnim),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, topPad + 44, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RUANG KARYA', style: AppText.brand),
                  const SizedBox(height: 14),
                  Text(
                    'Temukan talenta,\nwujudkan ide.',
                    style: AppText.headline,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Marketplace jasa kreatif mahasiswa.',
                    style: AppText.onDarkBody,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 28, 24, 16 + bottomPad),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat datang!', style: AppText.title.copyWith(fontSize: 24)),
            const SizedBox(height: 4),
            Text('Masuk untuk melanjutkan.', style: AppText.subtitle),
            const SizedBox(height: 22),
            AppTextField(
              label: 'Email',
              hint: 'nama@email.com',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: _validateEmail,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Kata sandi',
              hint: 'Masukkan kata sandi',
              controller: _password,
              isPassword: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _submit(),
              validator: (v) =>
                  (v ?? '').isEmpty ? 'Kata sandi wajib diisi' : null,
              fillColor: Colors.white,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AppTextLink(
                label: 'Lupa kata sandi?',
                onTap: () => Navigator.push(
                  context,
                  appRoute(const ForgotPasswordPage()),
                ),
              ),
            ),
            const SizedBox(height: 6),
            PrimaryButton(
              label: 'MASUK',
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 14),
            Center(child: Text('atau', style: AppText.subtitle)),
            const Spacer(),
            AppPromptLink(
              prompt: 'Belum punya akun? ',
              action: 'Daftar',
              onTap: () =>
                  Navigator.push(context, appRoute(const RegisterPage())),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tiga lingkaran konsentris di pojok kanan atas header.
class _Rings extends StatelessWidget {
  const _Rings();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 228,
      height: 228,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          _Dot(size: 228, color: AppColors.navyRing),
          _Dot(size: 136, color: AppColors.sky),
          _Dot(size: 74, color: AppColors.mist),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
