import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideShowProvider);

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),

        SliverList(delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
              children: [

                MoviesSlideshow(movies: slideShowMovies),
                
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En Cines',
                  subTitle: 'Lunes 20',
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'Próximamente',
                  subTitle: 'En este mes',
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'Populares',
                  subTitle: '',
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'Mejor calificadas',
                  subTitle: 'De todos los tiempos',
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),

                const SizedBox(height: 50)
            
              ],
            );
        },
        childCount: 1
        ))

      ]
      
      
    );
  }
}