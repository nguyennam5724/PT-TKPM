import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviego/controllers/payment_controller.dart'; // Import Controller
import 'package:moviego/widgets/bottom_app_bar.dart';
import 'package:moviego/widgets/dialog_helper.dart';

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

  const Payment({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.selectedSeats,
    required this.showTime,
    required this.showDate,
    required this.totalPrice,
    required this.moviePoster,
    required this.genres,
    required this.cinemaAddress,
    required this.cinemaImage,
    required this.movieRuntime,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late PaymentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PaymentController(
      movieTitle: widget.movieTitle,
      cinemaName: widget.cinemaName,
      cinemaAddress: widget.cinemaAddress,
      cinemaImage: widget.cinemaImage,
      totalPrice: widget.totalPrice,
      selectedSeats: widget.selectedSeats,
      showTime: widget.showTime,
      showDate: widget.showDate,
      moviePoster: widget.moviePoster,
      genres: widget.genres,
      movieRuntime: widget.movieRuntime,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    GestureDetector buildPaymentMethod({required String image, required String content}) {
      return GestureDetector(
        onTap: () => _controller.selectPaymentMethod(content, setState),
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: _controller.selectedPaymentMethod == content ? const Color(0xFF261D08) : const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            border: _controller.selectedPaymentMethod == content ? Border.all(color: const Color(0xFFFCC434)) : null,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
                child: Image.asset(image, fit: BoxFit.cover, width: screenWidth * 0.1),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(child: Text(content, style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500, color: Colors.white))),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Payment", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white)),
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.01, right: screenWidth * 0.04, left: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildInforMovie(),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order ID", style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white)),
                  Text(_controller.orderID, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Seat", style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white)),
                  Text(widget.selectedSeats.join(', '), style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(screenWidth * 0.03)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.local_offer_rounded, color: Color(0xFFFCC434)),
                          hintText: 'Discount Code',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        controller: _controller.textController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _controller.applyDiscount(setState, context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        child: Container(
                          color: const Color(0xFFFCC434),
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.015),
                          child: Text(
                            "Apply",
                            style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              const Divider(color: Color(0xFF2E2E2E), height: 0.2, thickness: 1),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white)),
                  Text(
                    NumberFormat.currency(locale: "vi_VN", symbol: "VND ").format(widget.totalPrice - _controller.discount),
                    style: TextStyle(color: const Color(0xFFFCC434), fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Text("Payment Method", style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: screenHeight * 0.015),
              buildPaymentMethod(image: "assets/images/Zalopay.png", content: "Zalo Pay"),
              SizedBox(height: screenHeight * 0.01),
              buildPaymentMethod(image: "assets/images/Momo.png", content: "MoMo"),
              SizedBox(height: screenHeight * 0.01),
              buildPaymentMethod(image: "assets/images/ShopeePay.png", content: "Shopee Pay"),
              SizedBox(height: screenHeight * 0.01),
              buildPaymentMethod(image: "assets/images/ATM.png", content: "ATM Card"),
              SizedBox(height: screenHeight * 0.01),
              buildPaymentMethod(image: "assets/images/Visa.png", content: "International payments"),
              SizedBox(height: screenHeight * 0.03),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFFCC434), borderRadius: BorderRadius.circular(screenWidth * 0.03)),
                child: TextButton(
                  onPressed: () async {
                    if (_controller.selectedPaymentMethod.isEmpty) {
                      DialogHelper.showCustomDialog(context, "Thông báo", "Vui lòng chọn phương thức thanh toán trước khi tiếp tục!");
                    } else {
                      try {
                        await _controller.savePaymentInfoToFirebase(context);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(initialIndex: 1),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      } catch (e) {
                        DialogHelper.showCustomDialog(context, "Lỗi", "Không thể lưu vé, vui lòng thử lại!");
                      }
                    }
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInforMovie() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(screenWidth * 0.03)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
            child: Image.network(
              "https://image.tmdb.org/t/p/original${widget.moviePoster}",
              height: 150,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenWidth * 0.04),
                Text(
                  widget.movieTitle,
                  style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700, color: const Color(0xFFFCC434)),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
                SizedBox(height: screenWidth * 0.015),
                Row(
                  children: [
                    const Text("🎬", style: TextStyle(fontSize: 14)),
                    SizedBox(width: screenWidth * 0.015),
                    Expanded(
                      child: Text(
                        widget.genres.join(', '),
                        style: TextStyle(fontSize: screenWidth * 0.035, color: const Color(0xFFE6E6E6), overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    const Text("🍿", style: TextStyle(fontSize: 14)),
                    SizedBox(width: screenWidth * 0.015),
                    Text(widget.cinemaName, style: TextStyle(fontSize: screenWidth * 0.035, color: const Color(0xFFE6E6E6))),
                  ],
                ),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    const Text("🕒", style: TextStyle(fontSize: 14)),
                    SizedBox(width: screenWidth * 0.015),
                    Text(
                      DateFormat("dd.MM.yyyy").format(widget.showDate),
                      style: TextStyle(fontSize: screenWidth * 0.035, color: const Color(0xFFE6E6E6)),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    const Text("•", style: TextStyle(fontSize: 14, color: Color(0xFFE6E6E6))),
                    SizedBox(width: screenWidth * 0.015),
                    Text(widget.showTime, style: TextStyle(fontSize: screenWidth * 0.035, color: const Color(0xFFE6E6E6))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}