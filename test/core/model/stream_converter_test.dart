import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/notification/domain/entity/notification_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.dart';

void main() {
  CollectionReference collection;
  Query query;
  FirebaseFirestore firebaseFirestore;
  StreamConverter streamConverter;
  // ignore: close_sinks
  StreamController streamController;

  setUp(() {
    firebaseFirestore = MockFirebaseFirestore();
    collection = MockCollectionReference();
    query = MockQuery();
    streamController = StreamController<QuerySnapshot>();
  });

  group('stream converter fromCollectionToTweets', () {
    test('Should hold an initial stream of type CollectionReference', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collection);

      final tweets = firebaseFirestore.collection('tweets');

      streamConverter = StreamConverter(collection: tweets);

      expect(streamConverter.collection, isA<CollectionReference>());
    });

    test('Should return a stream of type TweetEntity when toTweetModel is called', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collection);
      when(collection.snapshots()).thenAnswer((_) => streamController.stream);

      final tweets  = firebaseFirestore.collection('tweets');

      streamConverter = StreamConverter(collection: tweets);

      final converted = streamConverter.fromCollectionToTweets(collection);

      expect(converted, isA<Stream<List<TweetEntity>>>());
    });
  });

  group('stream converter fromQueryToTweets', () {
    test('Should return a stream of type TweetEntity when toTweetModel is called', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collection);
      when(collection.where(any, isEqualTo: anyNamed('isEqualTo'))).thenReturn(query);
      when(query.snapshots()).thenAnswer((_) => streamController.stream);

      final queryResult = firebaseFirestore.collection('tweets').where('id', isEqualTo: '001');

      streamConverter = StreamConverter(query: queryResult);

      final converted = streamConverter.fromQueryToTweets(queryResult);

      expect(converted, isA<Stream<List<TweetEntity>>>());
    });
  });

  group('stream converter fromQueryToNotifications', () {
    test('Should return a stream of type NotificationEntity when called', () async {
      when(firebaseFirestore.collection(any)).thenReturn(collection);
      when(collection.where(any, isEqualTo: anyNamed('isEqualTo'))).thenReturn(query);
      when(query.snapshots()).thenAnswer((_) => streamController.stream);

      final queryResult = firebaseFirestore.collection('tweets').where('id', isEqualTo: '001');

      streamConverter = StreamConverter(query: queryResult);

      final converted = streamConverter.fromQueryToNotification(queryResult);

      expect(converted, isA<Stream<List<NotificationEntity>>>());
    });
  });
}
