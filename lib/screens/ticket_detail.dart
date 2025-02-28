import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/dottedLineWithHalfCircles.dart';

class TicketDetail extends StatelessWidget {
  final Map<String, String> ticketDetails;

  const TicketDetail({super.key, required this.ticketDetails});

  @override
  Widget build(BuildContext context) {
    final movieTitle = ticketDetails['movieTitle'] ?? 'Không có tiêu đề';
    final cinemaName = ticketDetails['cinemaName'] ?? 'Không có tên rạp';
    final selectedSeats = ticketDetails['selectedSeats']?.split(',') ?? [];
    final showTime = ticketDetails['showTime'] ?? 'Không có thời gian chiếu';
    final showDate = ticketDetails['showDate'] ?? 'Không có thời gian chiếu';
    final totalPrice = ticketDetails['totalPrice'] ?? 'Không có giá';
    final moviePoster = ticketDetails['moviePoster'] ?? '';
    final orderID = ticketDetails['orderID'];
    final genres = ticketDetails['genres']?.split(',') ?? [];
    final cinemaImage = ticketDetails['cinemaImage'] ?? 'khong co gi';
    final cinemaAddress = ticketDetails['cinemaAddress'] ?? 'khong co gi';
    final movieRuntime = ticketDetails['movieRuntime'] ?? 'khong co gi';

    return Scaffold(
      appBar: AppBar(
        title: Text(movieTitle, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/Union.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: moviePoster.isNotEmpty
                          ? Image.network(
                        "https://image.tmdb.org/t/p/original$moviePoster",
                        height: 170,
                        width: 120,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 170,
                        width: 120,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            movieTitle,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text("🎬", style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  genres.join(', '),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Text("🕒", style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 5),
                              Text(
                                movieRuntime,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/calendar.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              showTime,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              DateFormat("dd.MM.yyyy")
                                  .format(DateTime.parse(showDate)),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset("assets/images/seat_cinema.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Section 4",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(selectedSeats.join(', '),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 50, right: 50, top: 30),
                child: Divider(
                  color: Colors.black,
                  height: 0.2,
                  thickness: 0.7,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("💸", style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 10),
                        Text(
                          "${NumberFormat('#,###', 'vi_VN').format(int.parse(totalPrice))} VND",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                      ],
                    ),
                    const SizedBox(height:5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("🍿", style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Text(
                                  cinemaName,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 20,),

                                Image.asset(cinemaImage),
                              ],
                            ),
                            Text(cinemaAddress,style: const TextStyle(
                                fontSize: 14, color: Colors.black,fontWeight: FontWeight.w500
                            ),)
                          ],

                        ),
                      ],
                    ),
                    const SizedBox(height:5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📢", style: TextStyle(fontSize: 14)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Show this QR code to the ticket counter to receive your ticket",
                            style: TextStyle(
                                fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0,left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Image.asset("assets/images/e1.png"),
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/images/Line.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Image.asset("assets/images/e2.png"),
                    ),
                  ],
                ),
              ),

              Center(
                child: Image.asset("assets/images/Frame.png"),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  "OrderID: $orderID",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}