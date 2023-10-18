import 'package:spin_better/models/entities/pre_match_entry.dart';

class TheLastEntry extends PreMatchEntry {
  TheLastEntry.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    String score = json["score"];
    List<String> scoreList = score.substring(0, score.indexOf(" ")).split(":");
    if(scoreList.length > 1) {
      fullScore = (
      int.tryParse(scoreList[0]) ?? 0,
      int.tryParse(scoreList[1]) ?? 0
      );
    }
    else {
      fullScore = (0, 0);
    }
  }

  late (int, int) fullScore;
}