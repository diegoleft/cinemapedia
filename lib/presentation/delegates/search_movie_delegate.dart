import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>>Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?>{

  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies
  });

  void clearStreams(){
    debounceMovies.close();
    isLoadingStream.close();
  }

  void _onQueryChanged( String query ) {
    if(_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    isLoadingStream.add(true);
    _debounceTimer = Timer(const Duration(milliseconds: 500),() async{

      final movies = await searchMovies(query);
      initialMovies=movies;
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  Widget buildResultsAndSuggestions(){
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context,snapshot){
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context,index) => _MovieItem(
            movie:  movies[index],
            onMovieSelected:(context, movie){
              clearStreams();
              close(context,movie);
            },
          )
        );
      }
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [

        StreamBuilder(
          stream: isLoadingStream.stream,
          builder: (context, snapshot){
            if(snapshot.data ?? false){
              return SpinPerfect(
                duration: const Duration(seconds: 10),
                spins: 20,
                infinite: true,
                child: IconButton(
                  onPressed: ()=> query = '',
                  icon: const Icon(Icons.refresh_rounded)
                ),
              );
            }
            return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                onPressed: ()=> query = '',
                icon: const Icon(Icons.clear)
              ),
            );
          }
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_outlined)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return buildResultsAndSuggestions();
  }
  
}


class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;
  
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: ()=> onMovieSelected(context,movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                ),
              ),
            ),
            
            const SizedBox(width: 10),
      
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium),
      
                  (movie.overview.length > 100)
                    ? Text('${movie.overview.substring(0,100)}...')
                    : Text(movie.overview),
      
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
                      const SizedBox(width: 5),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: textStyle.bodyMedium?.copyWith(color: const Color.fromARGB(255, 190, 97, 15)),
                      )
                    ],
                  )
                ],
              ),
            )
      
          ],
        ),
      ),
    );
  }
}