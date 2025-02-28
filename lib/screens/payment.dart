import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:moviego/screens/ticket.dart';
import 'package:moviego/widgets/bottom_app_bar.dart';
import 'package:moviego/widgets/dialog_helper.dart';
import 'package:moviego/widgets/ticket_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
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

  const Payment(
      {super.key,
      required this.movieTitle,
      required this.cinemaName,
      required this.selectedSeats,
      required this.showTime,
      required this.showDate,
      required this.totalPrice,
      required this.moviePoster,
      required this.genres, required this.cinemaAddress, required this.cinemaImage, required this.movieRuntime});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String selectedPaymentMethod = '';
  TextEditingController controller = TextEditingController();
  List<String> discountCode = ['moviego', 'phenikaa'];
  int discount = 0;
  late String orderID = '';



  String generateID() {
    Random random = Random();
    for (int i = 0; i < 11; i++) {
      orderID += random.nextInt(10).toString();
    }
    return orderID;
  }

  @override
  void initState() {
    super.initState();
    orderID = generateID();
  }

  void applyDiscount() {
    String enteredCode = controller.text.trim();

    if (discountCode.contains(enteredCode)) {
      setState(() {
        discount = 50000;
      });

      // Hiển thị hộp thoại khi mã giảm giá hợp lệ

      DialogHelper.showCustomDialog(
          context, "Mã giảm giá hợp lệ!", "Giảm 50k cho đơn hàng của bạn.");
    } else {
      setState(() {
        discount = 0;
      });
      DialogHelper.showCustomDialog(context, "Mã giảm giá không hợp lệ!",
          "Mã giảm giá bạn nhập không đúng.");
    }
  }

  Future<void> clearSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print("Đã xóa toàn bộ dữ liệu trong SharedPreferences");
}

Future<void> saveBookedSeats(List<String> selectedSeats) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('bookedSeats', selectedSeats);
  print("Booked seats saved successfully.");
}

Future<void> savePaymentInfoToFirebase({
  required String movieTitle,
  required String cinemaName,
  required List<String> selectedSeats,
  required int totalPrice,
  required String showTime,
  required DateTime showDate,
}) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Người dùng chưa đăng nhập!");
      return;
    }

    // Sử dụng orderID đã tạo trong class thay vì tạo mới
    String orderId = orderID;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tickets')
        .doc(orderId)
        .set({
      'orderID': orderId, // Thêm orderID để sử dụng trong TicketPage
      'movieTitle': movieTitle,
      'cinemaName': cinemaName,
      'cinemaAddress': widget.cinemaAddress, // Thêm thông tin bổ sung
      'cinemaImage': widget.cinemaImage,
      'selectedSeats': selectedSeats,
      'totalPrice': totalPrice,
      'showTime': showTime,
      'showDate': DateFormat('yyyy-MM-dd').format(showDate),
      'moviePoster': widget.moviePoster,
      'genres': widget.genres,
      'movieRuntime': widget.movieRuntime,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print("Vé đã được lưu vào Firebase với orderID: $orderId");

    // Lưu ghế đã đặt vào SharedPreferences (nếu cần)
    await saveBookedSeats(selectedSeats);

    // Chuyển sang trang Ticket ngay sau khi lưu thành công
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(initialIndex: 1,),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  } catch (e) {
    print("Lỗi khi lưu vé: $e");
    DialogHelper.showCustomDialog(
        context, "Lỗi", "Không thể lưu vé, vui lòng thử lại!");
  }
}






  @override
  Widget build(BuildContext context) {
    GestureDetector buildPaymentMethod(
        {required String image, required String content}) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedPaymentMethod = content;
          });
          print('Phương thức thanh toán đã chọn: $selectedPaymentMethod');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selectedPaymentMethod == content
                ? const Color(0xFF261D08)
                : const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(10),
            border: selectedPaymentMethod == content
                ? Border.all(color: const Color(0xFFFCC434))
                : null,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          
          padding: const EdgeInsets.only(top: 8.0, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildInforMovie(),

              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order ID",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    orderID,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Seat",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(widget.selectedSeats.join(', '),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.local_offer_rounded,
                            color: Color(0xFFFCC434),
                          ),
                          hintText: 'Discount Code',
                          border: InputBorder.none),
                      controller: controller,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      applyDiscount();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFCC434), // Màu nền của container
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 28, vertical: 11),
                          child: Text(
                            "Apply",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold), // Màu chữ trắng
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              const SizedBox(
                height: 25,
              ),
              const Divider(
                color: Color(0xFF2E2E2E),
                height: 0.2,
                thickness: 1,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                      NumberFormat.currency(locale: "vi_VN", symbol: "VND ")
                          .format(widget.totalPrice - discount),
                      style: const TextStyle(
                          color: Color(0xFFFCC434),
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Payment Method",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              buildPaymentMethod(
                  image: "assets/images/Zalopay.png", content: "Zalo Pay"),
              const SizedBox(
                height: 8,
              ),
              buildPaymentMethod(
                  image: "assets/images/Momo.png", content: "MoMo"),
              const SizedBox(
                height: 8,
              ),
              buildPaymentMethod(
                  image: "assets/images/ShopeePay.png", content: "Shopee Pay"),
              const SizedBox(
                height: 8,
              ),
              buildPaymentMethod(
                  image: "assets/images/ATM.png", content: "ATM Card"),
              const SizedBox(
                height: 8,
              ),
              buildPaymentMethod(
                  image: "assets/images/Visa.png",
                  content: "International payments"),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCC434),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: TextButton(
                    onPressed: () {
                      if (selectedPaymentMethod.isEmpty) {
                        DialogHelper.showCustomDialog(context, "Thông báo",
                            "Vui lòng chọn phương thức thanh toán trước khi tiếp tục!");
                      } else {
                        print(orderID);
                        savePaymentInfoToFirebase(
                          movieTitle: widget.movieTitle,
                          cinemaName: widget.cinemaName,
                          totalPrice: widget.totalPrice - discount,
                          selectedSeats: widget.selectedSeats,
                          showTime: widget.showTime,
                          showDate: widget.showDate,
                        );

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const MainScreen(initialIndex: 1,),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildInforMovie() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0)),
            child: Image.network(
              "https://image.tmdb.org/t/p/original${widget.moviePoster}",
              height: 150,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.movieTitle,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFCC434)),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text("🎬", style: TextStyle(fontSize: 14)),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(widget.genres.join(', '),
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE6E6E6),
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    const Text("🍿", style: TextStyle(fontSize: 14)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.cinemaName,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFFE6E6E6))),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    const Text("🕒", style: TextStyle(fontSize: 14)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(DateFormat("dd.MM.yyyy").format(widget.showDate),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFFE6E6E6))),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text("•",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFFE6E6E6))),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.showTime,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFFE6E6E6))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
