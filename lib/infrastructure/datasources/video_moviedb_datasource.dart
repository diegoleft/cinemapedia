import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/videos_datasources.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/mappers/video_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/videos_response.dart';
import 'package:dio/dio.dart';

class VideoMoviedbDatasource extends VideosDatasources{

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDbKey,
      'language': 'es-MX'
    }
  ));

  List<Video> _jsonToVideos(Map<String,dynamic>json){
    final videosDBResponse = VideosResponse.fromJson(json);
    final List<Video> videos = videosDBResponse.results.map((cast)=>VideoMapper.resultToEntity(cast)).toList();
    return videos;
  }

  @override
  Future<List<Video>> getVideosByMovie(String movieId) async {
    final response = await dio.get(
      '/movie/$movieId/videos'
    );

    return _jsonToVideos(response.data);  
  }
  
}