import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_tv_event.dart';
part 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTV getNowPlayingTv;

  NowPlayingTvBloc({
    required this.getNowPlayingTv,
  }) : super(NowPlayingTvEmpty()) {
    on<FetchNowPlayingTv>((event, emit) async {
      emit(NowPlayingTvLoading());

      final nowPlayingTv = await getNowPlayingTv.execute();

      nowPlayingTv.fold((l) => emit(NowPlayingTvError(l.message)), (tv) {
        emit(NowPlayingTvHasData(
          tv: tv,
        ));
      });
    });
  }
}
