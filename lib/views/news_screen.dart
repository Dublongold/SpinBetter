import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:spin_better/res/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({
    super.key,
    required this.text,
    required this.image,
    required this.link
});

  @override
  State<NewsScreen> createState() => _NewsScreenState();

  final String text;
  final String image;
  final String link;
}

class _NewsScreenState extends State<NewsScreen> {
  Document? document;
  Map <String, Style>? style;
  
  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    Response response = await get(Uri.parse(widget.link));
    Response response2 = await get(Uri.parse("https://v2l.traincdn.com/styles/css/blog/main.be3f71e50d6618cb28633fe09decc872.css"));
    if(response.statusCode == 200 && response2.statusCode == 200) {
      setState(() {
        document = parse(response.body.replaceAll("\"/genfiles/cms/ckeditor/", "\"https://spinbetter1.online/genfiles/cms/ckeditor/"));
        style = Style.fromCss(response2.body.replaceAll(":nth-child(2n)", ":nth-child(2)"), (css, errors) => "Css: $css\nErrors: $errors");
        style!.removeWhere((key, value) => key.contains(":hover") || key.contains(":focus") || key.contains(":-ms-fullscreen"));
      });
    }
    else {
      Logger().e("News response wasn't loaded. Status code:"
          "${response.statusCode}.");
    }
  }


  @override
  Widget build(BuildContext context) {
    if(document != null) {
      document?.querySelector("div.b-news__header")?.remove();
      document?.querySelector("div.other-news")?.remove();
      style?[".b-news_inner p"]?.fontFamily = "Roboto";
      style?[".b-news_inner p"]?.fontSize = FontSize(16);
      style?[".b-news_inner p"]?.fontWeight = FontWeight.w400;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: newsBackground,
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: document == null && style == null ? const CircularProgressIndicator(
                  color: Colors.white,
                ) : Html
                    .fromElement(
                  documentElement: document!.querySelector("div.b-news.b-news_inner"),
                  style: style!,
                  onLinkTap: (link, map, element) async {
                    if(link != null) {
                      await launchUrl(Uri.parse(link));
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  tooltip: "Close",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Image.asset("images/buttons/close_button.png")
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}