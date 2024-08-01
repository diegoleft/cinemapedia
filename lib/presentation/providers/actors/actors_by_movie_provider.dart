import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String,List<Actor>>>((ref){
  final actorsRepository = ref.watch( actorsRepositoryProvider );
  return ActorsByMovieNotifier(getActors: actorsRepository.getActorsByMovie);
});

typedef GetActorsCallback = Future<List<Actor>>Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actor>>>{

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors
  }): super({});

  Future<void> loadActors(String movieId) async {
    // Esto llama al state para usar la pelicula del cache
    if(state[movieId] != null) return;
    final List<Actor> actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }

}