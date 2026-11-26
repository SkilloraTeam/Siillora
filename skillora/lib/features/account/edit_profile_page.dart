import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import 'account_store.dart';

/// Layar 34: ubah data profil.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _form = GlobalKey<FormState>();
  late final Account _account = AccountStore.instance.active;
  late final _name = TextEditingController(text: _account.name);
  late final _email = TextEditingController(text: _account.email);
  late final _phone = TextEditingController(text: _account.phone);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _validateName(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Nama lengkap wajib diisi.' : null;

  String? _validateEmail(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Email wajib diisi.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) {
      return 'Format email belum benar.';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    if (!RegExp(r'^\+?[0-9]{9,15}$').hasMatch(t)) {
      return 'Nomor telepon 9-15 angka.';
    }
    return null;
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    // TODO: simpan ke tabel profiles di Supabase.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    AccountStore.instance.updateActive(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
    );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Perubahan disimpan.')));
  }

  void _photo() {
    // TODO: sambungkan ke image_picker lalu unggah ke Storage.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Ubah foto belum tersedia.')));
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Edit profil',
      subtitle: 'Perbarui informasi akun',
      bottom: PrimaryButton(
        label: 'SIMPAN PERUBAHAN',
        loading: _saving,
        onPressed: _save,
      ),
      children: [
        Reveal(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.mist,
                    shape: BoxShape.circle,
                  ),
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _name,
                    builder: (context, v, _) {
                      final t = v.text.trim();
                      return Text(
                        t.isEmpty ? '?' : t.substring(0, 1).toUpperCase(),
                        style: AppText.title.copyWith(fontSize: 40, color: AppColors.navyDeep),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Pressable(
                  onTap: _photo,
                  scale: 0.95,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Center(child: Text('Ubah foto profil', style: AppText.link)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Form(
          key: _form,
          child: Column(
            children: [
              Reveal(
                index: 1,
                child: AppTextField(
                  label: 'Nama lengkap',
                  hint: 'Nama kamu',
                  controller: _name,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                ),
              ),
              const SizedBox(height: 14),
              Reveal(
                index: 2,
                child: AppTextField(
                  label: 'Email',
                  hint: 'nama@email.com',
                  controller: _email,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                ),
              ),
              const SizedBox(height: 14),
              Reveal(
                index: 3,
                child: AppTextField(
                  label: 'Nomor telepon',
                  hint: '08xxxxxxxxxx',
                  controller: _phone,
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                  autofillHints: const [AutofillHints.telephoneNumber],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
