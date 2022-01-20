part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object> get props => [];
}

class WatchlistTvEmpty extends WatchlistTvState {}

class WatchlistTvError extends WatchlistTvState {
  final String message;

  const WatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvHasData extends WatchlistTvState {
  final List<TV> tv;

  const WatchlistTvHasData({
    required this.tv,
  });

  @override
  List<Object> get props => [tv];
}
