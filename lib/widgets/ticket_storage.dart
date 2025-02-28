import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TicketStorage {
  // Lưu thông tin vé vào SharedPreferences
  static Future<void> saveTickets(List<Map<String, String>> tickets) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ticketsJson = jsonEncode(tickets);  // Chuyển đổi danh sách vé thành chuỗi JSON
      await prefs.setString('tickets', ticketsJson);  // Lưu chuỗi JSON vào SharedPreferences
      print("Tickets saved successfully.");
    } catch (e) {
      print("Error saving tickets: $e");
    }
  }

  // Lấy thông tin vé từ SharedPreferences
  static Future<List<Map<String, String>>> getTickets() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ticketsJson = prefs.getString('tickets');  // Lấy chuỗi JSON từ SharedPreferences

      if (ticketsJson != null) {
        List<dynamic> decodedList = jsonDecode(ticketsJson);  // Giải mã chuỗi JSON thành danh sách
        return List<Map<String, String>>.from(decodedList.map((ticket) => Map<String, String>.from(ticket)));
      }
      return [];  // Nếu không có vé, trả về danh sách trống
    } catch (e) {
      print("Error loading tickets: $e");
      return [];  // Trả về danh sách trống nếu có lỗi
    }
  }

  // Thêm vé mới vào danh sách vé hiện tại
  static Future<void> addTicket(Map<String, String> newTicket) async {
    try {
      List<Map<String, String>> currentTickets = await getTickets();
      currentTickets.add(newTicket);  // Thêm vé mới vào danh sách vé
      await saveTickets(currentTickets);  // Lưu lại danh sách vé đã được cập nhật
      print("Ticket added successfully.");
    } catch (e) {
      print("Error adding ticket: $e");
    }
  }

  static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Đã xóa toàn bộ dữ liệu trong SharedPreferences");
  }
}