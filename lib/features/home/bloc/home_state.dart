part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {}

class HomeError extends HomeState {
  final AppException appException;

  HomeError(this.appException);
}

// class HomeSuucces extends HomeState {
//   final Data data;

//   HomeSuucces(this.data);
// }
