import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/pressable.dart';
import 'chat_list_page.dart';
import 'chat_store.dart';

/// Layar 32: ruang chat dengan satu penyedia jasa.
class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.conversation});

  final Conversation conversation;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  /// Pesan yang sudah ada saat halaman dibuka tidak dianimasikan.
  late final int _seen = widget.conversation.messages.length;

  bool get _canSend => _input.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _toEnd(animate: false));
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toEnd({bool animate = true}) {
    if (!_scroll.hasClients) return;
    final end = _scroll.position.maxScrollExtent;
    if (animate && !reduceMotion(context)) {
      _scroll.animateTo(
        end,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scroll.jumpTo(end);
    }
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    // TODO: kirim lewat Supabase Realtime.
    ChatStore.instance.send(widget.conversation, text);
    _input.clear();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _toEnd());
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.conversation;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.fieldBorder.withValues(alpha: 0.35)),
                ),
              ),
              child: Row(
                children: [
                  const BackPill(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name, style: AppText.sectionTitle.copyWith(fontSize: 16)),
                        const SizedBox(height: 1),
                        Text(c.status, style: AppText.subtitle),
                      ],
                    ),
                  ),
                  ChatAvatar(initial: c.initial, size: 36),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                itemCount: c.messages.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Center(
                        child: Text(
                          'Hari ini',
                          style: AppText.subtitle.copyWith(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }
                  final m = c.messages[i - 1];
                  return _Bubble(
                    message: m,
                    animate: i - 1 >= _seen,
                  );
                },
              ),
            ),
            _Composer(
              controller: _input,
              canSend: _canSend,
              onChanged: () => setState(() {}),
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.animate});

  final ChatMessage message;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final mine = message.mine;
    final maxW = MediaQuery.sizeOf(context).width * 0.74;

    Widget bubble = Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxW),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine ? AppColors.navyDeep : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          border: mine
              ? null
              : Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
        ),
        child: Text(
          message.text,
          style: AppText.input.copyWith(
            fontSize: 13,
            height: 1.4,
            fontWeight: FontWeight.w400,
            color: mine ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );

    // Hanya pesan yang baru dikirim yang bergerak: naik tipis dari sisi pengirim.
    if (animate && !reduceMotion(context)) {
      bubble = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) => Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset((mine ? 12 : -12) * (1 - t), 8 * (1 - t)),
            child: child,
          ),
        ),
        child: bubble,
      );
    }
    return bubble;
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.canSend,
    required this.onChanged,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.fieldBorder.withValues(alpha: 0.35)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.fieldBorder, width: 1.1),
              ),
              child: Row(
                children: [
                  Pressable(
                    onTap: () => ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      // TODO: sambungkan ke pemilih lampiran chat.
                      ..showSnackBar(
                        const SnackBar(content: Text('Lampiran chat belum tersedia.')),
                      ),
                    scale: 0.9,
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(Icons.add_rounded, size: 22, color: AppColors.textMuted),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (_) => onChanged(),
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      style: AppText.input,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'Tulis pesan...',
                        hintStyle: AppText.hint,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            enabled: canSend,
            label: 'Kirim pesan',
            child: Pressable(
              onTap: canSend ? onSend : null,
              scale: 0.92,
              child: AnimatedOpacity(
                opacity: canSend ? 1 : 0.4,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.navyDeep,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
