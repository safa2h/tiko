import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:tiko/common/http_service.dart';
import 'package:tiko/data/repo/data_repo.dart';
import 'package:tiko/features/archive/bloc/archive_bloc.dart';
import 'package:tiko/features/home/bloc/home_bloc.dart';
import 'package:tiko/locator.dart';
import 'package:tiko/widgets/error_widget.dart';
import 'package:validators/validators.dart';

class HomeScreenY extends StatefulWidget {
  const HomeScreenY({
    super.key,
  });

  @override
  State<HomeScreenY> createState() => _HomeScreenYState();
}

class _HomeScreenYState extends State<HomeScreenY> {
  String? copyTextFromClipBoard;

  late HomeBloc homeBloc;
  late StreamSubscription streamSubscription;
  bool isDevoceconected = false;
  final GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey();

  @override
  void initState() {
    FlutterClipboard.paste().then((value) {
      if (isURL(value)) {
        setState(() {
          copyTextFromClipBoard = value;
        });
      }
    });

    homeBloc = HomeBloc(locator<IDataRepository>(), locator<IHttpservice>())
      ..add(HomeStarted());
    getConnectvity();

    super.initState();
  }

  @override
  void dispose() {
    homeBloc.close();
    globalKey.currentState?.dispose();

    streamSubscription.cancel();

    super.dispose();
  }

  getConnectvity() async {
    streamSubscription =
        Connectivity().onConnectivityChanged.listen((event) async {
      isDevoceconected = await InternetConnectionChecker().hasConnection;
      if (!isDevoceconected) {
        showDialogBox();
      }
    });
  }

  showDialogBox() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('No Connection'),
            content: const Text('Please check your internet connection..'),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');

                    isDevoceconected =
                        await InternetConnectionChecker().hasConnection;
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: copyTextFromClipBoard);
    return ScaffoldMessenger(
      key: globalKey,
      child: Scaffold(
        body: BlocProvider(
          create: (BuildContext context) {
            return homeBloc;
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                    colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  Theme.of(context).colorScheme.primary.withOpacity(0.4),
                ])),
            child: BlocConsumer(
                listener: (contex, state) {},
                bloc: homeBloc,
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/animation/download_anim.json',
                                width: 200, height: 150),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'Are you sure you want to cancel??'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('NO'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                cancelToken.cancel();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: const Text('Do you want to cancel?'))
                          ],
                        ),
                      ),
                    );
                  } else if (state is HomeSuccess) {
                    BlocProvider.of<ArchiveBloc>(context).add(ArchiveStarted());

                    textEditingController.text = '';
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animation/success_anim.json',
                              width: 200, height: 100),
                          ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<HomeBloc>(context)
                                    .add(HomeStarted());
                              },
                              child: const Text('OK')),
                        ],
                      )),
                    );
                  } else if (state is HomeError) {
                    textEditingController.text = '';
                    return Center(
                      child: ErrorWidgetCustom(
                          errorMessage:
                              'Error while downloading... Please try again',
                          tapCallback: () {
                            BlocProvider.of<HomeBloc>(context)
                                .add(HomeStarted());
                          }),
                    );
                  } else if (state is HomeInitial) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                                label: Text('Please paste the URL here'),
                                border: OutlineInputBorder()),
                            controller: textEditingController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (!isDevoceconected) {
                                  showDialogBox();
                                } else if (!isURL(textEditingController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please Enter valid url')));
                                } else {
                                  homeBloc.add(HomeReqDownload(
                                      textEditingController.text));
                                }
                              },
                              child: Text(
                                'donwload',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w400),
                              ))
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                                label: Text(
                                  'Please paste the URL here',
                                  style: TextStyle(color: Colors.amber),
                                ),
                                border: OutlineInputBorder()),
                            controller: textEditingController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (!isDevoceconected) {
                                  showDialogBox();
                                } else if (!isURL(textEditingController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please Enter valid url')));
                                } else {
                                  homeBloc.add(HomeReqDownload(
                                      textEditingController.text));
                                }
                              },
                              child: const Text('donwload'))
                        ],
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
