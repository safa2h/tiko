import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tiko/common/ad_manager.dart';
import 'package:tiko/common/consts.dart';
import 'package:tiko/features/archive/archive_screen.dart';
import 'package:tiko/features/home/home_scree.dart';
import 'package:tiko/widgets/how_to_use.dart';
import 'package:url_launcher/url_launcher.dart';

class RoootScreen extends StatefulWidget {
  const RoootScreen({Key? key}) : super(key: key);

  @override
  State<RoootScreen> createState() => _RoootScreenState();
}

class _RoootScreenState extends State<RoootScreen> {
  late final InAppReview inAppReview;
  int homeIndex = 1;
  int archiveIndex = 0;
  int selectedScreenIndex = 1;
  final List<int> _history = [];
  late final Uri _url;

  late final AdManager adManager;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    adManager = AdManager();
    adManager.addAds(false, false, false, false);
    _url = Uri.parse(
        'https://doc-hosting.flycricket.io/tt-downloader/ced53fae-e6b2-4b93-86f5-eef9706c2feb/privacy');
    inAppReview = InAppReview.instance;

    super.initState();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _appRevieww() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  void dispose() {
    adManager.disposeAds();

    super.dispose();
  }

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _archiveKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    archiveIndex: _archiveKey,
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,

        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 246, 223, 235),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 186, 212),
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Text(
                        'TT Downloader',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      Text('No Watermark'),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text(Constanse.privacyPolicy),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  _launchUrl();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.question_mark),
                title: const Text(Constanse.howToUse),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('How to ues'),
                          content: const HowToUseWidget(),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('OK'))
                          ],
                        );
                      });
                  //  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(Constanse.about),
                    Text(
                      '1.0.2',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        // Theme.of(context).colorScheme.primary.withOpacity(0.05),
        bottomNavigationBar: SalomonBottomBar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
          currentIndex: selectedScreenIndex,
          onTap: (selectedIndex) {
            setState(() {
              _history.remove(selectedScreenIndex);
              _history.add(selectedScreenIndex);
              selectedScreenIndex = selectedIndex;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(
                CupertinoIcons.archivebox,
              ),
              title: const Text('Archive'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                CupertinoIcons.home,
              ),
              title: const Text('Home'),
            ),
          ],
        ),

        body: Column(
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                      colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ])),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24, left: 10),
                    child: IconButton(
                        onPressed: () {
                          _key.currentState!.openDrawer();
                        },
                        icon: const Icon(Icons.menu)),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                        colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.05),
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IndexedStack(
                        index: selectedScreenIndex,
                        children: [
                          _navigator(
                              _homeKey, archiveIndex, const ArchiveScreen()),
                          _navigator(
                              _archiveKey, homeIndex, const HomeScreenY()),
                        ],
                      ),
                    ),
                    if (adManager.getBannerAd() != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: adManager.getBannerAd()!.size.width.toDouble(),
                          height:
                              adManager.getBannerAd()!.size.height.toDouble(),
                          child: AdWidget(ad: adManager.getBannerAd()!),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                    offstage: selectedScreenIndex != index, child: child)));
  }
}
