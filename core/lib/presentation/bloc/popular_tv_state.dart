part of 'popular_tv_bloc.dart';

abstract class PopularTvState extends Equatable {
  const PopularTvState();

  @override
  List<Object> get props => [];
}

class PopularTvEmpty extends PopularTvState {}

class PopularTvError extends PopularTvState {
  final String message;

  const PopularTvError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTvLoading extends PopularTvState {}

class PopularTvHasData extends PopularTvState {
  final List<TV> tv;

  const PopularTvHasData({
    required this.tv,
  });

  @override
  List<Object> get props => [tv];
}
