import 'package:cinemapedia/domain/datasources/videos_datasources.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/repositories/videos_repository.dart';

class VideoRepositoryImpl extends VideosRepository{

  final VideosDatasources datasource;
  VideoRepositoryImpl(this.datasource);

  @override
  Future<List<Video>> getVideosByMovie(String movieId) {
    return datasource.getVideosByMovie(movieId);
  }
  
}