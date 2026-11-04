# Kişi Yönetim Sistemi — Flutter + Django REST Framework

Mobil Programlama Dersi Vize Projesi. İki ayrı klasör vardır:

- `backend_api/` : Django REST Framework ile yazılmış REST API
- `mobile_app/`  : Flutter mobil / web istemcisi

> **Teslim notu:** Mobil uygulamanın test paketi olarak bu belgedeki **Bölüm 4 (Test Kılavuzu)** esas alınmıştır. APK üretmek isteğe bağlıdır (Bölüm 3).

---
## 1) Backend (API) Kurulumu

Gereksinim: Python 3.10+

```bash
cd backend_api
python -m venv .venv
.venv\Scripts\activate            # Windows
source .venv/bin/activate         # Mac/Linux (Mac/Linux'ta python yerine python3 gerekebilir)
pip install -r requirements.txt
python manage.py migrate          # veritabanı tablolarını oluşturur
python manage.py runserver 0.0.0.0:8000
```
Kontrol: tarayıcıda http://127.0.0.1:8000/api/persons açılınca `[]` (boş liste) görünmelidir. Veritabanı boş başlar, kişiler uygulamadan eklenir.

### Uç Noktalar
| Metot | Adres | Açıklama |
|---|---|---|
| GET | /api/persons | Tüm kişileri listeler |
| GET | /api/persons/{id} | Tek kişinin detayı |
| POST | /api/persons | Yeni kişi ekler |
| PUT | /api/persons/{id} | Kişiyi günceller |
| DELETE | /api/persons/{id} | Kişiyi siler |

---
## 2) Mobil Uygulama Kurulumu

Gereksinim: Flutter SDK (3.x). Backend çalışıyor olmalıdır.

```bash
cd mobile_app
flutter create --project-name mobile_app .   # android/ios/web klasörlerini üretir (lib ve pubspec'e dokunmaz)
```
`test/widget_test.dart` dosyasını silin (otomatik üretilen, bu projede gerekmiyor). Sonra:

```bash
flutter pub get
flutter run -d chrome        # Web'de çalıştırma
flutter run                  # Emülatör / bağlı telefonda çalıştırma
```

### Android için gerekli ayar (sadece emülatör, telefon ve APK için; Chrome'da gerekmez)
`mobile_app/android/app/src/main/AndroidManifest.xml` dosyasında:

1. `<application` satırından **önce** şunu ekleyin:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<queries>
    <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="tel"/></intent>
    <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="mailto"/></intent>
</queries>
```
2. `<application` etiketinin içine `android:usesCleartextTraffic="true"` ekleyin (http:// adresine izin verir).

### Sunucu adresi
`mobile_app/lib/api.dart` içindeki `sunucu` değişkeni:
| Çalıştırılan yer | Adres |
|---|---|
| Web (Chrome) / Windows | 127.0.0.1 (otomatik) |
| Android emülatör | 10.0.2.2 (otomatik) |
| Gerçek telefon | Bilgisayarın yerel IP'si (örn. 192.168.1.X), aynı Wi-Fi'de olmalı. `sunucu` satırını elle değiştirin |

---
## 3) APK Üretme (isteğe bağlı)
```bash
cd mobile_app
flutter build apk --release
```
Çıktı: `mobile_app/build/app/outputs/flutter-apk/app-release.apk`
(Gerçek telefonda denemek için önce `api.dart` içindeki IP'yi ayarlayın, sonra APK üretin.)

## 4) Test Kılavuzu
1. Backend'i başlat, http://127.0.0.1:8000/api/persons adresinde `[]` gör.
2. Uygulamayı aç: liste boş olmalı ("Henüz kişi yok" yazısı).
3. **+** butonuyla birkaç kişi ekle. Fotoğraf URL kutusuna aşağıdaki örneklerden biri yazılabilir, boş da bırakılabilir. Doğum tarihi `1994-04-12` biçiminde girilir.
   - https://picsum.photos/seed/ahmet/300
   - https://picsum.photos/seed/ayse/300
   - https://picsum.photos/seed/mehmet/300
4. Eklenen kişi listeye döndüğünde görünmeli (dairesel foto, kalın ad soyad, altında departman).
5. Bir kişiye tıkla: detay açılmalı. E-posta/telefona tıklayınca mail ve arama uygulaması açılmalı (telefonda veya emülatörde).
6. Detayda **DÜZENLE** ile bilgi değiştir, kaydet, detayda güncellenmiş görünmeli.
7. **KİŞİYİ SİL** -> onay diyaloğu -> Evet -> listeye dönülür, kişi yok olmalı.



