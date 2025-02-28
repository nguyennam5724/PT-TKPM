import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketDetail extends StatelessWidget {
  final Map<String, dynamic> ticketDetails;

  const TicketDetail({super.key, required this.ticketDetails});

  @override
  Widget build(BuildContext context) {
    final movieTitle = ticketDetails['movieTitle'] ?? 'Không có tiêu đề';
    final cinemaName = ticketDetails['cinemaName'] ?? 'Không có tên rạp';
    final selectedSeats = (ticketDetails['selectedSeats'] as String?)?.split(',') ?? [];
    final showTime = ticketDetails['showTime'] ?? 'Không có thời gian chiếu';
    final showDate = ticketDetails['showDate'] ?? 'Không có thời gian chiếu';
    final totalPrice = ticketDetails['totalPrice'] ?? 'Không có giá';
    final moviePoster = ticketDetails['moviePoster'] ?? '';
    final orderID = ticketDetails['orderID'] ?? 'N/A';
    final genres = (ticketDetails['genres'] as String?)?.split(',') ?? [];
    final cinemaImage = ticketDetails['cinemaImage'] ?? 'khong co gi';
    final cinemaAddress = ticketDetails['cinemaAddress'] ?? 'khong co gi';
    final movieRuntime = ticketDetails['movieRuntime'] ?? '0';

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movieTitle,
          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              image: const DecorationImage(
                image: AssetImage("assets/images/Union.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                inforMovie(
                  moviePoster: moviePoster,
                  movieTitle: movieTitle,
                  genres: genres,
                  movieRuntime: movieRuntime,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      calender(showTime: showTime, showDate: showDate),
                      SizedBox(width: screenWidth * 0.02),
                      seat(selectedSeats: selectedSeats),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: const Divider(color: Colors.black54, height: 1, thickness: 1),
                ),
                inforTicket(
                  totalPrice: totalPrice,
                  cinemaName: cinemaName,
                  cinemaImage: cinemaImage,
                  cinemaAddress: cinemaAddress,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: screenWidth * 0.08, child: Image.asset("assets/images/e1.png")),
                      Expanded(child: Image.asset("assets/images/Line.png", fit: BoxFit.fitWidth)),
                      SizedBox(width: screenWidth * 0.08, child: Image.asset("assets/images/e2.png")),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.2,
                    child: Image.asset("assets/images/Frame.png"),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: Text(
                    "OrderID: $orderID",
                    style: TextStyle(fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatRuntime(String runtime) {
  int minutes = int.tryParse(runtime) ?? 0;
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;
  return "$hours h $remainingMinutes m";
}

class inforTicket extends StatelessWidget {
  const inforTicket({
    super.key,
    required this.totalPrice,
    required this.cinemaName,
    required this.cinemaImage,
    required this.cinemaAddress,
  });

  final String totalPrice;
  final String cinemaName;
  final String cinemaImage;
  final String cinemaAddress;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("💸", style: TextStyle(fontSize: 11)),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Text(
                  "${NumberFormat('#,###', 'vi_VN').format(int.tryParse(totalPrice) ?? 0)} VND",
                  style: TextStyle(fontSize: screenWidth * 0.035, fontWeight: FontWeight.bold, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("🍿", style: TextStyle(fontSize: 11)),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cinemaName,
                            style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black87, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        SizedBox(
                          width: screenWidth * 0.05,
                          height: screenWidth * 0.05,
                          child: Image.asset(cinemaImage, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 18)),
                        ),
                      ],
                    ),
                    Text(
                      cinemaAddress,
                      style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black87, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("📢", style: TextStyle(fontSize: 11)),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Text(
                  "Show this QR code to the ticket counter to receive your ticket",
                  style: TextStyle(fontSize: screenWidth * 0.032, color: Colors.black87, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class inforMovie extends StatelessWidget {
  const inforMovie({
    super.key,
    required this.moviePoster,
    required this.movieTitle,
    required this.genres,
    required this.movieRuntime,
  });

  final String moviePoster;
  final String movieTitle;
  final List<String> genres;
  final String movieRuntime;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
            child: moviePoster.isNotEmpty
                ? Image.network(
                    "https://image.tmdb.org/t/p/original$moviePoster",
                    height: screenHeight * 0.2,
                    width: screenWidth * 0.3,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: screenHeight * 0.15,
                      width: screenWidth * 0.2,
                      color: Colors.grey,
                    ),
                  )
                : Container(height: screenHeight * 0.15, width: screenWidth * 0.2, color: Colors.grey),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieTitle,
                  style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w700, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    const Text("🎬", style: TextStyle(fontSize: 11)),
                    SizedBox(width: screenWidth * 0.01),
                    Expanded(
                      child: Text(
                        genres.join(', '),
                        style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                Row(
                  children: [
                    const Text("🕒", style: TextStyle(fontSize: 11)),
                    SizedBox(width: screenWidth * 0.01),
                    Expanded(
                      child: Text(
                        formatRuntime(movieRuntime),
                        style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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

class seat extends StatelessWidget {
  const seat({super.key, required this.selectedSeats});

  final List<String> selectedSeats;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        SizedBox(width: screenWidth * 0.05, height: screenWidth * 0.05, child: Image.asset("assets/images/seat_cinema.png")),
        SizedBox(width: screenWidth * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Section 4",
              style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenWidth * 0.005),
            SizedBox(
              width: screenWidth * 0.35,
              child: Text(
                selectedSeats.join(', '),
                style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black87, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class calender extends StatelessWidget {
  const calender({super.key, required this.showTime, required this.showDate});

  final String showTime;
  final String showDate;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        SizedBox(width: screenWidth * 0.05, height: screenWidth * 0.05, child: Image.asset("assets/images/calendar.png")),
        SizedBox(width: screenWidth * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              showTime,
              style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black87, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenWidth * 0.005),
            Text(
              DateFormat("dd.MM.yyyy").format(DateTime.parse(showDate)),
              style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black87, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}