part of 'home_detail_bloc.dart';

abstract class HomeDetailEvent extends Equatable {
  const HomeDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchDetail extends HomeDetailEvent {
  final int id;
  const FetchDetail(this.id);

  @override
  List<Object> get props => [id];
}

class RemoveFromWatchlist extends HomeDetailEvent {
  final HomeDetailHasData state;
  final MovieDetail movie;

  const RemoveFromWatchlist(this.state, this.movie);

  @override
  List<Object> get props => [state, movie];
}

class AddWatchlist extends HomeDetailEvent {
  final HomeDetailHasData state;
  final MovieDetail movie;

  const AddWatchlist(this.state, this.movie);

  @override
  List<Object> get props => [state, movie];
}
