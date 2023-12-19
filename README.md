<p align="center">
  <img src="https://i.imgur.com/U1KBGMc.jpg" height="300" alt="BookBuffet Logo"/>
</p>
<p align="center">
  <em>📚 BookBuffet: Your Ultimate Book Database - Just Like IMDb, but for Literature! 📚   </em>
</p>
<p align="center">
    <img alt="License" src="https://img.shields.io/github/license/pbp-c12-gacor/BookBuffet">
    <img alt="Last commit" src="https://img.shields.io/github/last-commit/pbp-c12-gacor/BookBuffet">
    [![Build status](https://build.appcenter.ms/v0.1/apps/405fd5cd-3914-4304-95c0-df94c8763aca/branches/main/badge)](https://appcenter.ms)
  
</p>

# 📖 BookBuffet 📖
## 📑 Table of Contents 📑
- [📖 BookBuffet 📖](#-bookbuffet-)
  - [📑 Table of Contents 📑](#-table-of-contents-)
  - [👥 Anggota Kelompok C-12 👥](#-anggota-kelompok-c-12-)
  - [📚 Latar Belakang BookBuffet 📚](#-latar-belakang-bookbuffet-)
  - [📂 Daftar Modul 📂](#-daftar-modul-)
    - [✨ Book Catalogue ✨](#-book-catalogue-)
    - [🗞️ Publish a New Book 🗞️](#️-publish-a-new-book-️)
    - [💬 Community Forum 💬](#-community-forum-)
    - [🔮 My Book 🔮](#-my-book-)
    - [❗ Report Book ❗](#-report-book-)
  - [🗺️ Sumber Dataset Katalog Buku 🗺️](#️-sumber-dataset-katalog-buku-️)
  - [🎭 Role Pengguna 🎭](#-role-pengguna-)
  - [🔗 Referensi 🔗](#-referensi-)
  - [📝 License 📝](#-license-)

## 👥 Anggota Kelompok C-12 👥
* [Ricardo Palungguk Natama](https://github.com/odracheer) (2206082700)
* [Faris Zhafir Faza](https://github.com/Marsupilamieue) (2206081931)
* [Fiona Ratu Maheswari]( https://github.com/fionafrm) (2206024575)
* [Muhammad Faishal Adly Nelwan](https://github.com/pesolosep) (2206030754)
* [Muhammad Andhika Prasetya](https://github.com/andhikapraa) (2206031302)

## 📚 Latar Belakang BookBuffet 📚
Mengingat perkembangan teknologi yang sangat pesat saat ini, kita dapat melihat bahwa telah terjadi perubahan signifikan dalam pola perilaku masyarakat. Kini, masyarakat cenderung menggunakan perangkat seluler dalam mengakses informasi. Hal ini dikarenakan mudahnya proses mengakses informasi apapun dari internet melalui perangkat seluler yang mereka miliki. Namun, masih terdapat tantangan yang dialami oleh masyarakat, seperti kesulitan dalam memilih buku sesuai dengan minat pribadi. BookBuffet hadir sebagai solusi untuk tantangan ini.</br>

Dilengkapi dengan fitur Recommendation, BookBuffet hadir untuk memberikan informasi terkait buku-buku yang cocok dengan minat Anda. Fitur ini juga didasarkan oleh ulasan-ulasan pengguna lainnya. Tidak hanya itu, BookBuffet juga hadir dengan fitur My Books, di mana Anda dapat menyimpan judul buku-buku yang telah Anda baca dan Anda juga dapat memberikan ulasan terhadap buku tersebut. BookBuffet juga menyediakan sebuah forum diskusi di mana Anda dapat berdiskusi tentang buku sepuasnya. Selain itu, Anda juga dapat menambahkan buku Anda ke katalog yang kami miliki. Anda juga tidak perlu khawatir jika mendapati suatu kendala ketika menggunakan BookBuffet ini. Terdapat fitur Report Book yang siap membantu Anda dalam menyelesaikan masalah. Kami harap dengan adanya aplikasi BookBuffet ini dapat membantu Anda dalam memilih buku yang akan Anda baca.

## 🔗 Integrasi dengan Situs Web 🔗
Berikut adalah langkah-langkah yang akan dilakukan untuk mengintegrasikan aplikasi dengan server web:

1. Mengimplementasikan sebuah _wrapper class_ dengan menggunakan library _http_ dan _map_ untuk mendukung penggunaan _cookie-based authentication_ pada aplikasi.
2. Mengimplementasikan REST API pada Django (views.<area>py) dengan menggunakan JsonResponse atau Django JSON Serializer.
3. Mengimplementasikan desain _front-end_ untuk aplikasi berdasarkan desain website yang sudah ada sebelumnya.
4. Melakukan integrasi antara _front-end_ dengan _back-end_ dengan menggunakan konsep _asynchronous_ HTTP.

## 📂 Daftar Modul 📂
Berikut ini beberapa modul yang digunakan pada aplikasi BookBuffet:

### ✨ Book Catalogue ✨
#### Dikerjakan oleh : Muhammad Andhika Prasetya
Pada tampilan _Catalogue page_, pengguna dapat melihat buku-buku yang ada pada aplikasi BookBuffet. Pengguna akan mendapat rekomendasi serta mencari buku-buku yang ada melalui _filtering_ baik berdasarkan genre, _rating_ tertinggi dan terendah, dan _most recent upload_. Ketika suatu buku dipilih, tampilannya akan berisi _cover_, judul, tanggal publikasi, deskripsi, _rating_, dan ulasan-ulasan terhadap buku tersebut.

### 🗞️ Publish a New Book 🗞️
#### Dikerjakan oleh : Ricardo Palungguk Natama
Pada tampilan _Publish A New Book page_, pengguna _role_ `User` juga dapat meng-_upload_ suatu buku yang belum ada di katalog aplikasi BookBuffet. Akan tetapi, fitur ini akan melewati proses _screening_ dahulu oleh `Admin`. Jika proses _screening_ sudah selesai, maka buku akan di-_upload_ oleh `Admin` di aplikasi dan dapat diakses oleh semua Pengguna.

### 💬 Community Forum 💬
#### Dikerjakan oleh : Faris Zhafir Faza
Pada tampilan _Community page_, Pengguna role `User` dapat melakukan diskusi dengan Pengguna lainnya tentang buku. Pengguna akan mendiskusikan buku-buku berdasarkan genre buku atau bahkan buku yang dipilih.

### 🔮 My Books 🔮
#### Dikerjakan oleh : Muhammad Faishal Adly Nelwan
Pada tampilan My Books aplikasi BookBuffet, Pengguna bisa menyimpan _list_ buku yang sedang dibaca. Pengguna dapat menambahkan buku ke dalam _list_ berdasarkan daftar buku yang ada di aplikasi BookBuffet. Pengguna juga bisa melaporkan _progress tracking_ terhadap pembacaan buku yang sudah ditambah. Jika Pengguna sudah selesai membaca buku tersebut, maka Pengguna dapat mengklik selesai terhadap buku tersebut. Pengguna juga bisa memberikan ulasan dan _rating_ terhadap buku tersebut.

### ❗ Report Book ❗
#### Dikerjakan oleh : Fiona Ratu Maheswari
Pengguna _role_ `User` dan `Admin` memiliki opsi untuk me-_report_ buku agar dapat ditinjau ulang oleh `Admin`. Pengguna akan memilih buku yang ingin di-_report_. Lalu, Pengguna wajib memberi alasan mengapa buku tersebut di-_report_. Report tersebut lalu akan di-_review_ oleh `Admin`. Selain itu, `Admin` juga bisa menghapus _report_ yang dibuat oleh `User` maupun `Admin`.

## 🗺️ Sumber Dataset Katalog Buku 🗺️
Dataset yang digunakan pada aplikasi BookBuffet ini diambil dari [Google Books API](https://developers.google.com/books/docs/v1/using). Dataset ini berisi informasi mengenai buku-buku yang ada di Google Books. Dataset ini berisi informasi mengenai judul buku, penulis, tanggal publikasi, _rating_, dan deskripsi buku. Dataset ini juga berisi _cover_ buku yang dapat digunakan sebagai _thumbnail_ pada aplikasi BookBuffet.

## 🎭 Role Pengguna 🎭
| Peran   | Hak Akses                                                                                              |
|---------|--------------------------------------------------------------------------------------------------------|
| Guest   |   - Melihat daftar buku yang ada pada katalog aplikasi.                                                |
|         |   - Melihat detail buku yang ada pada katalog aplikasi.                                                |
|         |   - Melihat forum diskusi yang ada pada laman community.                                               |
| User    |   User dapat mengakses semua fitur `Guest` dan:                                                        |
|         |   - Mengakses fitur My Books (menambahkan buku ke dalam list, melaporkan progress, dan memberi ulasan).|
|         |   - Melakukan diskusi pada laman _community_.                                                          |
|         |   User dapat mengakses semua fitur berikut, tetapi harus meminta izin `Admin`:                         |
|         |   - Melaporkan suatu buku agar dihapus dari katalog.                                                   |
|         |   - Menambah forum diskusi pada laman _community_.                                                     |
|         |   - Menambahkan suatu buku ke katalog aplikasi.                                                        |
| Admin   |   Admin dapat mengakses semua fitur `User` dan:                                                        |
|         |   - Menghapus suatu buku dari katalog berdasarkan laporan yang diberi `User`.                          |
|         |   - Menambahkan suatu buku ke katalog aplikasi.                                                        |

## 🔗 Referensi 🔗
* Buku Digital Lebih Banyak diminati Daripada Buku Cetak. (2022, Januari 14). Amerta Media. Retrieved Oktober 10, 2023, from https://amertamedia.co.id/buku-digital-lebih-banyak-diminati-daripada-buku-cetak/

## 📝 License 📝
[MIT License](https://choosealicense.com/licenses/mit/)

## Berita Acara
https://drive.google.com/drive/u/0/folders/1jxH4-GFrE9VZxaPqCS7C6Cq5AjS_Z78p
