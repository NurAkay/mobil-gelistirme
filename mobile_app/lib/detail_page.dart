import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api.dart';
import 'person.dart';
import 'foto.dart';
import 'form_page.dart';

// Detay sayfası: sadece kişinin id'sini alır, verisini sunucudan çeker
// Sunucudan gelen "1994-04-12" tarihini "12.04.1994" biçimine çevirir
String tarihYaz(String t) => t.split('-').reversed.join('.');

class DetailPage extends StatefulWidget {
  final int id; //detay ekranına kişinin bütün bilgileri değil de sadece idsi gönderilir çünkü detay sayfası sunucudan veriyi çekecek
  const DetailPage({super.key, required this.id});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Person> kisi = getOne(widget.id); //getOne fonksiyonu ile sunucudan kişinin bilgilerini çeker

  // E-posta veya telefon uygulamasını açar (mailto: / tel:)
  void ac(String scheme, String deger) {
    launchUrl(Uri(scheme: scheme, path: deger));
  }

  // Silmeden önce onay penceresi gösterir
  Future<void> sil(Person p) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kişiyi sil'),
        content: Text('${p.fullName} silinsin mi?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hayır')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red), // onay butonu rengi
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Evet'),
          ),
        ],
      ),
    );
    if (onay == true) {
      await remove(p.id!); // DELETE isteği
      if (mounted) Navigator.pop(context); // listeye geri dön
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kişi Detay Bilgileri')),
      body: FutureBuilder<Person>(
        future: kisi,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final p = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 20),
              Foto(p.photoUrl, 120), // üstte büyük foto
              const SizedBox(height: 10),
              Text(p.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(p.department, style: const TextStyle(color: Colors.blue)),
              const SizedBox(height: 20),
              // Tek kart içinde 4 bilgi satırı
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    ListTile(title: Text('Doğum Yeri: ${p.birthPlace}')),
                    ListTile(title: Text('Doğum Tarihi: ${tarihYaz(p.birthDate)}')),
                    ListTile(
                      title: Text('E-posta: ${p.email}'),
                      textColor: Colors.blue, // mavi = tıklanabilir
                      onTap: () => ac('mailto', p.email), // tıklanınca mail uygulaması
                    ),
                    ListTile(
                      title: Text('Telefon: ${p.phone}'),
                      textColor: Colors.blue,
                      onTap: () => ac('tel', p.phone), // tıklanınca arama ekranı
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // Düzenle ve Sil butonları ekranın en altında sabit
      bottomNavigationBar: FutureBuilder<Person>(
        future: kisi,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final p = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text('DÜZENLE'),
                    //renk eklemek için style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 17, 110, 20), foregroundColor: Colors.white),
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => FormPage(person: p)));
                      setState(() {
                        kisi = getOne(widget.id); // düzenlemeden sonra bilgiyi yenile
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text('KİŞİYİ SİL'),
                    onPressed: () => sil(p),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
