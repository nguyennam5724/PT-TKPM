// controllers/seat_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeatController {
  final int rows = 9;
  final int cols = 12;
  List<List<bool>> selectedSeats = [];
  List<String> selectedSeatsList = [];
  List<List<bool>> bookedSeats = [];
  List<String> availableTimes = ['9:00', '13:00', '15:00', '17:15', '19:45', '22:30'];
  DateTime selectedDate = DateTime.now();
  int selectedTimeIndex = 0;
  final int seatPrice = 70000;

  final String movieTitle;
  final String cinemaName;

  SeatController({required this.movieTitle, required this.cinemaName}) {
    selectedSeats = List.generate(rows, (i) => List.filled(cols, false));
    bookedSeats = List.generate(rows, (i) => List.filled(cols, false));
  }

  // Tính tổng tiền
  int calculatePrice() {
    int totalAmount = 0;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (selectedSeats[i][j]) {
          totalAmount += seatPrice;
        }
      }
    }
    return totalAmount;
  }

  // Cập nhật danh sách ghế đã chọn
  void updateSelectedSeatsList() {
    selectedSeatsList.clear();
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (selectedSeats[i][j]) {
          selectedSeatsList.add(getSeatLabel(i, j));
        }
      }
    }
    print("Selected Seats: $selectedSeatsList");
  }

  // Lấy Stream ghế đã đặt từ Firebase
  Stream<DocumentSnapshot> getBookedSeatsStream() {
    String showtimeID = "${movieTitle}_${DateFormat('yyyy-MM-dd').format(selectedDate)}_${availableTimes[selectedTimeIndex]}";
    return FirebaseFirestore.instance
        .collection('cinemas')
        .doc(cinemaName)
        .collection('showtimes')
        .doc(showtimeID)
        .snapshots();
  }

  // Chọn ghế
  void toggleSeat(int row, int col, Function setState) {
    if (!bookedSeats[row][col]) {
      setState(() => selectedSeats[row][col] = !selectedSeats[row][col]);
    }
  }

  // Lưu ghế lên Firebase
  Future<void> saveBookedSeats(BuildContext context) async {
    try {
      String showtimeID = "${movieTitle}_${DateFormat('yyyy-MM-dd').format(selectedDate)}_${availableTimes[selectedTimeIndex]}";
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('cinemas')
          .doc(cinemaName)
          .collection('showtimes')
          .doc(showtimeID);

      DocumentSnapshot doc = await docRef.get();
      List<String> existingBookedSeats = doc.exists ? List<String>.from(doc['bookedSeats'] ?? []) : [];
      existingBookedSeats.addAll(selectedSeatsList.where((seat) => !existingBookedSeats.contains(seat)));

      await docRef.set({
        'movieTitle': movieTitle,
        'showDate': DateFormat('yyyy-MM-dd').format(selectedDate),
        'showTime': availableTimes[selectedTimeIndex],
        'bookedSeats': existingBookedSeats,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("Booked seats saved to Firestore: $existingBookedSeats");
    } catch (e) {
      print("Error saving booked seats: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save seats: $e")));
    }
  }

  // Chọn ngày
  void setSelectedDate(DateTime date, Function setState) {
    setState(() {
      selectedDate = date;
      print("Ngày được chọn: ${DateFormat('dd/MM').format(selectedDate)}");
    });
  }

  // Chọn giờ
  void setSelectedTimeIndex(int index, Function setState) {
    setState(() {
      selectedTimeIndex = index;
      print(selectedTimeIndex);
    });
  }

  // Nhãn ghế
  String getSeatLabel(int row, int col) => '${String.fromCharCode(65 + row)}${col + 1}';

  // So sánh ngày
  bool isSameDay(DateTime d1, DateTime d2) => d1.month == d2.month && d1.day == d2.day;
}