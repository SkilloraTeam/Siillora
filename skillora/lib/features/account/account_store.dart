import 'package:flutter/foundation.dart';

class Account {
  const Account({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
  });

  final String id;
  final String name;
  final String email;
  final String phone;

  String get initial => name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
  String get firstName => name.split(' ').first;

  Account copyWith({String? name, String? email, String? phone}) => Account(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );
}

/// Akun yang tersimpan di perangkat dan akun yang sedang aktif.
/// TODO: ganti dengan sesi Supabase Auth dan tabel profiles.
class AccountStore extends ChangeNotifier {
  AccountStore._();

  static final instance = AccountStore._();

  final List<Account> _accounts = [
    const Account(
      id: 'a1',
      name: 'Sara Wilson',
      email: 'sara.wilson@email.com',
      phone: '081234567890',
    ),
    const Account(
      id: 'a2',
      name: 'Sara Mahasiswa',
      email: 'sara.student@email.com',
    ),
  ];
  String _activeId = 'a1';

  List<Account> get accounts => List.unmodifiable(_accounts);
  Account get active => _accounts.firstWhere((a) => a.id == _activeId);

  void switchTo(String id) {
    if (id == _activeId) return;
    _activeId = id;
    notifyListeners();
  }

  void updateActive({String? name, String? email, String? phone}) {
    final i = _accounts.indexWhere((a) => a.id == _activeId);
    _accounts[i] = _accounts[i].copyWith(name: name, email: email, phone: phone);
    notifyListeners();
  }
}
