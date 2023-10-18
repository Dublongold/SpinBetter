class SportTournament {
  SportTournament.fromJson(Map<String, dynamic> json) {
    tournamentId = json["tournamentId"];
    tournamentNameLocalization = json["tournamentNameLocalization"];
    tournamentImage = json["tournamentImage"];
    sportId = json["sportId"];
  }
  late final int tournamentId;
  late final String tournamentNameLocalization;
  late final String tournamentImage;
  late final int sportId;
}
