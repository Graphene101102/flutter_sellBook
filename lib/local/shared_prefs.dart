import 'dart:convert';

import 'package:sell_book/models/invoice.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharePrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<Invoice>?> loadInvoices() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('bills');
    if (data == null) return null;

    List<Map<String, dynamic>> maps =
        jsonDecode(data).cast<Map<String, dynamic>>()
            as List<Map<String, dynamic>>; // cast để chuyển đổi kiểu dữ liệu
    List<Invoice> bills = maps.map((e) => Invoice.fromJson(e)).toList();
    return bills;
  }

  Future<void> saveInvoices(List<Invoice> bills) async {
    List<Map<String, dynamic>> maps = bills.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('bills', jsonEncode(maps));
  }
}