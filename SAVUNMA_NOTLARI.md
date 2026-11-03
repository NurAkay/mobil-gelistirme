# Sunum / Savunma Notları (repoya koymak zorunda değilsin, sadece sana)

## Sistem tek cümlede
Flutter uygulaması, HTTP ile Django REST API'ye JSON isteği atar. Django veriyi SQLite'ta tutar. Flutter gelen JSON'u `Person` nesnesine çevirip ekranda gösterir.

## Asenkron akış (en çok sorulacak konu)
- Ağ isteği zaman alır, uygulama donmasın diye `Future` / `async` / `await` kullanılır.
- `await http.get(...)`: cevap gelene kadar o fonksiyon bekler, ama arayüz donmaz.
- `FutureBuilder`: Future bitene kadar yükleme çemberi, bitince listeyi, hata olursa hata mesajını gösterir.
- `setState`: ekrana "veri değişti, yeniden çiz" der. Silme/ekleme sonrası listeyi yenilemek için kullanılır.

## Kütüphaneler: neden?
- `http`: REST isteklerini (GET/POST/PUT/DELETE) atmak için.
- `url_launcher`: `mailto:` ve `tel:` ile mail ve arama uygulamasını açmak için.
- Django tarafı: `rest_framework` (API), `corsheaders` (web'den farklı porttan istek gelebilsin diye).

## Dosya -> görev
| Dosya | Görev |
|---|---|
| models.py | Veritabanı tablosu |
| serializers.py | Nesne <-> JSON çevirici |
| views.py | CRUD mantığı (`ModelViewSet` hepsini hazır verir) |
| urls.py | Router, /api/persons adreslerini üretir |
| person.dart | JSON <-> Dart nesnesi (`fromJson` / `toJson`) |
| api.dart | 5 REST fonksiyonu |
| list_page.dart | Liste + FAB + detaya geçiş |
| detail_page.dart | Detay, mail/tel, düzenle, sil |
| form_page.dart | Ekle ve düzenle (aynı sayfa) |
| foto.dart | Dairesel foto widget'ı |

## Canlı değişiklik: nereyi değiştireceksin?
| İstek | Yer |
|---|---|
| Kartta departman yerine telefon göster | list_page.dart: `subtitle: Text(p.department)` -> `Text(p.phone)` |
| Silme onayı buton rengi | detail_page.dart: `foregroundColor: Colors.red` |
| Sil butonunun rengi | detail_page.dart: `backgroundColor: Colors.red` |
| Başlık yazısı | ilgili sayfadaki `AppBar(title: ...)` |
| Fotoğraf boyutu | `Foto(p.photoUrl, 48)` -> sayıyı değiştir |
| Doğum tarihi formatı | detail_page.dart: `tarihYaz` fonksiyonu |
| Listeye yeni alan (örn. e-posta) göster | list_page.dart: `subtitle` içine `p.email` ekle |
| FAB ikonu | `Icon(Icons.add)` |
| Sunucu adresi | api.dart: `sunucu` |

## Sık sorulacak sorular
- **Neden `int? id`?** Yeni kişide id yoktur, sunucu üretir. Boş olabilir demek için `?`.
- **`fromJson` ne yapar?** Sunucudan gelen Map'i `Person` nesnesine çevirir.
- **`utf8.decode(r.bodyBytes)` neden?** Türkçe karakterler (ş, ğ, ı) bozulmasın diye.
- **POST ile PUT farkı?** POST yeni kayıt oluşturur (201), PUT var olanı günceller (200).
- **`if (!mounted) return;` ne?** await sonrası sayfa kapanmış olabilir, kapandıysa ekranla işlem yapma.
- **Neden `Navigator.pop` sonrası `yenile()`?** Detay/Form'dan dönünce liste eski kalmasın diye `await Navigator.push` bitince listeyi tekrar çekiyoruz.
- **CORS nedir?** Tarayıcı, farklı porttan (Flutter web) gelen isteği varsayılan olarak engeller. `corsheaders` ile izin veriyoruz.
- **`ModelViewSet` ne?** DRF'in hazır sınıfı: liste, tek kayıt, ekleme, güncelleme, silme.
- **`DefaultRouter` ne?** ViewSet için URL adreslerini otomatik oluşturur.
- **`migrate` ne yapar?** Model tanımını veritabanında gerçek tabloya çevirir.
