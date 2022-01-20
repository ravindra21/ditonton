import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';

part 'home_tv_event.dart';
part 'home_tv_state.dart';

class HomeTvBloc extends Bloc<HomeTvEvent, HomeTvState> {
  final GetNowPlayingTV getNowPlayingTv;
  final GetPopularTV getPopularTv;
  final GetTopRatedTV getTopRatedTv;

  HomeTvBloc({
    required this.getNowPlayingTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  }) : super(HomeTvEmpty()) {
    on<FetchData>((event, emit) async {
      emit(HomeTvLoading());

      final playingTv = await getNowPlayingTv.execute();
      final popularTv = await getPopularTv.execute();
      final topRatedTv = await getTopRatedTv.execute();

      playingTv.fold((l) => emit(HomeTvError(l.message)), (playing) {
        popularTv.fold((l) => emit(HomeTvError(l.message)), (popular) {
          topRatedTv.fold((l) => emit(HomeTvError(l.message)), (topRated) {
            emit(HomeTvHasData(
              playingTv: playing,
              popularTv: popular,
              topRatedTv: topRated,
            ));
          });
        });
      });
    });
  }
}
