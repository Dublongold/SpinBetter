import 'package:flutter/material.dart';
import 'package:spin_better/models/entities/news_entry.dart';
import 'package:spin_better/views/news_screen.dart';
import 'package:sprintf/sprintf.dart';

import '../../models/entities/live_entry.dart';
import '../../models/entities/pre_match_entry.dart';
import '../../models/entities/sport_entry.dart';
import '../../models/entities/the_last_entry.dart';
import '../../res/colors.dart';

class SportEntryItem extends StatelessWidget {
  const SportEntryItem({
    super.key,
    required this.entry
  });

  @override
  Widget build(BuildContext context) {
    SportEntry entry = this.entry;
    if (entry is PreMatchEntry) {
      return Container(
        width: 330,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32))
        ),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: defaultText(entry.tournamentNameLocalization,
                  fontWeight: FontWeight.bold)
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        if(entry.imageOpponent1?.isNotEmpty == true)
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: opponentImage(entry.imageOpponent1![0])
                          ),
                        defaultText(entry.opponent1NameLocalization,
                          fontWeight: FontWeight.bold
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        if(entry.imageOpponent2?.isNotEmpty == true)
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: opponentImage(entry.imageOpponent2![0])
                          ),
                        defaultText(entry.opponent2NameLocalization,
                          fontWeight: FontWeight.bold),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if(entry is LiveEntry)
              Text(entry.getMatchState(),
                style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 16,
                ),
              ),
            if(entry is TheLastEntry)
              defaultText("${entry.fullScore.$1} : ${entry.fullScore.$2}"),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: defaultText(getDateAndTime(entry.startDate)),
            )
          ],
        ),
      );
    }
    else if (entry is NewsEntry) {
      return  Container(
        width: 330,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewsScreen(
                  text: entry.newsText,
                  image: entry.newsImageUrl,
                  link: entry.newsLink,)
                )
            );
          },
          child: Column(
            children: [
              Image.network(entry.newsImageUrl,
                errorBuilder: (context, exception, stackTrace) {
                  return const Placeholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress == null) {
                    return child;
                  }
                  else {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Text(
                  entry.newsText.substring(0, entry.newsText.indexOf("\n")),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return const Placeholder();
    }
  }

  Text defaultText(String text, {FontWeight? fontWeight}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: sportEntryText,
        fontSize: 16,
        fontWeight: fontWeight
      ),
    );
  }

  String getDateAndTime(int epochTime) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTime * 1000);
    return sprintf("%02d-%02d-%d, %02d:%02d:%02d",
      [dateTime.day, dateTime.month, dateTime.year,
        dateTime.hour, dateTime.minute, dateTime.second]);
  }

  Widget opponentImage(String url) {
    return Image.network("https://nimblecd.com/"
        "sfiles/logo_teams/$url",
      errorBuilder: (context, exception, stackTrace) {
        return const Placeholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if(loadingProgress == null) {
          return child;
        }
        else {
          return const Center(
            child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  final SportEntry entry;
}