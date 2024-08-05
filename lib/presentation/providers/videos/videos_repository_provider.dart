
import 'package:cinemapedia/infrastructure/datasources/video_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/video_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este repositorio es inmutable
final videosRepositoryProvider = Provider((ref) {
  return VideoRepositoryImpl(VideoMoviedbDatasource());
});