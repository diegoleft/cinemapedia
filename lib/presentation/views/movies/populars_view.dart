import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// init
// solo las primeras 10

class PopularsView extends ConsumerStatefulWidget {
  const PopularsView({super.key});

  @override
  PopularsViewState createState() => PopularsViewState();
}

class PopularsViewState extends ConsumerState<PopularsView> {

  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
  }

  void loadNextPage() async{
    if(isLoading || isLastPage) return;
    isLoading = true;

    await ref.watch(popularMoviesProvider.notifier).loadNextPage();
    isLoading = false;
    
  }


  @override
  Widget build(BuildContext context) {

    final popularsMovies = ref.watch(popularMoviesProvider);

    return Scaffold(
      body: MovieMasonry(
        movies: popularsMovies,
        loadNextPage: loadNextPage,
      )
    );
  }
}