import 'package:flutter/foundation.dart';

class ChatMessage {
  const ChatMessage(this.text, {required this.mine});

  final String text;
  final bool mine;
}

class Conversation {
  Conversation({
    required this.name,
    required this.topic,
    required this.lastTime,
    required this.messages,
    this.online = false,
  });

  final String name;
  final String topic;
  final bool online;
  String lastTime;
  final List<ChatMessage> messages;

  String get initial => name.substring(0, 1).toUpperCase();
  String get lastText => messages.isEmpty ? '' : messages.last.text;
  String get status => online ? 'Online • $topic' : topic;
}

/// Percakapan di memori.
/// TODO: ganti dengan Supabase Realtime (tabel messages).
class ChatStore extends ChangeNotifier {
  ChatStore._();

  static final instance = ChatStore._();

  final List<Conversation> _items = [
    Conversation(
      name: 'Nadia Putri',
      topic: 'Desain UI/UX',
      online: true,
      lastTime: '10.35',
      messages: const [
        ChatMessage('Halo! Saya sudah menerima brief pesanan kamu. Ada referensi lain?', mine: false),
        ChatMessage('Halo Nadia, saya kirimkan contoh warna dan inspirasi desain ya.', mine: true),
        ChatMessage('Siap, akan saya pelajari dulu. Terima kasih!', mine: false),
      ],
    ),
    Conversation(
      name: 'Rizky Maulana',
      topic: 'Website',
      lastTime: 'Kemarin',
      messages: const [ChatMessage('Oke, nanti saya cek dulu ya.', mine: false)],
    ),
    Conversation(
      name: 'Alya Safitri',
      topic: 'Desain grafis',
      lastTime: 'Senin',
      messages: const [ChatMessage('File final sudah saya kirim.', mine: false)],
    ),
  ];

  List<Conversation> get items => List.unmodifiable(_items);

  /// Cari percakapan dengan [seller]; buat baru kalau belum ada.
  Conversation forSeller(String seller, {String topic = 'Penyedia jasa'}) {
    for (final c in _items) {
      if (c.name == seller) return c;
    }
    final c = Conversation(name: seller, topic: topic, lastTime: 'Baru', messages: []);
    _items.insert(0, c);
    notifyListeners();
    return c;
  }

  void send(Conversation c, String text) {
    c.messages.add(ChatMessage(text, mine: true));
    final now = DateTime.now();
    c.lastTime = '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';
    // Pindahkan ke paling atas daftar.
    _items.remove(c);
    _items.insert(0, c);
    notifyListeners();
  }
}
