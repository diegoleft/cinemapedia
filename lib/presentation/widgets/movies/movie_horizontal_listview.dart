import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({super.key, required this.movies, this.title, this.subTitle, this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener((){
      if(widget.loadNextPage == null) return;

      if((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();
      }

    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Column(
        children: [
          if(widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle,),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index){
                return FadeInRight(child: _Slide(movie: widget.movies[index]));
              }
            )
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            height: 225,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null){
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  }
                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'),
                    child: FadeIn(child: child),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 5),

          SizedBox(
            width: 150,
            child: _MovieTitle(movie: movie, releaseDate: movie.releaseDate, textStyle: textStyle),
          ),

          // RATING
          IntrinsicWidth(
            stepWidth: 145,
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
                const SizedBox(width: 3),
                Text(movie.voteAverage.toStringAsFixed(1), style: textStyle.bodyMedium?.copyWith(color: Colors.yellow.shade800),),
                const Spacer(),
                Text(HumanFormat.number(movie.popularity), style: textStyle.bodySmall)
              ],
            ),
          )
          
        ],
      ),
    );
  }
}

class _MovieTitle extends StatelessWidget {
  const _MovieTitle({
    super.key,
    required this.movie,
    this.releaseDate,
    required this.textStyle,
  });

  final Movie movie;
  final TextTheme textStyle;
  final DateTime? releaseDate;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${movie.title} (${movie.releaseDate?.year ?? "nn"})',
      maxLines: 2,
      style: textStyle.titleSmall
    );
  }
}

class _Title extends StatelessWidget {

  final String? title;
  final String? subTitle;

  const _Title({
    required this.title, this.subTitle,
  });

  

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top:10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(title != null)
            Text(title!, style: titleStyle),
          const Spacer(),
          if(subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: (){},
              child:  Text(subTitle!)
            )
           ,
        ]
      ),
    );
  }
}