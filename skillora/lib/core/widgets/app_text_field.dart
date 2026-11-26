import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Input dengan label di atas. Border beranimasi saat fokus / error,
/// pesan error muncul dengan transisi tinggi (bukan tiba-tiba).
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
    this.isPassword = false,
    this.fillColor = AppColors.card,
    this.minLines,
    this.maxLines = 1,
    this.helper,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final bool isPassword;
  final Color fillColor;

  /// Untuk kolom teks panjang (deskripsi). Biarkan default untuk satu baris.
  final int? minLines;
  final int maxLines;

  /// Teks bantu kecil di bawah kolom, mis. contoh isian.
  final String? helper;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focus = FocusNode();
  bool _hidden = true;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.controller.text,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        final hasError = state.hasError;
        final focused = _focus.hasFocus;
        final borderColor = hasError
            ? AppColors.error
            : focused
                ? AppColors.fieldFocus
                : AppColors.fieldBorder;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: AppText.label),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: widget.fillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: (focused || hasError) ? 1.6 : 1.1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focus,
                      obscureText: widget.isPassword && _hidden,
                      minLines: widget.minLines,
                      maxLines: widget.isPassword ? 1 : widget.maxLines,
                      keyboardType: widget.keyboardType ??
                          (widget.maxLines != 1 ? TextInputType.multiline : null),
                      textCapitalization: widget.maxLines != 1
                          ? TextCapitalization.sentences
                          : TextCapitalization.none,
                      textInputAction: widget.textInputAction ??
                          (widget.maxLines != 1 ? TextInputAction.newline : null),
                      autofillHints: widget.autofillHints,
                      onSubmitted: widget.onSubmitted,
                      onChanged: state.didChange,
                      style: AppText.input,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: widget.hint,
                        hintStyle: AppText.hint,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  if (widget.isPassword)
                    IconButton(
                      tooltip: _hidden
                          ? 'Tampilkan kata sandi'
                          : 'Sembunyikan kata sandi',
                      onPressed: () => setState(() => _hidden = !_hidden),
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: Icon(
                          _hidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          key: ValueKey(_hidden),
                          size: 20,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.helper != null && !hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(widget.helper!, style: AppText.subtitle),
              ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: Alignment.topLeft,
              child: hasError
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(state.errorText!, style: AppText.error),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        );
      },
    );
  }
}
