import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiko/common/exception.dart';
import 'package:tiko/common/http_service.dart';
import 'package:tiko/data/repo/data_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IDataRepository repository;
  final IHttpservice httpservice;
  HomeBloc(this.repository, this.httpservice) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeReqDownload) {
        try {
          emit(HomeLoading());
          await repository.downloadVideo(event.url);
          emit(HomeSuccess());

          // await repository
          //     .downloadVideo(
          //       'https://download.samplelib.com/mp4/sample-5s.mp4',
          //     )
          //     .whenComplete(() => null);

          // emit(HomeSuucces(result));
        } catch (e) {
          emit(HomeError(AppException(e.toString())));
        }
      } else if (event is HomeStarted) {
        emit(HomeInitial());
      }
    });
  }
}
