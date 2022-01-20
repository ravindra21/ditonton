part of 'home_detail_tv_bloc.dart';

abstract class HomeDetailTvState extends Equatable {
  const HomeDetailTvState();

  @override
  List<Object> get props => [];
}

class HomeDetailTvEmpty extends HomeDetailTvState {}

class HomeDetailTvLoading extends HomeDetailTvState {}

class HomeDetailTvError extends HomeDetailTvState {
  final String message;

  const HomeDetailTvError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeDetailTvHasData extends HomeDetailTvState {
  final TVDetail tv;
  final List<TV> tvRecommendations;
  final bool watchlisStatus;
  final String message;
  const HomeDetailTvHasData(
      {required this.tv,
      required this.tvRecommendations,
      required this.watchlisStatus,
      required this.message});

  HomeDetailTvHasData copyWith({
    TVDetail? tv,
    List<TV>? tvRecommendations,
    bool? watchlisStatus,
    String? message,
  }) {
    return HomeDetailTvHasData(
      tv: tv ?? this.tv,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      watchlisStatus: watchlisStatus ?? this.watchlisStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tv, tvRecommendations, watchlisStatus, message];
}
