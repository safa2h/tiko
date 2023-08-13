part of 'archive_bloc.dart';

@immutable
abstract class ArchiveState {}

class ArchiveInitial extends ArchiveState {}

class ArchiveError extends ArchiveState {}

class ArchiveLoading extends ArchiveState {}

class ArchiveEmpty extends ArchiveState {}

class ArchiveRemovedSuccess extends ArchiveState {}

class ArchiveAddedToGallerySuccess extends ArchiveState {}

class ArchiveSuccess extends ArchiveState {
  final List<dynamic> files;

  ArchiveSuccess(this.files);
}
