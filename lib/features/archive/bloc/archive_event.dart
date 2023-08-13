part of 'archive_bloc.dart';

@immutable
abstract class ArchiveEvent {}

class ArchiveStarted extends ArchiveEvent {}

class ArchiveSaveTogallery extends ArchiveEvent {
  final String path;

  ArchiveSaveTogallery(this.path);
}

class ArchiveDeleteItem extends ArchiveEvent {
  final String path;

  ArchiveDeleteItem(this.path);
}
