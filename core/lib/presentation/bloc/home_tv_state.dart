part of 'home_tv_bloc.dart';

abstract class HomeTvState extends Equatable {
  const HomeTvState();

  @override
  List<Object> get props => [];
}

class HomeTvEmpty extends HomeTvState {}

class HomeTvError extends HomeTvState {
  final String message;

  const HomeTvError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeTvLoading extends HomeTvState {}

class HomeTvHasData extends HomeTvState {
  final List<TV> playingTv;
  final List<TV> popularTv;
  final List<TV> topRatedTv;

  const HomeTvHasData({
    required this.playingTv,
    required this.popularTv,
    required this.topRatedTv,
  });

  @override
  List<Object> get props => [playingTv, popularTv, topRatedTv];
}
