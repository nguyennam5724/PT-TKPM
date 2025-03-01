// controllers/ticket_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketController {
  // Lấy danh sách vé từ Firebase
  Future<List<Map<String, dynamic>>> getTicketsFromFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Người dùng chưa đăng nhập!");
      return [];
    }

    QuerySnapshot ticketSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tickets')
        .orderBy('timestamp', descending: true) // Sắp xếp theo thời gian
        .get();

    return ticketSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}