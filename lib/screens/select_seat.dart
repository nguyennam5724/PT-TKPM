import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviego/screens/payment.dart';
import 'package:moviego/widgets/dialog_helper.dart';
import 'package:moviego/controllers/seat_controller.dart'; // Import Controller

class SelectSeat extends StatefulWidget {
  final String movieTitle;
  final String cinemaName;
  final String cinemaAddress;
  final String cinemaImage;
  final String moviePoster;
  final List<String> genres;
  final int movieRuntime;

  const SelectSeat({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.moviePoster,
    required this.genres,
    required this.cinemaAddress,
    required this.cinemaImage,
    required this.movieRuntime,
  });

  @override
  _SelectSeatState createState() => _SelectSeatState();
}

class _SelectSeatState extends State<SelectSeat> {
  late SeatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SeatController(movieTitle: widget.movieTitle, cinemaName: widget.cinemaName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title: const Text('Select Seat'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _controller.getBookedSeatsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Stream error: ${snapshot.error}");
            return const Center(child: Text("Error loading seats", style: TextStyle(color: Colors.white)));
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            List<String> bookedSeatsList = List<String>.from(snapshot.data!['bookedSeats'] ?? []);
            _controller.bookedSeats = List.generate(_controller.rows, (i) => List.filled(_controller.cols, false));
            for (String seat in bookedSeatsList) {
              int row = seat.codeUnitAt(0) - 65;
              int col = int.parse(seat.substring(1)) - 1;
              if (row >= 0 && row < _controller.rows && col >= 0 && col < _controller.cols) {
                _controller.bookedSeats[row][col] = true;
              }
            }
          } else {
            _controller.bookedSeats = List.generate(_controller.rows, (i) => List.filled(_controller.cols, false));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Image.asset("assets/images/screen.png"),
                  ),
                  SizedBox(
                    height: 380,
                    child: buildSeats(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildSeatStatusBar(color: const Color(0xFF1C1C1C), content: 'Available'),
                        buildSeatStatusBar(color: const Color(0xFF261D08), content: 'Reserved'),
                        buildSeatStatusBar(color: const Color(0xFFFCC434), content: 'Selected'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Date & Time",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        DateTime date = DateTime.now().add(Duration(days: index));
                        return buildDateWidget(date);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _controller.availableTimes.length,
                      itemBuilder: (context, index) {
                        return buildTimeWidget(index);
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Divider(color: Color(0xFF2E2E2E), height: 0.2, thickness: 1),
                  Row(
                    mainAxisAlignment: _controller.calculatePrice() > 0 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                    children: [
                      if (_controller.calculatePrice() > 0)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Total"),
                            Text(
                              NumberFormat.currency(locale: "vi_VN", symbol: "VND ").format(_controller.calculatePrice()),
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            _controller.updateSelectedSeatsList();
                            if (_controller.calculatePrice() > 0) {
                              await _controller.saveBookedSeats(context);
                              if (mounted) {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Payment(
                                      movieTitle: widget.movieTitle,
                                      cinemaName: widget.cinemaName,
                                      cinemaAddress: widget.cinemaAddress,
                                      cinemaImage: widget.cinemaImage,
                                      selectedSeats: _controller.selectedSeatsList,
                                      showTime: _controller.availableTimes[_controller.selectedTimeIndex],
                                      totalPrice: _controller.calculatePrice(),
                                      showDate: _controller.selectedDate,
                                      moviePoster: widget.moviePoster,
                                      genres: widget.genres,
                                      movieRuntime: widget.movieRuntime,
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return child;
                                    },
                                  ),
                                );
                              }
                            } else {
                              DialogHelper.showCustomDialog(context, "Thông báo", "Vui lòng chọn ghế trước khi tiếp tục!");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFCC434),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text('Buy Ticket', style: TextStyle(fontSize: 18, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  GridView buildSeats() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 12,
        childAspectRatio: 0.9,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _controller.rows * _controller.cols,
      itemBuilder: (context, index) {
        int row = index ~/ _controller.cols;
        int col = index % _controller.cols;
        bool isSelected = _controller.selectedSeats[row][col];
        bool isBooked = _controller.bookedSeats[row][col];

        return GestureDetector(
          onTap: () => _controller.toggleSeat(row, col, setState),
          child: Container(
            decoration: BoxDecoration(
              color: isBooked ? const Color(0xFF261D08) : isSelected ? const Color(0xFFFCC434) : const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: Text(
                _controller.getSeatLabel(row, col),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isBooked ? const Color(0xFFFCC434) : isSelected ? Colors.black : Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  GestureDetector buildDateWidget(DateTime date) {
    return GestureDetector(
      onTap: () => _controller.setSelectedDate(date, setState),
      child: Container(
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: _controller.isSameDay(_controller.selectedDate, date) ? const Color(0xFFFCC434) : const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat("MMM", 'en_US').format(date),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _controller.isSameDay(date, _controller.selectedDate) ? const Color(0xFF1C1C1C) : const Color(0xFFF2F2F2),
              ),
            ),
            const SizedBox(height: 17),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _controller.isSameDay(date, _controller.selectedDate) ? const Color(0xFF1C1C1C) : Colors.grey[600],
                borderRadius: BorderRadius.circular(17.5),
              ),
              child: Center(
                child: Text(
                  DateFormat("dd").format(date),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildTimeWidget(int index) {
    return GestureDetector(
      onTap: () => _controller.setSelectedTimeIndex(index, setState),
      child: Container(
        padding: const EdgeInsets.only(right: 26, left: 26),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: _controller.selectedTimeIndex == index ? const Color(0xFF261D08) : const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(20),
          border: _controller.selectedTimeIndex == index ? Border.all(color: const Color(0xFFFCC434)) : null,
        ),
        child: Center(
          child: Text(
            _controller.availableTimes[index],
            style: TextStyle(
              fontSize: 15,
              fontWeight: _controller.selectedTimeIndex == index ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Row buildSeatStatusBar({required Color color, required String content}) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(content, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}