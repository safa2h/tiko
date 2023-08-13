import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HowToUseWidget extends StatelessWidget {
  const HowToUseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Once you’ve found your video, tap the Share icon.'),
        Text(
            'Next, search for your video of choice and click on the Share icon.'),
        Text(
            'When presented with options of how to share the video, scroll from right to left until you find the Copy Link button and tap it to copy the link.'),
        Text(
            'Next, paste the link in the TikTok Downloader and tap the Download button.'),
        Text('The app will then download the video and save it to your phone.'),
      ],
    );
  }
}
