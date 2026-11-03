// Sunucu ile konuşan tüm fonksiyonlar burada (REST istekleri)
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'person.dart';

// Sunucu adresi: Android emülatörde bilgisayara 10.0.2.2 ile ulaşılır, web/Windows'ta 127.0.0.1
// GERÇEK TELEFONDA: aşağıdaki satırı  final String sunucu = '192.168.1.X';  (bilgisayarın IP'si) yapın
final String sunucu = (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) ? '10.0.2.2' : '127.0.0.1';
final String url = 'http://$sunucu:8000/api/persons';
const headers = {'Content-Type': 'application/json'};

// GET /api/persons -> tüm kişiler
Future<List<Person>> getAll() async {
  final r = await http.get(Uri.parse(url));
  final liste = jsonDecode(utf8.decode(r.bodyBytes)) as List; // utf8: Türkçe harfler için
  return liste.map((e) => Person.fromJson(e)).toList(); //listedeki her json aprcasını persona cevirip yeni liste yapar.
}

// GET /api/persons/{id} -> tek kişi
Future<Person> getOne(int id) async {
  final r = await http.get(Uri.parse('$url/$id'));
  return Person.fromJson(jsonDecode(utf8.decode(r.bodyBytes)));
}

// POST /api/persons -> yeni kişi (başarılıysa 201 döner)
Future<bool> create(Person p) async {
  final r = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(p.toJson()));
  return r.statusCode == 201;
}

// PUT /api/persons/{id} -> kişiyi güncelle (başarılıysa 200 döner)
Future<bool> update(Person p) async {
  final r = await http.put(Uri.parse('$url/${p.id}'), headers: headers, body: jsonEncode(p.toJson()));
  return r.statusCode == 200;
}

// DELETE /api/persons/{id} -> kişiyi sil
Future<void> remove(int id) async {
  await http.delete(Uri.parse('$url/$id'));
}
