# Dokumentasi Halaman Baru Skillora (Ruang Karya)

Dokumen ini merangkum semua yang ditambahkan untuk layar Figma nomor **26 sampai 43**:
pembayaran, chat, akun, favorit, riwayat, bantuan, dan kebijakan.

> Status: kode ditulis tanpa Flutter di lingkungan pembuatnya, jadi belum pernah
> dijalankan oleh penulisnya. Jalankan `flutter analyze` dan `flutter test` sebelum dipakai.

---

## 1. Peta layar Figma ke kode

| No | Layar Figma | Kelas | Berkas |
|----|-------------|-------|--------|
| 26 | Konfirmasi ulasan | `ReviewSentPage` | `features/orders/review_sent_page.dart` |
| 27 | Daftar pembayaran | `PaymentsPage` | `features/payments/payments_page.dart` |
| 28 | Detail pembayaran QRIS | `PaymentDetailPage` | `features/payments/payment_detail_page.dart` |
| 29 | Unggah bukti pembayaran | `UploadProofPage` | `features/payments/upload_proof_page.dart` |
| 30 | Konfirmasi pembayaran | `PaymentSentPage` | `features/payments/payment_sent_page.dart` |
| 31 | Daftar chat | `ChatListPage` | `features/chat/chat_list_page.dart` |
| 32 | Chat detail | `ChatDetailPage` | `features/chat/chat_detail_page.dart` |
| 33 | Akun user | `AccountPage` | `features/account/account_page.dart` |
| 34 | Edit profil | `EditProfilePage` | `features/account/edit_profile_page.dart` |
| 35 | Ganti akun | `SwitchAccountPage` | `features/account/switch_account_page.dart` |
| 36 | Favorit | `FavoritesPage` | `features/favorites/favorites_page.dart` |
| 37 | Riwayat pesanan | `OrderHistoryPage` | `features/orders/order_history_page.dart` |
| 38 | Riwayat pembayaran | `PaymentHistoryPage` | `features/payments/payment_history_page.dart` |
| 39 | Pusat bantuan | `HelpCenterPage` | `features/help/help_center_page.dart` |
| 40 | Detail panduan | `HelpGuidePage` | `features/help/help_guide_page.dart` |
| 41 | Kebijakan & privasi | `PrivacyPage` | `features/help/policy_page.dart` |
| 42 | Konfirmasi logout | `LogoutConfirmPage` | `features/account/logout_confirm_page.dart` |
| 43 | Informasi aplikasi | `AppInfoPage` | `features/account/app_info_page.dart` |
| - | Syarat & ketentuan (tanpa desain Figma) | `TermsPage` | `features/help/policy_page.dart` |

---

## 2. Berkas baru

### Core
- `core/widgets/navy_banner.dart`: kartu navy bergradasi untuk pembuka halaman (Pusat bantuan, Kebijakan).

### Pembayaran (`features/payments/`)
- `payment_model.dart`: `PaymentStatus`, `Payment`, `PaymentStore`, dan `pickSampleProof()`.
- `payment_chip.dart`: pil status (Belum bayar, Menunggu, Berhasil).
- `qris_code.dart`: gambar kode QR bergaya QRIS (`CustomPainter`).
- `payments_page.dart`, `payment_detail_page.dart`, `upload_proof_page.dart`, `payment_sent_page.dart`, `payment_history_page.dart`.

### Chat (`features/chat/`)
- `chat_store.dart`: `ChatMessage`, `Conversation`, `ChatStore`.
- `chat_list_page.dart`: daftar dan pencarian, juga `ChatAvatar`.
- `chat_detail_page.dart`: ruang chat, gelembung pesan, kotak tulis.

### Akun (`features/account/`)
- `account_store.dart`: `Account`, `AccountStore` (akun aktif).
- `account_page.dart`, `edit_profile_page.dart`, `switch_account_page.dart`, `logout_confirm_page.dart`, `app_info_page.dart`.

### Favorit (`features/favorites/`)
- `favorites_store.dart`, `favorites_page.dart`.

### Bantuan (`features/help/`)
- `help_topics.dart`: data 5 topik dan langkahnya (`HelpTopic`, `HelpStep`).
- `help_center_page.dart`, `help_guide_page.dart`.
- `policy_page.dart`: `PrivacyPage` dan `TermsPage` (tampilan bersama `_PolicyView`).

### Pesanan (`features/orders/`)
- `review_sent_page.dart`, `order_history_page.dart`.

### Tes
- `test/payments_chat_account_test.dart`.

---

