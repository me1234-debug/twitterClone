import 'package:fc_twitter/screens/tweet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NewTweetIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(MaterialCommunityIcons.feather),
          ),
          onPressed: () =>
              Navigator.pushNamed(context, TweetScreen.pageId),
        ),
        Positioned(
          left: 14,
          top: 15,
          child: Icon(
            Icons.add,
            size: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
