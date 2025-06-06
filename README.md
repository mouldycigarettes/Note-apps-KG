# Simple Notes App

---

# Simple Notes App

Simple Notes App adalah aplikasi Flutter dasar yang memungkinkan Anda untuk membuat, melihat, mengedit, dan menghapus catatan. Data catatan disimpan secara lokal di perangkat Anda menggunakan `shared_preferences`.

---

## Cara Instalasi dan Menjalankan Aplikasi

Ikuti langkah-langkah di bawah ini untuk menginstal dan menjalankan aplikasi ini di lingkungan pengembangan lokal Anda.

### Prasyarat

Pastikan Anda telah menginstal yang berikut:

* **Flutter SDK**: Versi terbaru dari Flutter. Kunjungi [flutter.dev](https://flutter.dev/docs/get-started/install) untuk panduan instalasi.
* **Editor Kode**: Visual Studio Code dengan ekstensi Flutter/Dart, atau Android Studio dengan plugin Flutter/Dart.

### Langkah-langkah Instalasi

1.  **Klon Repositori** (jika aplikasi Anda berada di repositori Git):
    ```bash
    git clone https://github.com/mouldycigarettes/Note-apps-KG.git
    cd Note-apps-KG
    ```
    Jika Anda hanya memiliki file-nya, cukup letakkan semua file dalam satu folder proyek.

2.  **Dapatkan Dependensi**:
    Navigasikan ke direktori proyek Anda di terminal atau command prompt, lalu jalankan perintah berikut untuk mengunduh semua paket yang diperlukan:
    ```bash
    flutter pub get
    ```

3.  **Jalankan Aplikasi**:
    Pastikan Anda memiliki perangkat Android/iOS yang terhubung (mode debugging diaktifkan), atau emulator/simulator yang berjalan. Kemudian, jalankan aplikasi dengan perintah:
    ```bash
    flutter run
    ```
    Aplikasi akan dibangun dan diluncurkan di perangkat atau emulator yang terdeteksi.

---

Catatan: shared_preferences tidak bisa digunakan pada mode browser
