import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/videos_response.dart';

class VideoMapper{

  static Video resultToEntity(Result result)=> Video(
    iso6391: result.iso6391,
    iso31661: result.iso31661,
    name: result.name,
    key: result.key,
    site: result.site,
    size: result.size,
    type: result.type,
    official: result.official,
    publishedAt: result.publishedAt,
    id: result.id,
  );

}