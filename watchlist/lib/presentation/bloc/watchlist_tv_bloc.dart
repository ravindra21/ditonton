import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tv.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTV getWatchlistTv;

  WatchlistTvBloc({
    required this.getWatchlistTv,
  }) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());

      final watchlistTv = await getWatchlistTv.execute();

      watchlistTv.fold((l) => emit(WatchlistTvError(l.message)), (tv) {
        emit(WatchlistTvHasData(
          tv: tv,
        ));
      });
    });
  }
}
