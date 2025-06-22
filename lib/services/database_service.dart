import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DataBaseService {
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<T> getData<T>(String path, ) async {
    final ref = database.ref(path);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.value as T;
    } else {
      throw Exception("No data found at $path");
    }
  }

  Future<T> setData<T>(String path, T data) async {
    final ref = database.ref(path);
    await ref.set(data);
    return data;
  }

  DateTime getCurrentDate() {
    return DateTime.now();
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}