import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_better/cancellation_token/cancellation_token.dart';
import 'package:spin_better/models/entities/sport_entry.dart';
import 'package:spin_better/res/colors.dart';
import 'package:spin_better/res/strings.dart';
import 'package:spin_better/res/uris.dart';
import 'package:spin_better/selected_page.dart';
import 'package:spin_better/views/bottom_navigation_bar.dart';
import 'package:spin_better/views/choose_sport_buttons.dart';
import 'package:spin_better/views/logic/sport_entities_receiver.dart';
import 'package:spin_better/views/sport_entry_item.dart';
import 'package:spin_better/views/top_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'annoying_banner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });
  @override
  State<MainScreen> createState() => _MainScreenState();

  void onInitState(int selectedPage, void Function(List<SportEntry>) callback) {
    fetchData(1, selectedPage).then(
            (value) => callback(value)
    );
  }

  Future<List<SportEntry>> fetchData(int sportId, int selectedPage) async {
    SportEntitiesReceiver receiver = SportEntitiesReceiver(
      sportId: sportId,
      selectedPage: selectedPage
    );
    return await receiver.fetchData();
  }
}

class _MainScreenState extends State<MainScreen> {
  List<SportEntry> elements = [];
  bool elementsLoaded = false;
  bool needButtons = true;
  bool showBanner = false;
  CancellationToken? bannerCancellationToken;
  CancellationToken? sportEntryCancellationToken;
  String titleText = liveTitleText;
  int selectedSport = 1;
  GlobalKey bannerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.onInitState(0, (elements) {
      setState(() {
        this.elements = elements;
        elementsLoaded = true;
        CancellationToken cancellationToken = CancellationToken();
        bannerCancellationToken = cancellationToken;
        waitSecondsAndShowBanner(defaultWaiting, cancellationToken);
      });
    });
  }
  @override build(BuildContext context) {
    SelectedPage state = context.watch();
    state.onChangedPage ??= (selectedPage) {
      CancellationToken token = CancellationToken();
      setState(() {
        showBanner = false;
        bannerCancellationToken?.cancel();
        sportEntryCancellationToken?.cancel();
        sportEntryCancellationToken = token;
        titleText = switch(selectedPage) {
          0 => liveTitleText,
          1 => preMatchTitleText,
          2 => theLastTitleText,
          3 => newsTitleText,
          _ => throw ArgumentError()
        };
        needButtons = selectedPage != 3;
        elements = [];
        elementsLoaded = false;
      });
      widget.fetchData(selectedSport, selectedPage).then(
        (value) {
          if (!token.isCancelled()) {
            setState(() {
              elements = value;
              elementsLoaded = true;
              CancellationToken cancellationToken = CancellationToken();
              bannerCancellationToken = cancellationToken;
              waitSecondsAndShowBanner(defaultWaiting, cancellationToken);
            });
          }
        }
      );
    };
    int ec = MediaQuery.of(context).size.width ~/ 350;
    if(ec == 0) {
      ec = 1;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackground,
        body: Stack(
          children: [
            Column(
              children: [
                TopBar(titleText: titleText),
                GestureDetector(
                  onTap: () async {
                    await launchUrl(bannersUri);
                  },
                  child: Image.asset("images/banners/banner_top.png"),
                ),
                if(needButtons) ChooseSportButtons(
                  onPressCallback: (sportId) async {
                    setState(() {
                      selectedSport = sportId;
                      elements = [];
                      elementsLoaded = false;
                    });
                    List<SportEntry> entities = await widget.fetchData(sportId,
                        state.selectedPage);
                    setState(() {
                      elementsLoaded = true;
                      elements = entities;
                    });
                },
                  enabled: elementsLoaded,
                ),
                if(!elementsLoaded)
                  const Expanded(
                      child: Center(
                        child: CircularProgressIndicator()
                      )
                  ),

                if(elementsLoaded && elements.isNotEmpty)
                  Expanded(
                      child: Center(
                        child: ListView.builder(
                          itemCount: elements.length / ec % 1 == 0 ? elements.length ~/ ec : elements.length ~/ ec + 1,
                          itemBuilder: (context, index) {
                            if(ec == 1) {
                              return SportEntryItem(entry: elements[index]);
                            }
                            else {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    for(int j in List.generate(ec, (index) => index))
                                      if((index * ec) + j < elements.length)
                                        SportEntryItem(entry: elements[(index * ec) + j]),
                                  ]
                              );
                            }
                          },
                          padding: const EdgeInsets.all(10),
                        ),
                      )
                  ),

                if(elementsLoaded && elements.isEmpty)
                  const Expanded(child: SizedBox(child: null,)),

                GestureDetector(
                  onTap: () async {
                    await launchUrl(bannersUri);
                  },
                  child: Image.asset("images/banners/banner_bottom.png"),
                )
              ],
            ),
            if(showBanner)
              AnnoyingBanner(bannerKey: bannerKey, hideBanner: () {
                setState(() {
                  showBanner = false;
                });
              },)
          ],
        ),
        bottomNavigationBar: const BottomNavigationIcons(),
      ),
    );
  }

  final defaultWaiting = 2;

  Size getWidgetSize(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if(box != null) {
      return box.size;
    }
    return Size.zero;
  }

  Future<void> waitSecondsAndShowBanner(int seconds, CancellationToken token) async {
    await Future.delayed(Duration(seconds: seconds));
    if(!token.isCancelled()) {
      setState(() {
        showBanner = true;
      });
    }
  }
}