part of 'home_detail_tv_bloc.dart';

abstract class HomeDetailTvEvent extends Equatable {
  const HomeDetailTvEvent();

  @override
  List<Object> get props => [];
}

class FetchDetail extends HomeDetailTvEvent {
  final int id;
  const FetchDetail(this.id);

  @override
  List<Object> get props => [id];
}

class RemoveFromWatchlist extends HomeDetailTvEvent {
  final HomeDetailTvHasData state;

  final TVDetail tv;

  const RemoveFromWatchlist(this.state, this.tv);

  @override
  List<Object> get props => [state, tv];
}

class AddWatchlist extends HomeDetailTvEvent {
  final HomeDetailTvHasData state;
  final TVDetail tv;

  const AddWatchlist(this.state, this.tv);

  @override
  List<Object> get props => [state, tv];
}
