import 'sport_entry.dart';

class PreMatchEntry implements SportEntry {
  PreMatchEntry.fromJson(Map<String, dynamic> json) {
    tournamentNameLocalization = json["tournamentNameLocalization"] ??
      "Unknown";
    imageOpponent1 = json["imageOpponent1"];
    opponent1NameLocalization = json["opponent1NameLocalization"];
    imageOpponent2 = json["imageOpponent2"];
    opponent2NameLocalization = json["opponent2NameLocalization"];
    startDate = json["startDate"];
  }

  late String tournamentNameLocalization;
  late List<dynamic>? imageOpponent1;
  late String opponent1NameLocalization;
  late List<dynamic>? imageOpponent2;
  late String opponent2NameLocalization;
  late int startDate;
}