import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

/// LCS Credential
///
/// @param email user's email address
/// @param token authentication token
/// @param time auth token expire time

@JsonSerializable(nullable: false)
class LcsCredential {
  final String email;
  final String token;

  @JsonKey(name: 'valid_until')
  final DateTime expiration;

  LcsCredential(this.email, this.token, this.expiration);

  /// Verify if auth token is expired or not
  bool isExpired() {
    return this.expiration.isBefore(DateTime.now());
  }

  factory LcsCredential.fromJson(Map<String, dynamic> json) => _$LcsCredentialFromJson(json);
  Map<String, dynamic> toJson() => _$LcsCredentialToJson(this);

}

/// Help Page Resource
///
/// @param name resource name
/// @param description resource description
/// @param url resource url

@JsonSerializable(nullable: false)
class HelpResource {
  final String name;
  final String url;

  @JsonKey(name: 'desc')
  final String description;

  HelpResource(this.name, this.description, this.url);

  factory HelpResource.fromJson(Map<String, dynamic> json) => _$HelpResourceFromJson(json);
  Map<String, dynamic> toJson() => _$HelpResourceToJson(this);

}

/// Announcement Resource
///
/// @param text announcement description
/// @param ts time stamp when an announcement was made

class Announcement {
  final String text;
  final String ts;

  Announcement({this.text, this.ts});

  @override
  String toString() {
    return '{"text": ${json.encode(this.text)}' +
        ',"ts": ${json.encode(this.ts)}}';
  }

  Announcement.fromJson(Map<String, dynamic> json)
      : text = json["text"],
        ts = json['ts'];
}

/// User Profile
///
/// @param name user name
/// @param email user email address
/// @param status user status (accepted, not accepted, coming, etc)
/// @param role user role (director, admin, organizer)
/// @param dayof user data (whether scanned for an event or not)

@JsonSerializable(nullable: false)
class User {
  final String email;
  final Role role;
  final int votes;
  final String github;
  final String major;

  @JsonKey(name: 'short_answer')
  final String shortAnswer;

  @JsonKey(name: 'shirt_size')
  final String shirtSize;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'dietary_restrictions')
  final String dietaryRestrictions;

  @JsonKey(name: 'special_needs')
  final String specialNeeds;

  @JsonKey(name: 'date_of_birth')
  final String dateOfBirth;

  final String school;

  @JsonKey(name: 'grad_year')
  final String gradYear;

  final String gender;

  @JsonKey(name: 'registration_status')
  final String registrationStatus;

  @JsonKey(name: 'level_of_study')
  final String levelOfStudy;

  final Map<String, dynamic> dayOf;

  List<Auth> auth;

  User(this.email, this.role, this.votes, this.github, this.major, this.shortAnswer, this.shirtSize, this.firstName, this.lastName, this.dietaryRestrictions, this.specialNeeds, this.dateOfBirth, this.school, this.gradYear, this.gender, this.registrationStatus, this.levelOfStudy, this.dayOf);

  /// check if a hacker has already attended an event
  bool alreadyDid(String event) {
    if (!this.dayOf.containsKey(event)) {
      return false;
    } else {
      return this.dayOf[event];
    }
  }

  bool isDelayedEntry() {
    return this.registrationStatus == "waitlist";
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}

@JsonSerializable(nullable: false)
class Role {
  final bool hacker;
  final bool volunteer;
  final bool judge;
  final bool sponsor;
  final bool mentor;
  final bool organizer;
  final bool director;

  Role(this.hacker, this.volunteer, this.judge, this.sponsor, this.mentor, this.organizer, this.director);

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);

}

@JsonSerializable(nullable: false)
class Auth {
  final String token;

  @JsonKey(name: 'valid_until')
  final String validUntil;

  Auth(this.token, this.validUntil);

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
  Map<String, dynamic> toJson() => _$AuthToJson(this);

}

/// LCS Error
///
/// @param error handle lcs errors

class LcsError implements Exception {
  String lcsError;
  int code;
  LcsError(http.Response res) {
    this.code = res.statusCode;
    if (res.statusCode >= 500) {
      this.lcsError = "internal error with lcs";
    } else {
      var body = jsonDecode(res.body);
      this.code = body["statusCode"];
      this.lcsError = body["body"];
    }
  }
  String errorMessage() => "LCS error $code: $lcsError";
  String toString() => errorMessage();
}

/// Day-Of Event Resource
///
/// @param summary event name
/// @param location event location which can be used to fetch event map
/// @param start event time

class Event {
  final String summary;
  final String location;
  final DateTime start;

  Event({this.summary, this.location, this.start});

  Event.fromJson(Map<String, dynamic> json)
      : summary = json['summary'],
        location = json['location'],
        start = DateTime.parse(json['start']['dateTime']);

}
