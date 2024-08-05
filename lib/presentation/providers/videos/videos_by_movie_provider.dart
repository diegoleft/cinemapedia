import 'package:cinemapedia/domain/entities/video.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final videosByMovieProvider = StateNotifierProvider<VideosByMovieNotifier, Map<String,List<Video>>>((ref){
  final videosRepository = ref.watch( videosRepositoryProvider );
  return VideosByMovieNotifier(getVideos: videosRepository.getVideosByMovie);
});

typedef GetVideosCallback = Future<List<Video>>Function(String movieId);

class VideosByMovieNotifier extends StateNotifier<Map<String,List<Video>>>{

  final GetVideosCallback getVideos;

  VideosByMovieNotifier({
    required this.getVideos
  }): super({});

  Future<void> loadVideos(String movieId) async {
    // Esto llama al state para usar la pelicula del cache
    if(state[movieId] != null) return;
    final List<Video> videos = await getVideos(movieId);
    state = {...state, movieId: videos};
  }

  Future<Video> loadTrailer(String movieId) async {
    // Esto llama al state para usar la pelicula del cache
    final List<Video> videos = await getVideos(movieId);
    List<Video> videoTrailer = videos.where((video) => video.type.contains("Trailer")).toList();
    return videoTrailer.first;
  }


}