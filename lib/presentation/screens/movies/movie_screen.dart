import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/video/youtube_player_widget.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}


class MovieScreenState extends ConsumerState<MovieScreen> {
  
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    ref.read(recommendationsByMovieProvider.notifier).loadRecommendations(widget.movieId);
    ref.read(videosByMovieProvider.notifier).loadVideos(widget.movieId);
  }

  
  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    if( movie == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context,index)=> _MovieDetails(movie: movie),
              childCount: 1
            )
          )
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {

    // final colors = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:15, right:15, top:25, bottom:15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(width: 20),
              
              SizedBox(
                width: (size.width - 75) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyles.titleLarge),
                    Text('${movie.releaseDate?.year}', style: textStyles.titleSmall),
                    Text(movie.overview),

                  ],
                ),
              ),
            ],
          ),
        ),

        //Generos de la pelicula
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender)=>Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
              ))
            ],
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString()),
        _VideoTrailer(movieId: movie.id.toString()),
        const SizedBox(height: 50),
        _RecommendationsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 50),
      ]
    );
  }
}


final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId){
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});


class _CustomSliverAppBar extends ConsumerWidget {
  
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async{
            
            // salva o estado de favorito
            // ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
            await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);

            // actualiza el estado de la base de datos
            ref.invalidate(isFavoriteProvider(movie.id));

          }, 
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(),
            data: (isFavorite) => isFavorite
            ? const Icon(Icons.favorite_rounded, color: Colors.red,)
            : const Icon( Icons.favorite_border),
            error: (_,__)=> throw UnimplementedError(),
          )
          // icon: const Icon( Icons.favorite_border)
          // icon: const Icon(Icons.favorite_rounded, color: Colors.red,)
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20, color: Colors.white),
        //   textAlign: TextAlign.start
        // ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress!=null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const _CustomGradient(
              begin: Alignment.topRight, 
              end: Alignment.bottomLeft,
              stops: [0.0,0.2],
              colors: [Colors.black54, Colors.transparent]
            ),

            const _CustomGradient(
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter,
              stops: [0.7,1.0],
              colors: [Colors.transparent, Colors.black87]
            ),

            const _CustomGradient(
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight,
              stops: [0.0,0.4],
              colors: [Colors.black38, Colors.transparent]
            )

          ],
        ),
      ),
    );
  }
}


class _CustomGradient extends StatelessWidget {

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    this.begin = Alignment.centerLeft, 
    this.end = Alignment.centerRight, 
    required this.stops, 
    required this.colors
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: begin,
                    end: end,
                    stops: stops,
                    colors: colors
                  )
                )
              ),
            );
  }
}

class _ActorsByMovie extends ConsumerWidget {

  final String movieId;
  
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if(actorsByMovie[movieId]==null) return const CircularProgressIndicator(strokeWidth: 2);
    
    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context,index){
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2),
                Text(
                  actor.character ?? '', 
                  maxLines: 2, 
                  style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)
                )
              ],
            ),
          );
        }
      ),
    );
  }
}



class _VideoTrailer extends ConsumerWidget {

  final String movieId;
  
  const _VideoTrailer({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final videosByMovie = ref.watch(videosByMovieProvider);

    if(videosByMovie[movieId]==null) return const CircularProgressIndicator(strokeWidth: 2);
    
    final videos = videosByMovie[movieId]!;
    final trailers = videos.where((video) => video.type.contains("Trailer"));

    if(trailers.isEmpty) {
      return const Center(
        child: Column(
          children: [
            Icon(Icons.tv_off_outlined, color: Colors.white24, size: 30),
            SizedBox(height: 10),
            Text('Trailer no disponible')
          ]
          )
      );
    }

    final trailer = trailers.first;

    return YoutubePlayerWidget(youtubeId: trailer.key);
  }
}


class _RecommendationsByMovie extends ConsumerWidget {

  final String movieId;
  
  const _RecommendationsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final recommendationsByMovie = ref.watch(recommendationsByMovieProvider);

    if(recommendationsByMovie[movieId]==null) return const CircularProgressIndicator(strokeWidth: 2);
    
    final recommendations = recommendationsByMovie[movieId]!;

    return MovieHorizontalListview(
            movies: recommendations,
            title: 'Películas similares',
          );
  }
}