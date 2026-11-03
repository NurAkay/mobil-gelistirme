// Kişi modeli: API'den gelen JSON'un Dart'taki karşılığı
class Person {
  int? id; // yeni kişi eklerken henüz id yok, o yüzden "?" (boş olabilir)
  String fullName, department, photoUrl, birthPlace, birthDate, email, phone;


  //this gelen değeri alana atar.
  Person({
    this.id,
    required this.fullName,
    required this.department,
    required this.photoUrl,
    required this.birthPlace,
    required this.birthDate,
    required this.email,
    required this.phone,
  });

  // JSON (Map) -> Person nesnesi
  //apiden gelen json verisini dart nesnesine dönüştürür.
  //factory constructor kullanılır çünkü Person nesnesi oluşturulurken id alanı null olabilir yani kontrol edilmesi gerekir. Factory constructor, nesne oluşturulmadan önce gerekli kontrolleri yapabilir.
  factory Person.fromJson(Map<String, dynamic> j) => Person(
        id: j['id'],
        fullName: j['fullName'],
        department: j['department'],
        photoUrl: j['photoUrl'],
        birthPlace: j['birthPlace'],
        birthDate: j['birthDate'],
        email: j['email'],
        phone: j['phone'],
      );

  // Person nesnesi -> JSON (Map). Sunucuya göndermek için, yeni kişi eklerken veya güncellerken sunucuya göndermek için kullanılır.
  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'department': department,
        'photoUrl': photoUrl,
        'birthPlace': birthPlace,
        'birthDate': birthDate,
        'email': email,
        'phone': phone,
      };
}
