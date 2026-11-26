import 'package:flutter/foundation.dart';

import '../catalog/service_model.dart';
import '../catalog/service_repository.dart';

/// Jasa yang ditandai favorit.
/// TODO: ganti dengan tabel favorites di Supabase.
class FavoritesStore extends ChangeNotifier {
  FavoritesStore._();

  static final instance = FavoritesStore._();

  final List<String> _ids = ['s5', 's7'];

  List<Service> get services => [for (final id in _ids) ServiceRepository.byId(id)];

  bool contains(String id) => _ids.contains(id);

  void toggle(String id) {
    if (!_ids.remove(id)) _ids.insert(0, id);
    notifyListeners();
  }
}
