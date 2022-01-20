part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object> get props => [];
}

class TopRatedTvEmpty extends TopRatedTvState {}

class TopRatedTvError extends TopRatedTvState {
  final String message;

  const TopRatedTvError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTvLoading extends TopRatedTvState {}

class TopRatedTvHasData extends TopRatedTvState {
  final List<TV> tv;

  const TopRatedTvHasData({
    required this.tv,
  });

  @override
  List<Object> get props => [tv];
}
