import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper{

  static Actor castToEntity(Cast cast)=> Actor(
    id: cast.id,
    name: cast.name,
    profilePath: cast.profilePath != null
      ? 'https://image.tmdb.org/t/p/w500${ cast.profilePath }' 
      : 'https://i0.wp.com/digitalhealthskills.com/wp-content/uploads/2022/11/fd35c-no-user-image-icon-27.png?fit=500,500&ssl=1',
    character: cast.character
  );

}