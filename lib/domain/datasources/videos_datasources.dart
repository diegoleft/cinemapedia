import 'package:cinemapedia/domain/entities/video.dart';

abstract class VideosDatasources{

  Future<List<Video>>getVideosByMovie(String movieId);

}