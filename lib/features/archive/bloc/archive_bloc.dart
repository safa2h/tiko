import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiko/common/http_service.dart';
import 'package:tiko/data/repo/arvhive_repo.dart';

part 'archive_event.dart';
part 'archive_state.dart';

class ArchiveBloc extends Bloc<ArchiveEvent, ArchiveState> {
  final IArchiveRepository repository;
  ArchiveBloc(this.repository) : super(ArchiveInitial()) {
    on<ArchiveEvent>((event, emit) async {
      if (event is ArchiveStarted) {
        emit(ArchiveLoading());

        try {
          final result = await repository.getFiles();
          if (result.isEmpty) {
            emit(ArchiveEmpty());
          } else {
            emit(ArchiveSuccess(result));
          }
        } catch (e) {
          emit(ArchiveError());
        }
      } else if (event is ArchiveDeleteItem) {
        emit(ArchiveLoading());
        try {
          await removeDownloadedVideo(videoPath: event.path);
          emit(ArchiveRemovedSuccess());
          final result = await repository.getFiles();
          if (result.isEmpty) {
            emit(ArchiveEmpty());
          }
        } catch (e) {
          emit(ArchiveError());
        }
      } else if (event is ArchiveSaveTogallery) {
        await saveDownloadedVideoToGallery(videoPath: event.path)
            .onError((error, stackTrace) {
          emit(ArchiveError());
        });
        emit(ArchiveAddedToGallerySuccess());
      }
    });
  }
}
