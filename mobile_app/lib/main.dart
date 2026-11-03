import 'package:flutter/material.dart';
import 'list_page.dart';

void main() {
  runApp(const MaterialApp( //runapp verilen widgetı ekrana çizer. material app material tasarımın iskeleti, sayfa geçişleri vs buna bağlı calısır.
    debugShowCheckedModeBanner: false, //sag ustteki kırmızı debug abndını gizler.
    home: ListPage(), // uygulama açılınca ilk bu sayfa gelir
  ));
}
