import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiko/common/utils.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.file});
  final File file;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool showControlPanel = false;
  Timer? timer;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.file);
    _controller.initialize();

    _controller.play();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  void initControlPanelTimer() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        showControlPanel = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Positioned.fill(
          child: GestureDetector(
              onTap: () {
                if (!showControlPanel) {
                  setState(() {
                    showControlPanel = true;
                  });
                  initControlPanelTimer();
                }
              },
              child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Center(child: VideoPlayer(_controller)))),
        ),
        if (showControlPanel)
          VideoControlPanel(
            file: widget.file,
            controller: _controller,
            gestureTapCallback: () {
              setState(() {
                showControlPanel = false;
              });
              timer?.cancel();
            },
          )
      ]),
    );
  }
}

class VideoControlPanel extends StatefulWidget {
  const VideoControlPanel({
    Key? key,
    required VideoPlayerController controller,
    required this.gestureTapCallback,
    required this.file,
  })  : _controller = controller,
        super(key: key);

  final VideoPlayerController _controller;
  final GestureTapCallback gestureTapCallback;
  final File file;

  @override
  State<VideoControlPanel> createState() => _VideoControlPanelState();
}

class _VideoControlPanelState extends State<VideoControlPanel> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.gestureTapCallback,
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 48, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.file.toString().substring(63),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    VideoProgressIndicator(
                      widget._controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                          playedColor: Colors.white,
                          backgroundColor: Colors.white10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget._controller.value.position
                                .toMinutesSeconds(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            widget._controller.value.duration
                                .toMinutesSeconds(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              widget._controller.seekTo(Duration(
                                  milliseconds: widget._controller.value
                                          .position.inMilliseconds -
                                      2000));
                              setState(() {});
                            },
                            iconSize: 24,
                            icon: const Icon(
                              CupertinoIcons.backward_fill,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (widget._controller.value.isPlaying) {
                                widget._controller.pause();
                                setState(() {});
                              } else {
                                widget._controller.play();
                                setState(() {});
                              }
                            },
                            iconSize: 56,
                            icon: Icon(
                              widget._controller.value.isPlaying
                                  ? CupertinoIcons.pause_circle_fill
                                  : CupertinoIcons.play_circle_fill,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              widget._controller.seekTo(Duration(
                                  milliseconds: widget._controller.value
                                          .position.inMilliseconds +
                                      2000));
                              setState(() {});
                            },
                            iconSize: 24,
                            icon: const Icon(
                              CupertinoIcons.forward_fill,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
