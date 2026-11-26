import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import 'chat_detail_page.dart';
import 'chat_store.dart';

/// Layar 31: daftar chat (tab Chat).
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final _query = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ChatStore.instance,
      builder: (context, _) {
        final q = _query.text.trim().toLowerCase();
        final items = [
          for (final c in ChatStore.instance.items)
            if (q.isEmpty ||
                c.name.toLowerCase().contains(q) ||
                c.lastText.toLowerCase().contains(q))
              c,
        ];

        return FlowScaffold(
          title: 'Chat',
          subtitle: 'Percakapan kamu dengan penyedia jasa',
          onBack: widget.onBack,
          children: [
            Reveal(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _focus.hasFocus ? AppColors.fieldFocus : AppColors.fieldBorder,
                    width: _focus.hasFocus ? 1.6 : 1.1,
                  ),
                ),
                child: TextField(
                  controller: _query,
                  focusNode: _focus,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  style: AppText.input,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Cari percakapan...',
                    hintStyle: AppText.hint,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    q.isEmpty
                        ? 'Belum ada percakapan.'
                        : 'Tidak ada percakapan untuk "${_query.text.trim()}".',
                    style: AppText.subtitle,
                  ),
                ),
              ),
            for (var i = 0; i < items.length; i++)
              Padding(
                key: ValueKey(items[i].name),
                padding: const EdgeInsets.only(bottom: 10),
                child: Reveal(
                  index: i + 1,
                  child: _ChatTile(
                    conversation: items[i],
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        appRoute(ChatDetailPage(conversation: items[i])),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({super.key, required this.initial, this.size = 40});

  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColors.mist, shape: BoxShape.circle),
      child: Text(
        initial,
        style: AppText.label.copyWith(fontSize: size * 0.36, color: AppColors.navyDeep),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            ChatAvatar(initial: c.initial),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label.copyWith(fontSize: 13),
                        ),
                      ),
                      Text(c.lastTime, style: AppText.subtitle.copyWith(fontSize: 10.5)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    c.lastText.isEmpty ? 'Mulai percakapan' : c.lastText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtitle.copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
