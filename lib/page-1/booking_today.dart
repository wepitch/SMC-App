import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myapp/model/booking_model.dart';
import 'package:myapp/other/user_booking_provider.dart';
import 'package:myapp/page-1/booking_confirmatoin_page.dart';
import 'package:myapp/utils.dart';
import 'package:provider/provider.dart';

class BookingToday extends StatefulWidget {
  const BookingToday({super.key});

  @override
  State<BookingToday> createState() => _BookingTodayState();
}

class _BookingTodayState extends State<BookingToday> {
  late var apiTime;
  late var todayTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<UserBookingProvider>()
        .fetchUserBookings(past: false, today: true, upcoming: false);
    todayTime = DateTime.now();
  }

  Future<void> _refresh() async {
    return Future.delayed(const Duration(seconds: 1), () {
      context
          .read<UserBookingProvider>()
          .fetchUserBookings(past: false, today: true, upcoming: false);
    });
  }

  DateTime parseTiming(String time) {
    List<String> parts = time.split(":");

    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userBookings = context.watch<UserBookingProvider>();
    bool isLoading = context.watch<UserBookingProvider>().isLoading;

    // String time = "25:15";
    // var mWidth = MediaQuery.sizeOf(context).width;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : userBookings.userBooking.isEmpty
            ? Center(
                child: Text(
                  "No Bookings...",
                  style: SafeGoogleFont("Inter"),
                ),
              )
            : userBookings.userBooking[0].v == -1
                ? Builder(builder: (context) {
                    EasyLoading.showToast(
                      "404 Page Not Found!",
                      toastPosition: EasyLoadingToastPosition.bottom,
                    );
                    return const Center(
                      child: Text("Something went wrong!"),
                    );
                  })
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                        itemCount: userBookings.userBooking.length,
                        itemBuilder: (context, index) {
                          var details = userBookings.userBooking[index];
                          apiTime =
                              parseTiming(details.bookingData!.sessionTime!);
                          Duration remainingTime =
                              apiTime.difference(todayTime);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: Stack(
                                // fit: StackFit.expand,
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Card(
                                    // semanticContainer: false,
                                    margin: const EdgeInsets.only(top: 5),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage:
                                                          NetworkImage(details
                                                                  .bookedEntity
                                                                  ?.profilePic ??
                                                              "https://media.gettyimages.com/id/1334712074/vector/coming-soon-message.jpg?s=612x612&w=0&k=20&c=0GbpL-k_lXkXC4LidDMCFGN_Wo8a107e5JzTwYteXaw="),
                                                    ),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          details.bookedEntity
                                                                  ?.name ??
                                                              "Coming",
                                                          style: SafeGoogleFont(
                                                            "Inter",
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          details.bookedEntity!
                                                              .qualifications![2],
                                                          // textAlign: TextAlign.left,

                                                          style: SafeGoogleFont(
                                                            "Inter",
                                                            color: const Color(
                                                                0xff747474),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Session starts in",
                                                      style: SafeGoogleFont(
                                                          "Inter",
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "${remainingTime.inHours < 0 ? "" : remainingTime.inHours}${remainingTime.inMinutes.remainder(60) < 0 ? '0' : ": ${remainingTime.inMinutes.remainder(60)}"}",
                                                              style: SafeGoogleFont(
                                                                  "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .black)),
                                                          TextSpan(
                                                              text: "min",
                                                              style: SafeGoogleFont(
                                                                  "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${details.bookingData?.sessionType ?? "N/A"} Session",
                                                      style: SafeGoogleFont(
                                                          "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                          color: const Color(
                                                              0xff1F0A68)),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 137,
                                                      height: 24,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => BookingConfirmationPage(
                                                                      remainingTime:
                                                                          remainingTime,
                                                                      isUpcoming:
                                                                          false,
                                                                      bookingData: details
                                                                              .bookingData ??
                                                                          BookingData(),
                                                                      counsellorDetails:
                                                                          details.bookedEntity ??
                                                                              BookedEntity(),
                                                                      isConfirmed:
                                                                          true,
                                                                      time:
                                                                          "25:15")));
                                                        },
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                              "View details",
                                                              style: SafeGoogleFont(
                                                                  "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ))),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 7,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black54,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: 58,
                                      height: 17,
                                      child: Center(
                                        child: Text(
                                          "Counsellor",
                                          style: SafeGoogleFont(
                                            "Inter",
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );

    //      return ListView(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16),
    //       child: Container(
    //         margin: const EdgeInsets.only(bottom: 15),
    //         child: Stack(
    //           // fit: StackFit.expand,
    //           alignment: Alignment.bottomCenter,
    //           children: [
    //             Card(
    //               // semanticContainer: false,
    //               margin: const EdgeInsets.only(top: 5),
    //               elevation: 5,
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(15)),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(12.0),
    //                 child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     children: [
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Row(
    //                             children: [
    //                               Image.asset(
    //                                 "assets/page-1/images/profile_booking.png",
    //                                 width: mWidth * 0.15,
    //                                 height: 60,
    //                               ),
    //                               const SizedBox(
    //                                 width: 7,
    //                               ),
    //                               Column(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   Text(
    //                                     "Sandeep Mehra",
    //                                     style: SafeGoogleFont(
    //                                       "Inter",
    //                                       fontSize: mWidth * 0.045,
    //                                       fontWeight: FontWeight.w600,
    //                                     ),
    //                                   ),
    //                                   Text(
    //                                     "designer at wepitch",
    //                                     // textAlign: TextAlign.left,

    //                                     style: SafeGoogleFont(
    //                                       "Inter",
    //                                       color: const Color(0xff747474),
    //                                       fontSize: mWidth * 0.035,
    //                                       fontWeight: FontWeight.w600,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               )
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                       Row(
    //                         crossAxisAlignment: CrossAxisAlignment.end,
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Text(
    //                                 "Session starts in",
    //                                 style: SafeGoogleFont("Inter",
    //                                     fontSize: 12,
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.bold),
    //                               ),
    //                               RichText(
    //                                   text: TextSpan(children: <TextSpan>[
    //                                 TextSpan(
    //                                     text: time,
    //                                     style: SafeGoogleFont("Inter",
    //                                         fontWeight: FontWeight.w600,
    //                                         fontSize: 20,
    //                                         color: Colors.black)),
    //                                 TextSpan(
    //                                     text: "m",
    //                                     style: SafeGoogleFont("Inter",
    //                                         fontWeight: FontWeight.w600,
    //                                         fontSize: 14,
    //                                         color: Colors.black))
    //                               ]))
    //                             ],
    //                           ),
    //                           const Spacer(),
    //                           Column(
    //                             children: [
    //                               Text(
    //                                 "Personal Session",
    //                                 style: SafeGoogleFont("Inter",
    //                                     fontWeight: FontWeight.w600,
    //                                     fontSize: mWidth * 0.038,
    //                                     color: const Color(0xff1F0A68)),
    //                               ),
    //                               const SizedBox(
    //                                 height: 5,
    //                               ),
    //                               SizedBox(
    //                                 width: mWidth * 0.34,
    //                                 height: 24,
    //                                 child: GestureDetector(
    //                                   onTap: () {
    //                                     // Navigator.push(
    //                                     //     context,
    //                                     //     MaterialPageRoute(
    //                                     //         builder: (context) =>
    //                                     //             const BookingConfirmationPage(
    //                                     //                 isUpcoming: false,
    //                                     //                 isConfirmed: true,
    //                                     //                 time: "25:15")));
    //                                   },
    //                                   child: Container(
    //                                       decoration: BoxDecoration(
    //                                         border: Border.all(),
    //                                         borderRadius:
    //                                             BorderRadius.circular(20),
    //                                  ),
    //                                       child: Center(
    //                                           child: Text(
    //                                         "View details",
    //                                         style: SafeGoogleFont("Inter",
    //                                             fontWeight: FontWeight.w600,
    //                                             fontSize: mWidth * 0.032,
    //                                             color: Colors.black),
    //                                       ))),
    //                                 ),
    //                               ),
    //                             ],
    //                           )
    //                         ],
    //                       )
    //                     ]),
    //               ),
    //             ),
    //             Positioned(
    //               top: 0,
    //               left: 7,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     border: Border.all(
    //                       color: Colors.black54,
    //                     ),
    //                     borderRadius: BorderRadius.circular(10)),
    //                 width: 58,
    //                 height: 17,
    //                 child: Center(
    //                   child: Text(
    //                     "Counsellor",
    //                     style: SafeGoogleFont(
    //                       "Inter",
    //                       fontSize: 8,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16),
    //       child: Container(
    //         margin: const EdgeInsets.only(bottom: 15),
    //         child: Stack(
    //           // fit: StackFit.expand,
    //           alignment: Alignment.bottomCenter,
    //           children: [
    //             Card(
    //               // semanticContainer: false,
    //               margin: const EdgeInsets.only(top: 5),
    //               elevation: 5,
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(15)),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(12.0),
    //                 child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     children: [
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Row(
    //                             children: [
    //                               Image.asset(
    //                                 "assets/page-1/images/profile_booking.png",
    //                                 width: mWidth * 0.15,
    //                                 height: 60,
    //                               ),
    //                               const SizedBox(
    //                                 width: 7,
    //                               ),
    //                               Column(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   Text(
    //                                     "Sandeep Mehra",
    //                                     style: SafeGoogleFont(
    //                                       "Inter",
    //                                       fontSize: mWidth * 0.045,
    //                                       fontWeight: FontWeight.w600,
    //                                     ),
    //                                   ),
    //                                   Text(
    //                                     "designer at wepitch",
    //                                     // textAlign: TextAlign.left,

    //                                     style: SafeGoogleFont(
    //                                       "Inter",
    //                                       color: const Color(0xff747474),
    //                                       fontSize: mWidth * 0.035,
    //                                       fontWeight: FontWeight.w600,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               )
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                       Row(
    //                         crossAxisAlignment: CrossAxisAlignment.end,
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           const Spacer(),
    //                           Column(
    //                             children: [
    //                               Text(
    //                                 "Group Session",
    //                                 style: SafeGoogleFont("Inter",
    //                                     fontWeight: FontWeight.w600,
    //                                     fontSize: mWidth * 0.038,
    //                                     color: const Color(0xff1F0A68)),
    //                               ),
    //                               const SizedBox(
    //                                 height: 5,
    //                               ),
    //                               SizedBox(
    //                                 width: mWidth * 0.34,
    //                                 height: 24,
    //                                 child: GestureDetector(
    //                                   onTap: () {
    //                                     // Navigator.push(
    //                                     //     context,
    //                                     //     MaterialPageRoute(
    //                                     //         builder: (context) =>
    //                                     //             const BookingConfirmationPage(
    //                                     //                 isUpcoming: false,
    //                                     //                 isConfirmed: true,
    //                                     //                 time: "25:15")));
    //                                   },
    //                                   child: Container(
    //                                       decoration: BoxDecoration(
    //                                         border: Border.all(),
    //                                         borderRadius:
    //                                             BorderRadius.circular(20),
    //                                       ),
    //                                       child: Center(
    //                                           child: Text(
    //                                         "View details",
    //                                         style: SafeGoogleFont("Inter",
    //                                             fontWeight: FontWeight.w600,
    //                                             fontSize: mWidth * 0.032,
    //                                             color: Colors.black),
    //                                       ))),
    //                                 ),
    //                               ),
    //                             ],
    //                           )
    //                         ],
    //                       )
    //                     ]),
    //               ),
    //             ),
    //             Positioned(
    //               top: 0,
    //               left: 7,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     border: Border.all(
    //                       color: Colors.black54,
    //                     ),
    //                     borderRadius: BorderRadius.circular(10)),
    //                 width: 58,
    //                 height: 17,
    //                 child: Center(
    //                   child: Text(
    //                     "Counsellor",
    //                     style: SafeGoogleFont(
    //                       "Inter",
    //                       fontSize: 8,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16),
    //       child: Container(
    //         margin: const EdgeInsets.only(bottom: 15),
    //         child: Stack(
    //           // fit: StackFit.expand,
    //           alignment: Alignment.bottomCenter,
    //           children: [
    //             Card(
    //               // semanticContainer: false,
    //               margin: const EdgeInsets.only(top: 5),
    //               elevation: 5,
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(15)),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(12.0),
    //                 child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     children: [
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Row(
    //                             children: [
    //                               Image.asset(
    //                                 "assets/page-1/images/profile_booking.png",
    //                                 width: mWidth * 0.15,
    //                                 height: 60,
    //                               ),
    //                               const SizedBox(
    //                                 width: 7,
    //                               ),
    //                               Column(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   Text(
    //                                     "Sandeep Mehra",
    //                                     style: SafeGoogleFont(
    //                                       "Inter",
    //                                       fontSize: mWidth * 0.045,
    //                                       fontWeight: FontWeight.w600,
    //                                     ),
    //                                   ),
    //                                   Text(
    //                                     "designer at wepitch",
    //                                     // textAlign: TextAlign.left,

    //                                     style: SafeGoogleFont(
    //                                       "Inter",
    //                                       color: const Color(0xff747474),
    //                                       fontSize: mWidth * 0.035,
    //                                       fontWeight: FontWeight.w600,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               )
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                       Row(
    //                         crossAxisAlignment: CrossAxisAlignment.end,
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           const Spacer(),
    //                           Column(
    //                             children: [
    //                               SizedBox(
    //                                 width: mWidth * 0.34,
    //                                 height: 24,
    //                                 child: GestureDetector(
    //                                   onTap: () {
    //                                     // Navigator.push(
    //                                     //     context,
    //                                     //     MaterialPageRoute(
    //                                     //         builder: (context) =>
    //                                     //             const BookingConfirmationPage(
    //                                     //                 isUpcoming: true,
    //                                     //                 isConfirmed: true,
    //                                     //                 time: "10:44")));
    //                                   },
    //                                   child: Container(
    //                                       decoration: BoxDecoration(
    //                                         border: Border.all(),
    //                                         borderRadius:
    //                                             BorderRadius.circular(20),
    //                                       ),
    //                                       child: Center(
    //                                           child: Text(
    //                                         "View details",
    //                                         style: SafeGoogleFont("Inter",
    //                                             fontWeight: FontWeight.w600,
    //                                             fontSize: mWidth * 0.032,
    //                                             color: Colors.black),
    //                                       ))),
    //                                 ),
    //                               ),
    //                             ],
    //                           )
    //                         ],
    //                       )
    //                     ]),
    //               ),
    //             ),
    //             Positioned(
    //               top: 0,
    //               left: 7,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     border: Border.all(
    //                       color: Colors.black54,
    //                     ),
    //                     borderRadius: BorderRadius.circular(10)),
    //                 width: 58,
    //                 height: 17,
    //                 child: Center(
    //                   child: Text(
    //                     "Counsellor",
    //                     style: SafeGoogleFont(
    //                       "Inter",
    //                       fontSize: 8,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}

// model for past bookings
// class PastModel {
//   PastModel(
//       {required this.name,
//       required this.session,
//       required this.role,
//       required this.date,
//       required this.company,
//       required this.img,
//       required this.isAttended});
//   final String name;
//   final String role;
//   final String session;
//   final String img;
//   final String company;
//   final bool isAttended;
//   final String date;
// }

// // dummy data for past bookings
// List<PastModel> listPastBookings = [
//   PastModel(
//       name: "Sandeep Mehra",
//       session: "Personal Session",
//       role: "Counsellor",
//       date: "10:44",
//       company: "designer at wepitch",
//       img: "assets/page-1/images/profile_booking.png",
//       isAttended: true),
//   PastModel(
//       name: "Sandeep Mehra",
//       session: "Group Session",
//       role: "Counsellor",
//       date: "11:31",
//       company: "designer at wepitch",
//       img: "assets/page-1/images/profile_booking.png",
//       isAttended: false),
//   PastModel(
//       name: "Sandeep Mehra",
//       session: "Group Session",
//       role: "EP",
//       date: "11:31",
//       company: "designer at wepitch",
//       img: "assets/page-1/images/profile_booking.png",
//       isAttended: false),
// ];



