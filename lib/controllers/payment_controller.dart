// controllers/payment_controller.dart
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviego/widgets/dialog_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController {
  final String movieTitle;
  final String cinemaName;
  final String cinemaAddress;
  final String cinemaImage;
  final int totalPrice;
  final List<String> selectedSeats;
  final String showTime;
  final DateTime showDate;
  final String moviePoster;
  final List<String> genres;
  final int movieRuntime;

  String selectedPaymentMethod = '';
  final TextEditingController textController = TextEditingController();
  final List<String> discountCode = ['moviego', 'phenikaa'];
  int discount = 0;
  late String orderID;

  PaymentController({
    required this.movieTitle,
    required this.cinemaName,
    required this.cinemaAddress,
    required this.cinemaImage,
    required this.totalPrice,
    required this.selectedSeats,
    required this.showTime,
    required this.showDate,
    required this.moviePoster,
    required this.genres,
    required this.movieRuntime,
  }) {
    orderID = generateID();
  }

  // Tạo orderID ngẫu nhiên
  String generateID() {
    Random random = Random();
    String id = '';
    for (int i = 0; i < 11; i++) {
      id += random.nextInt(10).toString();
    }
    return id;
  }

  // Chọn phương thức thanh toán
  void selectPaymentMethod(String method, Function setState) {
    setState(() => selectedPaymentMethod = method);
    print('Phương thức thanh toán đã chọn: $selectedPaymentMethod');
  }

  // Áp dụng mã giảm giá
  void applyDiscount(Function setState, BuildContext context) {
    String enteredCode = textController.text.trim();
    if (discountCode.contains(enteredCode)) {
      setState(() => discount = 50000);
      DialogHelper.showCustomDialog(context, "Mã giảm giá hợp lệ!", "Giảm 50k cho đơn hàng của bạn.");
    } else {
      setState(() => discount = 0);
      DialogHelper.showCustomDialog(context, "Mã giảm giá không hợp lệ!", "Mã giảm giá bạn nhập không đúng.");
    }
  }

  // Lưu thông tin thanh toán vào Firebase
  Future<void> savePaymentInfoToFirebase(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Người dùng chưa đăng nhập!");
        throw Exception("User not logged in");
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tickets')
          .doc(orderID)
          .set({
        'orderID': orderID,
        'movieTitle': movieTitle,
        'cinemaName': cinemaName,
        'cinemaAddress': cinemaAddress,
        'cinemaImage': cinemaImage,
        'selectedSeats': selectedSeats,
        'totalPrice': totalPrice - discount,
        'showTime': showTime,
        'showDate': DateFormat('yyyy-MM-dd').format(showDate),
        'moviePoster': moviePoster,
        'genres': genres,
        'movieRuntime': movieRuntime,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Vé đã được lưu vào Firebase với orderID: $orderID");
      await saveBookedSeats(selectedSeats);
    } catch (e) {
      print("Lỗi khi lưu vé: $e");
      throw Exception("Không thể lưu vé: $e");
    }
  }

  // Lưu ghế đã đặt vào SharedPreferences
  Future<void> saveBookedSeats(List<String> seats) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookedSeats', seats);
    print("Booked seats saved successfully.");
  }

  // Xóa toàn bộ SharedPreferences (nếu cần)
  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Đã xóa toàn bộ dữ liệu trong SharedPreferences");
  }

  void dispose() {
    textController.dispose();
  }
}