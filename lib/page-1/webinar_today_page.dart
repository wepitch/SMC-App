import 'package:flutter/material.dart';
import 'package:myapp/page-1/webinar_past_page.dart';

class WebinarTodayPage extends StatelessWidget {
  const WebinarTodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                EdgeInsets.only(top: index == 0 ? 30 : 27, right: 16, left: 16),
            child: CustomWebinarCard(
                showDuration: true,
                title: "Learn more about CUET and IPMAT",
                isRegisterNow: index == 0 ? true : false,
                btnTitle: index == 0 ? "Register Now" : "Starting in 3 Days",
                time: "15 Sep @ 2:00 PM Onwards",
                duration: "60",
                participants: "Unlimited",
                bannerImg: "assets/page-1/images/webinarBanner.png"),
          );
        });
  }
}
