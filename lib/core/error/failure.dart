import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class AuthFailure extends Failure {
  final String message;

  AuthFailure({this.message});

  @override
  List<Object> get props => [message];
}

class TimeLineFailure extends Failure {
  final String message;

  TimeLineFailure({this.message});

  @override
  List<Object> get props => [message];
}

class NotificationFailure extends Failure {
  final String message;

  NotificationFailure({this.message});

  @override
  List<Object> get props => [message];
}

class TweetingFailure extends Failure {
  final String message;

  TweetingFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ProfileFailure extends Failure {
  final String message;

  ProfileFailure({this.message});

  @override
  List<Object> get props => [message];
}

class SettingsFailure extends Failure {
  final String message;

  SettingsFailure({this.message});

  @override
  List<Object> get props => [message];
}