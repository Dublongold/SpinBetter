import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:spin_better/extentions/date_time.dart';
import 'package:http/http.dart';
import 'package:spin_better/models/entities/news_entry.dart';


import '../../main.dart';
import '../../models/entities/live_entry.dart';
import '../../models/entities/pre_match_entry.dart';
import '../../models/entities/sport_entry.dart';
import '../../models/entities/the_last_entry.dart';
import '../../res/strings.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

import '../../res/uris.dart';


class SportEntitiesReceiver {
  SportEntitiesReceiver({required this.selectedPage, required this.sportId});

  Uri _getSportUri() {
    StringBuffer resultBuilder = StringBuffer();
    resultBuilder.write("https://cpservm.com/gateway/marketing/");
    if(selectedPage < 2) {
      resultBuilder.write("datafeed/");
      resultBuilder.write(selectedPage == 0 ? "live" : "prematch");
      resultBuilder.write("/api/v2/sportevents?sportids=$sportId");
    }
    else {
      resultBuilder.write("result/api/v1/tournaments?");
      resultBuilder.write("dateFrom=$dateFrom&dateTo=$dateTo&sportId=$sportId");
    }
    resultBuilder.write("&ref=$ref&lng=ru");
    return Uri.parse(resultBuilder.toString());
  }

  Future<List<SportEntry>> fetchData() async {
    if(selectedPage < 3) {
      String jwt = await MyApp.jwtToken.getToken();
      Uri uri = _getSportUri();
      Response response = await get(uri, headers: {
        "Authorization": "Bearer $jwt"
      }
      );

      if (response.statusCode == 200) {
        if (selectedPage < 2) {
          return _getSportEntries(response);
        }
        else {
          return await _getTheLastEntities(response, jwt);
        }
      }
      else {
        Logger().e("Something wrong... (${response.statusCode}).");
        return [];
      }
    }
    else if (selectedPage == 3) {
      return await _getNews();
    }
    else {
      Logger().e("Wrong selectedPage ($selectedPage)");
    }
    return [];
  }

  Future<List<NewsEntry>> _getNews() async {
    Response response = await get(newsUri);
    if(response.statusCode == 200) {
      var soup = BeautifulSoup(response.body);
      var blogLinks = soup.findAll("*",
          selector: "div.b-news-con__item > a[href]").map((e) {
        String? image = e
            .find("*", selector: "div.b-news__back")
            ?.attributes["style"];
        image = image?.substring(image.indexOf("url(") + 4,
            image.indexOf(")"));
        String title = "https://spinbetter1.online/${e.attributes["href"]}";
        return (title, image ?? "");
      }).toList();
      List<(String, String, String)> parsedLinks = [];
      List<Future<(String, String, String)>> futures = [];
      for (var (link, image) in blogLinks) {
        futures.add(loadBlog(link, image));
      }

      parsedLinks = await Future.wait(futures);

      var result = parsedLinks.map((blog) =>
          NewsEntry(
              newsImageUrl: blog.$2, newsText: blog.$1, newsLink: blog.$3
          )).toList();
      return result;
    }
    return [];
  }

  Future<(String, String, String)> loadBlog(String link, String image) async {
    try {
      if (link != "") {
        Response response = await get(Uri.parse(link));
        if (response.statusCode == 200) {
          BeautifulSoup soup = BeautifulSoup(response.body);
          var blogContent = soup.find("*", class_: "blog_content");
          if (blogContent != null) {
            return (blogContent.text.trim(), image, link);
          }
          else {
            Logger().w("blogContent is null...");
          }
        }
        else {
          Logger().e("Request for load blog is bad (${response.statusCode}).");
        }
      }
      Logger().w("Returned empty string for link $link}");
    }
    on Exception {
      Logger().e("Exception with link $link");
      rethrow;
    }
    return ("", image, link);
  }

  List<SportEntry> _getSportEntries(Response response) {
    dynamic oneHundredItems =
    jsonDecode(response.body)["items"]?.take(100);

    List<SportEntry> json = [
      if(oneHundredItems?.isNotEmpty == true)
        for(Map<String, dynamic> map in oneHundredItems)
          switch(selectedPage) {
            0 => LiveEntry.fromJson(map),
            1 => PreMatchEntry.fromJson(map),
            _ => throw ArgumentError()
          }
    ];
    return json;
  }

  Future<List<TheLastEntry>> _getTheLastEntities(Response response, String jwt) async {
    List<dynamic> tournaments = jsonDecode(response.body)["items"]
        ?.take(100).toList();
    List<dynamic> tournamentsIds = tournaments.map((tournament) => tournament["tournamentId"] as int).toList();

    List<TheLastEntry> theLastEntities = [];
    int index = 0;
    responseBuilder(int i) {
      return get(
          Uri.parse("https://cpservm.com/gateway/marketing/result/api/v1/"
              "sportevents?tournamentIds=${tournamentsIds[i]}&"
              "dateFrom=$dateFrom&dateTo=$dateTo&ref=$ref"), headers: {
        "Authorization": "Bearer $jwt"
      });
    }
    while(theLastEntities.length < 200 && index < tournamentsIds.length) {
      var responses = [
        responseBuilder(index),
        if(index + 1 < tournamentsIds.length) responseBuilder(index + 1),
        if(index + 2 < tournamentsIds.length) responseBuilder(index + 2),
        if(index + 3 < tournamentsIds.length) responseBuilder(index + 3),
      ];
      var completedResponses = await Future.wait(responses);
      if(completedResponses.any((element) => element.statusCode == 200)) {
        for(var tempResponse in completedResponses) {
          for (Map<String, dynamic> map in jsonDecode(
              tempResponse.body)["items"]) {
            map["tournamentNameLocalization"] =
            tournaments[index]["tournamentNameLocalization"];
            theLastEntities.add(TheLastEntry.fromJson(map));
            if (theLastEntities.length == 100) {
              break;
            }
          }
        }
      }
      index += 4;
    }
    return theLastEntities;
  }

  int get dateFrom => DateTime.now().secondsSinceEpoch - day;
  int get dateTo => DateTime.now().secondsSinceEpoch;

  final int selectedPage;
  final int sportId;

  static const int day = 86400;
}