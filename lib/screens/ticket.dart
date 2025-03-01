import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviego/controllers/ticket_controller.dart'; // Import Controller
import 'package:moviego/screens/homepage.dart';
import 'package:moviego/screens/ticket_detail.dart';

class TicketPage extends StatelessWidget {
  final TicketController _controller = TicketController(); // Khởi tạo Controller

  TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Ticket",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.black,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _controller.getTicketsFromFirebase(), // Sử dụng Controller
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Bạn chưa có vé nào.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }

          final tickets = snapshot.data!;

          return Container(
            color: Colors.black,
            child: ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];

                final movieTitle = ticket['movieTitle'] ?? 'Không có tiêu đề';
                final cinemaName = ticket['cinemaName'] ?? 'Không có tên rạp';
                final selectedSeats = (ticket['selectedSeats'] as List<dynamic>?)?.join(', ') ?? 'Không có ghế';
                final showTime = ticket['showTime'] ?? 'Không có thời gian chiếu';
                final showDate = ticket['showDate'] ?? 'Không có ngày chiếu';
                final totalPrice = ticket['totalPrice']?.toString() ?? '0';
                final moviePoster = ticket['moviePoster'] ?? '';
                final genres = (ticket['genres'] as List<dynamic>?)?.cast<String>() ?? [];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: GestureDetector(
                        onTap: () {
                          Map<String, String> ticketDetails = ticket.map((key, value) {
                            if (value is List) {
                              return MapEntry(key, value.join(', '));
                            } else {
                              return MapEntry(key, value.toString());
                            }
                          });

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => TicketDetail(ticketDetails: ticketDetails),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                              ),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFFCC434)),
                                    overflow: TextOverflow.fade,
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    children: [
                                      const Text("🎬", style: TextStyle(fontSize: 10)),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          genres.join(', '),
                                          style: const TextStyle(fontSize: 12, color: Color(0xFFE6E6E6), overflow: TextOverflow.ellipsis),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Text("🍿", style: TextStyle(fontSize: 10)),
                                      const SizedBox(width: 5),
                                      Text(
                                        cinemaName,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFFE6E6E6)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Text("💸", style: TextStyle(fontSize: 10)),
                                      const SizedBox(width: 5),
                                      Text(
                                        "${NumberFormat('#,###', 'vi_VN').format(int.parse(totalPrice))} VND",
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}