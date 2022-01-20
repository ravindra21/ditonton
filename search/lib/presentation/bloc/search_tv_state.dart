part of 'search_tv_bloc.dart';

abstract class SearchTvState extends Equatable {
  const SearchTvState();

  @override
  List<Object> get props => [];
}

class SearchTvEmpty extends SearchTvState {}

class SearchTvHasData extends SearchTvState {
  final List<TV> result;
  const SearchTvHasData(this.result);
}

class SearchTvError extends SearchTvState {
  final String message;
  const SearchTvError(this.message);
}

class SearchTvLoading extends SearchTvState {}
