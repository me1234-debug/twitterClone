import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/timeline_bloc.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/tweet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = context.select<ProfileBloc, UserProfileEntity>(
      (bloc) => bloc.state.userProfile,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Foundation.list, color: Theme.of(context).primaryColor),
        ),
        title: IconButton(
            icon: Icon(
              FontAwesome.twitter,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {}),
        actions: [
          IconButton(
            icon: Icon(
              Icons.star_border_outlined,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: BlocBuilder<TimeLineBloc, TimeLineState>(
        buildWhen: (_, currentState) {
          return currentState is FetchingTweetComplete;
        },
        builder: (context, state) {
          if (state is FetchingTweetComplete) {
            return StreamBuilder<List<TweetEntity>>(
              stream: state.tweetStream,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) => TweetItem(
                          key: ValueKey(snapshot.data[index].id),
                          tweet: snapshot.data[index],
                          profile: profile,
                        ),
                      )
                    : Center(child: Text('nothing'));
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
