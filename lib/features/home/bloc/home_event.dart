part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeStarted extends HomeEvent {}

class HomeReqDownload extends HomeEvent {
  final String url;

  HomeReqDownload(this.url);
}