## 3. Berkas lama yang diubah

| Berkas | Perubahan |
|--------|-----------|
| `core/navigation/shell_bus.dart` | Ditambah `openHome`, `openChat`, `chatSeller`, `requestHome()`, `requestChat([seller])`. |
| `features/shell/main_shell.dart` | Tab Bayar, Chat, Akun memakai halaman asli. Tab Chat punya Navigator sendiri. Nama di Beranda diambil dari akun aktif. Bottom nav disembunyikan saat keyboard terbuka. |
| `features/orders/review_page.dart` | Setelah kirim, diganti ke `ReviewSentPage` (hasil `true` tetap dikembalikan). |
| `features/orders/order_detail_page.dart` | Snackbar "ulasan terkirim" dihapus karena sudah ada layar konfirmasi. |
| `features/orders/revision_sent_page.dart` | Tombol chat membuka percakapan dengan penyedia jasa. |
| `features/catalog/service_detail_page.dart` | Tombol chat aktif, ditambah ikon hati favorit di samping harga, fungsi `_soon` yang tidak terpakai dihapus. |

---

## 4. Navigasi

```
MainShell (bottom nav)
├── 0 Beranda
├── 1 Kategori   (Navigator sendiri, bottom nav tetap tampil)
├── 2 Bayar      PaymentsPage
├── 3 Chat       (Navigator sendiri) ChatListPage -> ChatDetailPage
└── 4 Akun       AccountPage
```

- **Halaman dengan bottom nav:** daftar chat dan chat detail.
- **Halaman tanpa bottom nav** (dibuka di Navigator utama): detail pembayaran, unggah bukti, konfirmasi, edit profil, ganti akun, favorit, riwayat, bantuan, kebijakan, konfirmasi keluar, informasi aplikasi.
- Tombol back di halaman root tab membawa kembali ke Beranda.

### Alur pembayaran
`PaymentsPage` -> `PaymentDetailPage` (QRIS) -> `UploadProofPage` -> `PaymentSentPage` -> **LIHAT PESANAN** (ke daftar pesanan lewat `ShellBus.requestOrders()`).

Setelah bukti dikirim, status tagihan berubah dari **Belum bayar** menjadi **Menunggu**.

### Alur ulasan
`ReviewPage` -> `ReviewSentPage` -> **KEMBALI KE BERANDA** (`ShellBus.requestHome()`).

### Alur chat dari halaman lain
Tombol "Chat dengan penyedia jasa" (detail jasa) dan tombol chat di layar revisi terkirim memanggil `ShellBus.requestChat(seller)`. Shell pindah ke tab Chat dan membuka percakapan dengan penyedia itu, dibuat baru jika belum ada.

### Alur keluar
Akun -> **Keluar** -> `LogoutConfirmPage` -> **YA, KELUAR** -> `LoginPage` (seluruh riwayat navigasi dihapus).

---

## 5. Data (semua masih di memori)

| Store | Isi awal | Catatan |
|-------|----------|---------|
| `PaymentStore` | ORD-015 (Rp250.000, belum bayar), ORD-016 (Rp200.000, berhasil) | Total transaksi dihitung dari semua tagihan. Nomor pesanan sama dengan `OrderStore`. |
| `ChatStore` | Nadia Putri, Rizky Maulana, Alya Safitri | Mengirim pesan memindahkan percakapan ke paling atas. |
| `AccountStore` | Sara Wilson (aktif), Sara Mahasiswa | Edit profil mengubah akun aktif. |
| `FavoritesStore` | `s5`, `s7` | Ditandai lewat ikon hati di detail jasa. |

Semua store berupa `ChangeNotifier` singleton (`.instance`), sama gayanya dengan `OrderStore`.

---

## 6. Detail per fitur

### Pembayaran
- Kartu **Total transaksi**: angka naik dari 0 satu kali saat halaman dibuka.
- Detail menampilkan QRIS selama belum **Berhasil**. Jika sudah berhasil, diganti pesan bahwa pembayaran diterima.
- Unggah bukti: tombol kirim nonaktif sebelum ada berkas. **Hapus** menghilangkan berkas. Format yang dijanjikan PNG atau JPG.
- Layar konfirmasi memakai `PopScope`, tombol back kembali ke awal tumpukan halaman.

### Chat
- Pencarian menyaring berdasarkan nama atau isi pesan terakhir.
- Pesan yang baru dikirim bergerak masuk. Pesan lama tidak dianimasikan.
- Tombol kirim redup saat kolom kosong. Daftar otomatis menggulir ke pesan terbaru.

