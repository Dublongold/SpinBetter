import 'package:spin_better/models/entities/pre_match_entry.dart';

class LiveEntry extends PreMatchEntry {
  LiveEntry.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    gameStatus = json["gameStatus"] ?? 0;
    fullScore = (
        json["fullScore"]?["sc1"] ?? 0,
        json["fullScore"]?["sc2"] ?? 0,
    );
  }

  String getMatchState() => switch(gameStatus) {
    // 0 => "Match in progress",
    // 1 => "Match finished",
    // 2 => "Halftime",
    // 4 => "Match canceled",
    // 8 => "Opponent 1 takes a penalty",
    // 16 => "Opponent 2 takes a penalty",
    // _ => "Error..."
    0 => "Матч в процессе",
    1 => "Матч завершен",
    2 => "Перерыв",
    4 => "Матч отменён",
    8 => "Соперник 1 совершает пенальти",
    16 => "Соперник 2 совершает пенальти",
    _ => "Error..."
  };

  late int gameStatus;
  late (int, int) fullScore;
}