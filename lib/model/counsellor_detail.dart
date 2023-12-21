// To parse this JSON data, do
//
//     final counsellorDetail = counsellorDetailFromJson(jsonString);

import 'dart:convert';

CounsellorDetail counsellorDetailFromJson(String str) =>
    CounsellorDetail.fromJson(json.decode(str));

String counsellorDetailToJson(CounsellorDetail data) =>
    json.encode(data.toJson());

class CounsellorDetail {
  String id;
  String name;
  String email;
  String coverImage;
  int averageRating;
  int followersCount;
  int experienceInYears;
  int totalSessionsAttended;
  String gender;
  List qualifications;
  List howIWillHelpYou;
  List? languages;
  int? age;
  Location? location;
  int? personalSessionPrice;
  int? groupSessionPrice;

  CounsellorDetail({
    required this.howIWillHelpYou,
    required this.qualifications,
    required this.id,
    required this.name,
    required this.email,
    required this.coverImage,
    required this.averageRating,
    required this.followersCount,
    required this.experienceInYears,
    required this.totalSessionsAttended,
    required this.gender,
    this.languages,
    this.age,
    this.location,
    this.personalSessionPrice,
    this.groupSessionPrice,
  });

  factory CounsellorDetail.fromJson(Map<String, dynamic> json) =>
      CounsellorDetail(
          id: json["_id"],
          name: json["name"],
          email: json["email"],
          coverImage: json["cover_image"],
          averageRating: json["average_rating"],
          followersCount: json["followers_count"],
          experienceInYears: json["experience_in_years"],
          totalSessionsAttended: json["total_sessions_attended"],
          gender: json["gender"],
          qualifications: json["qualifications"],
          howIWillHelpYou: json["how_will_i_help"],
          languages: json["languages_spoken"],
          age: json["age"],
          personalSessionPrice: json["personal_session_price"],
          groupSessionPrice: json["group_session_price"],
          location: Location.fromjson(
            json["location"],
          ));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "cover_image": coverImage,
        "average_rating": averageRating,
        "followers_count": followersCount,
        "experience_in_years": experienceInYears,
        "total_sessions_attended": totalSessionsAttended,
        "gender": gender,
      };
}

class Location {
  String? pincode;
  String? city;
  String? state;
  String? country;
  Location({this.pincode, this.city, this.country, this.state});

  factory Location.fromjson(Map<String, dynamic> json) {
    return Location(
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pin_code"]);
  }

  List<Location> getLocationList(Location location) {
    List<Location> temp = [];
    temp.add(location);

    return temp;
  }
}
