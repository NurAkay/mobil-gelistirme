import 'package:flutter/material.dart';
import 'api.dart';
import 'person.dart';
import 'foto.dart';
import 'detail_page.dart';
import 'form_page.dart';

// Ana sayfa: kişilerin eklendiği ekran. Sunucudan kişi listesi çekilir ve ListView ile gösterilir. + butonuna basınca FormPage açılır, kişi eklenir ve geri dönünce liste yenilenir.
class ListPage extends StatefulWidget {
  const ListPage({super.key});
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // Sunucudan gelecek liste (asenkron: cevap sonra gelir)
  //future çünkü işlem hemen sonuçlanmayabilir, sunucudan cevap daha sonra gelir. getall() api uzerinden bütün kişileri getirir.
  late Future<List<Person>> kisiler = getAll();

  // Listeyi sunucudan yeniden çeker ve setstate ile yeniden çiz der. kişi eklenip dondugunde bu cagrılır yeni kişi görünür.
  void yenile() {
    setState(() {
      kisiler = getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rehber / Kişi Listesi')),
      body: FutureBuilder<List<Person>>(
        //future builder sunucudan cevap beklerken ekranda ne gösterilecek. snapshot futureın o anki durumunu tutan kutu. snapshot o anki durumu tutar. snapshot.hasData true ise veri geldi demektir. snapshot.data ile veriye ulaşılır.
        future: kisiler,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Sunucuya bağlanılamadı'));

          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final liste = snapshot.data!;

          if (liste.isEmpty) return const Center(child: Text('Henüz kişi yok, + ile ekleyin'));

          // ListView.builder: kaydırılabilir dinamik liste. listede 3 kişi varsa 3 satır üret.
          return ListView.builder(
            itemCount: liste.length,
            itemBuilder: (context, i) {
              final p = liste[i];
              return ListTile(
                
                leading: Foto(p.photoUrl, 48), // solda daire foto buradaki 48 piksel boyutunda gösterilir.

                title: Text(p.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(p.department),
                onTap: () async {
                  // satıra tıklayınca kişinin id'si ile detay sayfası açılır. mevcut ekran üzerine yeni sayfa açar.
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(id: p.id!)));
                  yenile(); // geri dönünce liste güncellensin (silme/düzenleme olmuş olabilir)
                },
              );
            },
          );
        },
      ),
      // Sağ altta sabit + butonu
      floatingActionButton: FloatingActionButton(
        //buton rengini burdan backgroundcolor ıle degsıtırebılırsın.
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const FormPage()));
          yenile();
        },
      ),
    );
  }
}
