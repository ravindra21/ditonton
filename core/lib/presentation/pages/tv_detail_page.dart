import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/presentation/bloc/home_detail_tv_bloc.dart';
import 'package:core/presentation/provider/tv_detail_notifier.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TVDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;
  const TVDetailPage({required this.id});

  @override
  _TVDetailPageState createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeDetailTvBloc>().add(FetchDetail(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeDetailTvBloc, HomeDetailTvState>(
        builder: (context, state) {
          if (state is HomeDetailTvLoading) {
            return const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is HomeDetailTvHasData) {
            final tv = state.tv;

            return SafeArea(
              child: DetailContent(
                tv,
                state.tvRecommendations,
                state.watchlisStatus,
              ),
            );
          } else {
            return const Text('');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendTv;
  final bool watchlistStatus;

  const DetailContent(this.tv, this.recommendTv, this.watchlistStatus);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            WatchlistButton(watchlistStatus, tv: tv),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            /*Text(
                              _showDuration(tv.runtime),
                            ),*/
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            RecommendList(recommendTv),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class RecommendList extends StatelessWidget {
  final List<TV> recommendations;

  const RecommendList(
    this.recommendations, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDetailTvBloc, HomeDetailTvState>(
      builder: (context, state) {
        if (state is HomeDetailTvHasData) {
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final tvRecommendation = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TVDetailPage.ROUTE_NAME,
                        arguments: tvRecommendation.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${tvRecommendation.posterPath}',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: recommendations.length,
            ),
          );
        } else {
          return const Text('');
        }
      },
    );
  }
}

class WatchlistButton extends StatefulWidget {
  const WatchlistButton(
    this.watchlistStatus, {
    Key? key,
    required this.tv,
  }) : super(key: key);

  final bool watchlistStatus;
  final TVDetail tv;

  @override
  State<WatchlistButton> createState() => _WatchlistButtonState();
}

class _WatchlistButtonState extends State<WatchlistButton> {
  bool _watchlistStatus = false;

  @override
  void initState() {
    super.initState();
    _watchlistStatus = widget.watchlistStatus;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDetailTvBloc, HomeDetailTvState>(
      builder: (context, state) {
        if (state is HomeDetailTvHasData) {
          return ElevatedButton(
            onPressed: () async {
              if (_watchlistStatus) {
                context
                    .read<HomeDetailTvBloc>()
                    .add(RemoveFromWatchlist(state, widget.tv));
                setState(() {
                  _watchlistStatus = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Removed from watchlist'),
                  duration: Duration(milliseconds: 300),
                ));
              } else {
                context
                    .read<HomeDetailTvBloc>()
                    .add(AddWatchlist(state, widget.tv));
                setState(() {
                  _watchlistStatus = true;
                });

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Added to watchlist'),
                  duration: Duration(milliseconds: 300),
                ));
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _watchlistStatus
                    ? const Icon(Icons.check)
                    : const Icon(Icons.add),
                const Text('Watchlist'),
              ],
            ),
          );
        } else {
          return const Text('');
        }
      },
    );
  }
}