### Akun
- Kartu profil berganti dengan fade saat akun dipindah.
- Edit profil memvalidasi: nama wajib, email berformat benar, telepon 9 sampai 15 angka (boleh kosong).
- Menu: Ganti akun, Favorit, Riwayat pesanan, Riwayat pembayaran, Pusat bantuan, Kebijakan & privasi, Informasi aplikasi, Keluar.

### Riwayat
- **Riwayat pesanan** menampilkan semua pesanan dengan chip status. Ketuk untuk membuka detail.
- **Riwayat pembayaran** menampilkan semua transaksi dengan tanggal dan status berwarna.

### Bantuan
- Lima pertanyaan umum: memesan, membayar, revisi, ulasan, ubah profil. Pencarian menyaring pertanyaan.
- Isi "Cara memesan jasa" dan teks Kebijakan & privasi mengikuti Figma. Topik lain ditulis mengikuti alur aplikasi.

---

## 7. Animasi dan aksesibilitas

- Memakai ulang `Reveal`, `PopIn`, `Pressable`, `appRoute`, dan `reduceMotion`. Semua gerak mengikuti pengaturan "kurangi animasi".
- Animasi hanya untuk perubahan yang berarti: angka total, pesan baru, ikon hati, tanda akun aktif, bagian "bukti terpilih" yang membuka.
- Target ketuk minimal 44 px untuk Hapus, kirim chat, hati, dan lampiran.
- Label `Semantics` ada di kode QR, tombol kirim, hati favorit, dan baris akun.

---

## 8. Daftar TODO (titik sambung backend)

| Lokasi | Yang perlu diganti |
|--------|--------------------|
| `payment_model.dart` | Tabel `payments` di Supabase dan unggah bukti ke Storage. |
| `payment_model.dart` (`pickSampleProof`) | Ganti dengan `file_picker` (PNG, JPG). |
| `qris_code.dart` | Ganti ilustrasi dengan string QRIS dari server dan `qr_flutter`. Kode saat ini **tidak bisa dipindai**. |
| `chat_store.dart`, `chat_detail_page.dart` | Supabase Realtime (tabel `messages`). Tombol lampiran masih menampilkan snackbar. |
| `account_store.dart` | Sesi Supabase Auth dan tabel `profiles`. |
| `edit_profile_page.dart` | Simpan ke `profiles`, ubah foto lewat `image_picker`. |
| `switch_account_page.dart` | Alur masuk untuk akun kedua (tombol Tambahkan akun masih snackbar). |
| `logout_confirm_page.dart` | Akhiri sesi sebelum kembali ke login. |
| `favorites_store.dart` | Tabel `favorites`. |
| `help_topics.dart` | Pindahkan ke tabel `help_articles` bila konten sering berubah. |
| `policy_page.dart` | Ganti `TermsPage` (dan cek `PrivacyPage`) dengan teks resmi. |
| `app_info_page.dart` | Versi aplikasi dari `package_info_plus`. |
| `help_center_page.dart` | Teks "Hubungi tim kami" belum bisa diketuk. |

---

## 9. Perbedaan dari Figma

- Nomor tagihan memakai pesanan yang sudah ada (ORD-015 dan ORD-016), bukan ORD-018 seperti di Figma, agar data konsisten dengan `OrderStore`.
- Judul layar 30 diubah menjadi **Pembayaran terkirim** karena bukti baru diverifikasi, belum berhasil.
- Baris **Informasi aplikasi** ditambahkan di menu Akun sebagai jalan masuk ke layar 43 (Figma tidak menunjukkan lokasinya).
- Halaman **Syarat & ketentuan** dibuat sendiri karena belum ada desainnya.
- Judul "Tanggal" pada chat detail hanya "Hari ini", tanpa jam.

---

## 10. Tes

Berkas: `test/payments_chat_account_test.dart`

- Daftar pembayaran menampilkan total Rp450.000 dan dua tagihan.
- Unggah bukti: tombol aktif setelah berkas dipilih, hilang saat dihapus.
- Chat: pesan yang dikirim muncul.
- Edit profil menolak nama kosong.
- Ganti akun mengubah akun aktif.
- `submitProof` mengubah status menjadi Menunggu.

Menjalankan:

```bash
flutter analyze
flutter test
```

---

## 11. Catatan perbaikan yang sudah terjadi

- Error `const_with_non_const` di `payment_model.dart`: `DateTime(...)` bukan konstanta, sehingga `const` di depan `Payment(...)` pada data awal dihapus. Konstruktor `Payment` tetap `const`.