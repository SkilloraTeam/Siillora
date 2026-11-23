# Panduan Alur Kerja Git & GitHub — Tim Skillora (`SkilloraTeam`)

Dokumen ini adalah panduan standar kerja kolaborasi untuk tim developer proyek **Siillora** di bawah organisasi **SkilloraTeam**. Ikuti langkah-langkah di bawah ini agar kode tetap rapi, aman, dan tidak saling menimpa (*conflict*).

---

## 1. Persiapan Awal (Wajib Dilakukan Sekali)

### A. Terima Undangan Organization
1. Login ke akun GitHub masing-masing.
2. Cek email undangan dari GitHub atau buka halaman profil organisasi `SkilloraTeam`, lalu klik **Accept invitation**.
3. Konfirmasi ke Product Lead (`nazrilka`) setelah bergabung agar akses **Write** ke repositori diaktifkan.

### B. Clone Repositori ke Laptop
Buka terminal / Git Bash di folder proyek lokal Anda, lalu jalankan:
```bash
git clone https://github.com/SkilloraTeam/Siillora.git
cd Siillora
```

*(Jika sebelumnya Anda sudah pernah clone dari repo pribadi lama, cukup perbarui alamat remote dengan perintah berikut)*:
```bash
git remote set-url origin https://github.com/SkilloraTeam/Siillora.git
```

---

## 2. Struktur Branch Tim

Kita menggunakan **3 tingkatan branch** agar proses pengembangan dan Quality Control (QC) berjalan teratur:

| Nama Branch | Fungsi | Aturan Akses |
| :--- | :--- | :--- |
| **`main`** | Kode produksi / siap rilis (*final*). | **Terkunci (Protected).** Hanya bisa di-merge setelah lolos QC & *approval* Product Lead. |
| **`dev`** | Branch integrasi & pengujian bersama. | Tempat menggabungkan semua fitur yang sudah selesai dikerjakan sebelum naik ke `main`. |
| **`fitur-<nama>`** | Branch kerja masing-masing developer. | Tempat menulis kode fitur atau perbaikan bug (contoh: `fitur-login`, `fix-navbar`). |

> **Aturan Emas:** Dilarang melakukan `git push` langsung ke branch `main` maupun `dev`. Semua perubahan wajib melalui branch fitur dan **Pull Request (PR)**.

---

## 3. Alur Kerja Harian Developer

Setiap kali akan mulai mengerjakan tugas atau fitur baru, ikuti urutan perintah berikut:

### Langkah 1: Ambil Pembaruan Terbaru dari `dev`
Pastikan kode di laptop Anda sudah paling *update* sebelum membuat cabang baru:
```bash
git checkout dev
git pull origin dev
```

### Langkah 2: Buat Branch Fitur Baru
Gunakan nama branch yang jelas dan deskriptif sesuai tugas Anda:
```bash
git checkout -b fitur-nama-tugas
```
*Contoh:* `git checkout -b fitur-halaman-profil` atau `git checkout -b fix-validasi-form`

### Langkah 3: Kerjakan Kode & Commit Secara Berkala
Setelah selesai menulis atau mengubah kode, simpan perubahan ke dalam commit dengan pesan yang jelas:
```bash
git add .
git commit -m "feat: menambahkan halaman profil pengguna"
```

**Format Pesan Commit yang Disarankan:**
* `feat: ...` untuk penambahan fitur baru (contoh: `feat: integrasi api login`)
* `fix: ...` untuk perbaikan bug/error (contoh: `fix: memperbaiki tombol submit tidak aktif`)
* `style: ...` untuk perubahan tampilan/CSS tanpa mengubah logika
* `refactor: ...` untuk perapian struktur kode

### Langkah 4: Push Branch Fitur ke GitHub
Kirim branch kerja Anda ke repositori GitHub Organization:
```bash
git push -u origin fitur-nama-tugas
```

---

## 4. Pengajuan Pull Request (PR) untuk QC

Setelah selesai melakukan `git push`:
1. Buka halaman repositori **Siillora** di browser.
2. Klik tombol hijau **Compare & pull request** yang muncul di bagian atas.
3. **Pastikan arah penggabungan sudah benar:**
   * **Base:** `dev` *(tujuan penggabungan)*
   * **Compare:** `fitur-nama-tugas` *(branch kerja Anda)*
4. Isi judul dan deskripsi singkat mengenai apa saja yang sudah dikerjakan atau cara mengetesnya.
5. Klik **Create pull request** dan kabari Product Lead / QC untuk dilakukan pengecekan.

---

## 5. Sinkronisasi Jika Ada Perubahan dari Rekan Tim

Jika rekan developer lain baru saja menggabungkan fiturnya ke `dev` saat Anda masih mengerjakan branch fitur Anda, tarik pembaruan tersebut agar tidak terjadi *merge conflict* besar di akhir:

```bash
git checkout dev
git pull origin dev
git checkout fitur-nama-tugas
git merge dev
```
*(Jika muncul konflik file, selesaikan bagian kode yang bertabrakan di editor seperti VS Code, lalu lakukan `git add .` dan `git commit -m "chore: resolve merge conflict"`).*
