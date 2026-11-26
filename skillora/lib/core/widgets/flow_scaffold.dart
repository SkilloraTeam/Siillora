import 'package:flutter/material.dart';

import 'auth_header.dart';

/// Kerangka halaman alur: kepala (kembali + judul), isi yang bisa digulir,
/// dan area tombol di bawah yang tetap terlihat.
class FlowScaffold extends StatelessWidget {
  const FlowScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.bottom,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? bottom;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: AuthHeader(title: title, subtitle: subtitle, onBack: onBack),
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
              if (bottom != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: bottom,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
