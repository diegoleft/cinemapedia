
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper{

  static Movie movieDBToEntity(MovieMovieDB moviedb ) => Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath != '') 
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }' 
      : 'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png',
    genreIds: moviedb.genreIds.map((e)=> e.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: (moviedb.posterPath != '') 
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }' 
      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-r6KetrzrVN6soWnhhRBaCD0fqYIEl-ig_Q&s',
    releaseDate: moviedb.releaseDate,
    title: moviedb.title,
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount
    );

    static Movie movieDetailsToEntity( MovieDetails moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '') 
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }' 
        : 'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png',
      genreIds: moviedb.genres.map((e)=> e.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '') 
        ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }' 
        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-r6KetrzrVN6soWnhhRBaCD0fqYIEl-ig_Q&s',
      releaseDate: moviedb.releaseDate ?? DateTime.now() ,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
    );

}