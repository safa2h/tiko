import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiko/common/consts.dart';

class SliderView extends StatelessWidget {
  final Function(String)? onItemClick;

  const SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: Image.asset(
                'assets/img/logo.png',
                width: 100,
                fit: BoxFit.cover,
              ).image,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'TT Downloader No Watermark',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...[
            // Menu(Icons.share, Constanse.recommecndFriends),
            Menu(Icons.privacy_tip, Constanse.privacyPolicy),
            Menu(Icons.question_mark, Constanse.howToUse),
            //  Menu(Icons.feedback, Constanse.feedback),
            // Menu(Icons.star, Constanse.rateUs),
            Menu(CupertinoIcons.info, Constanse.about)
          ]
              .map((menu) => _SliderMenuItem(
                  title: menu.title,
                  iconData: menu.iconData,
                  onTap: onItemClick))
              .toList(),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title,
            style: const TextStyle(
              color: Colors.black,
            )),
        leading: Icon(iconData, color: Colors.black),
        onTap: () => onTap?.call(title));
  }
}

class Menu {
  final IconData iconData;
  final String title;

  Menu(this.iconData, this.title);
}
