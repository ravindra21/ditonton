import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:about/about.dart';
import 'package:core/presentation/bloc/home_tv_bloc.dart';
import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/pages/search_tv_page.dart';
import 'package:core/presentation/pages/top_rated_tv_page.dart';
import 'package:core/presentation/pages/tv_detail_page.dart';
import 'package:core/presentation/pages/now_playing_tv_page.dart';
import 'package:core/presentation/pages/popular_tv_page.dart';
import 'package:watchlist/presentation/pages/watchlist_movies_page.dart';
import 'package:watchlist/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';

class HomeTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-home';

  @override
  _HomeTVPageState createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeTvBloc>().add(FetchData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('TV Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist TV'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTVPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTVPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing TV',
                onTap: () =>
                    Navigator.pushNamed(context, NowPlayingTVPage.ROUTE_NAME),
              ),
              BlocBuilder<HomeTvBloc, HomeTvState>(
                builder: (context, state) {
                  if (state is HomeTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HomeTvHasData) {
                    return TVCard(state.playingTv);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular TV',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTVPage.ROUTE_NAME),
              ),
              BlocBuilder<HomeTvBloc, HomeTvState>(
                builder: (context, state) {
                  if (state is HomeTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HomeTvHasData) {
                    return TVCard(state.popularTv);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated TV Show',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTVPage.ROUTE_NAME),
              ),
              BlocBuilder<HomeTvBloc, HomeTvState>(
                builder: (context, state) {
                  if (state is HomeTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HomeTvHasData) {
                    return TVCard(state.topRatedTv);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TVCard extends StatelessWidget {
  final List<TV> tvList;

  const TVCard(this.tvList);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvList[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TVDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvList.length,
      ),
    );
  }
}
