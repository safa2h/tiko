import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiko/common/thumbnail.dart';
import 'package:tiko/features/archive/bloc/archive_bloc.dart';
import 'dart:io';

import 'package:tiko/features/video_player/video_player.dart';
import 'package:tiko/widgets/error_widget.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({
    super.key,
  });

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  late ArchiveBloc archiveBloc;
  late StreamSubscription streamSubscription;
  final GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey();

  @override
  void initState() {
    archiveBloc = BlocProvider.of<ArchiveBloc>(context)..add(ArchiveStarted());

    super.initState();
  }

  @override
  void dispose() {
    globalKey.currentState?.dispose();
    streamSubscription.cancel();
    archiveBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: globalKey,
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
              Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ])),
        child:
            BlocConsumer<ArchiveBloc, ArchiveState>(listener: (context, state) {
          if (state is ArchiveRemovedSuccess) {
            globalKey.currentState?.showSnackBar(
                const SnackBar(content: Text('Removed successfully')));
            BlocProvider.of<ArchiveBloc>(context).add(ArchiveStarted());
          }

          if (state is ArchiveAddedToGallerySuccess) {
            globalKey.currentState?.showSnackBar(
                const SnackBar(content: Text('Added To Gallery successfully')));
            BlocProvider.of<ArchiveBloc>(context).add(ArchiveStarted());
          }
        }, builder: (context, state) {
          return BlocBuilder<ArchiveBloc, ArchiveState>(
              bloc: archiveBloc,
              builder: (context, state) {
                if (state is ArchiveEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/img/video.jpg',
                            width: 200,
                            height: 200,
                          ),
                          const Text(
                            'You do not have any videos yet!',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  );
                } else if (state is ArchiveError) {
                  return Center(
                    child: ErrorWidgetCustom(
                        errorMessage: 'Error.. plesae try again',
                        tapCallback: () {
                          BlocProvider.of<ArchiveBloc>(context)
                              .add(ArchiveStarted());
                        }),
                  );
                } else if (state is ArchiveLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ArchiveSuccess) {
                  final files = state.files.toList();
                  return Center(
                    child: FutureBuilder(
                        future: Future.wait(files.map((videoPath) =>
                            ThumbnailGenerator.generateThumbnail(
                                videoPath.path))),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error loading videos'));
                          } else {
                            List<String> thumbnailPaths =
                                snapshot.data as List<String>;

                            return ListView.builder(
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        margin: const EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(thumbnailPaths[index]),
                                            height: 150,
                                            width: 64,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        )),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.play_circle_outline,
                                            color: Colors.white,
                                            size: 64,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoPlayerScreen(
                                                          file: File(
                                                              files[index]
                                                                  .path),
                                                        )));
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 30,
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (contex) {
                                                return AlertDialog(
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              contex, false);
                                                        },
                                                        child:
                                                            const Text('no')),
                                                    TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      ArchiveBloc>(
                                                                  context)
                                                              .add(ArchiveSaveTogallery(
                                                                  files[index]
                                                                      .path));
                                                          Navigator.pop(
                                                              contex, false);
                                                        },
                                                        child:
                                                            const Text('yes')),
                                                  ],
                                                  title: const Text(
                                                      'Do you want to save to gallery?'),
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.download,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 16,
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (contex) {
                                                return AlertDialog(
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              contex, false);
                                                        },
                                                        child:
                                                            const Text('no')),
                                                    TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      ArchiveBloc>(
                                                                  context)
                                                              .add(ArchiveDeleteItem(
                                                                  files[index]
                                                                      .path));

                                                          Navigator.pop(
                                                              contex, false);
                                                        },
                                                        child:
                                                            const Text('yes')),
                                                  ],
                                                  title: const Text(
                                                      'Do you want to remove it?'),
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.trash_fill,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }),
                  );
                } else {
                  return Container();
                }
              });
        }),
      )),
    );
  }
}
