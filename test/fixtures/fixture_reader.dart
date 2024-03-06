import 'dart:io';

///Hilfsmethode: List Inhalt einer Datei und gibt sie als String zurück
String fixture(String name) => File("test/fixtures/$name").readAsStringSync();