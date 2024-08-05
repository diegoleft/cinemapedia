import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final recommendationsByMovieProvider = StateNotifierProvider<RecommendationsByMovieNotifier, Map<String,List<Movie>>>((ref){
  final recommendationsRepository = ref.watch( recommendationsRepositoryProvider );
  return RecommendationsByMovieNotifier(getRecommendations: recommendationsRepository.getRecommendationsByMovieId);
});

typedef GetRecommendationsCallback = Future<List<Movie>>Function(String movieId);

class RecommendationsByMovieNotifier extends StateNotifier<Map<String,List<Movie>>>{

  final GetRecommendationsCallback getRecommendations;

  RecommendationsByMovieNotifier({
    required this.getRecommendations
  }): super({});

  Future<void> loadRecommendations(String movieId) async {
    // Esto llama al state para usar la pelicula del cache
    if(state[movieId] != null) return;
    final List<Movie> recommendations = await getRecommendations(movieId);
    state = {...state, movieId: recommendations};
  }

}