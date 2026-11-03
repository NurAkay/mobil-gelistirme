import 'package:flutter/material.dart';
import 'api.dart';
import 'person.dart';

// Hem "Yeni Kişi" hem "Düzenle" ekranı. person verilirse düzenleme, verilmezse ekleme olur
class FormPage extends StatefulWidget {
  //person nullable ise düzenleme, null ise ekleme yapılır
  final Person? person;
  const FormPage({super.key, this.person});
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late TextEditingController ad, departman, foto, yer, tarih, eposta, telefon;
   
  //sayfa ilk açıldığında bir kere çalışır.
  @override
  void initState() {
    super.initState();

    final p = widget.person; // düzenlemede eski bilgiler kutulara dolar, eklemede boş kalır

    ad = TextEditingController(text: p?.fullName); //p?.fullname null değilse p.fullName, null ise null döner.
    departman = TextEditingController(text: p?.department);
    foto = TextEditingController(text: p?.photoUrl);
    yer = TextEditingController(text: p?.birthPlace);
    tarih = TextEditingController(text: p?.birthDate);
    eposta = TextEditingController(text: p?.email);
    telefon = TextEditingController(text: p?.phone);
  }
   
  //kaydet butonuna basıldığında çalışır. asenkrondur, bekleme süresi olabilir.
  Future<void> kaydet() async {
    //formdaki bilgileri alarak yeni bir id oluşturur ve Person nesnesi üretir
    final p = Person(
      id: widget.person?.id,
      fullName: ad.text,
      department: departman.text,
      photoUrl: foto.text,
      birthPlace: yer.text,
      birthDate: tarih.text,
      email: eposta.text,
      phone: telefon.text,
    );
    // person yoksa POST (yeni kayıt), varsa PUT (güncelleme)
    final basarili = widget.person == null ? await create(p) : await update(p);

    //sayfa artık ekranda değilse işlem yapılamsını engeller. mounted widgetin ekranda olup olmadığını kontrol eder.

    if (!mounted) return;
    if (basarili) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata! Alanları kontrol edin (tarih örn: 1994-04-12)')),
      );
    }
  }

  // Etiketli bir yazı kutusu üretir (kod tekrarını azaltmak için)
  Widget alan(TextEditingController c, String etiket) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(controller: c, decoration: InputDecoration(labelText: etiket, border: const OutlineInputBorder())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.person == null ? 'Yeni Kişi' : 'Kişiyi Düzenle')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          alan(ad, 'Ad Soyad'),
          alan(departman, 'Departman'),
          alan(foto, 'Fotoğraf URL'),
          alan(yer, 'Doğum Yeri'),
          alan(tarih, 'Doğum Tarihi (YYYY-AA-GG)'),
          alan(eposta, 'E-posta'),
          alan(telefon, 'Telefon'),
          ElevatedButton(onPressed: kaydet, child: const Text('KAYDET')),
        ],
      ),
    );
  }
}
