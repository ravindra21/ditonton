import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_tv_status.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

part 'home_detail_tv_event.dart';
part 'home_detail_tv_state.dart';

class HomeDetailTvBloc extends Bloc<HomeDetailTvEvent, HomeDetailTvState> {
  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final GetWatchlistTVStatus getWatchListStatus;
  final SaveWatchlistTV saveWatchlist;
  final RemoveTVWatchlist removeWatchlist;

  HomeDetailTvBloc({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(HomeDetailTvEmpty()) {
    on<FetchDetail>(
      (event, emit) async {
        emit(HomeDetailTvLoading());

        final detailResult = await getTVDetail.execute(event.id);
        final recommendTv = await getTVRecommendations.execute(event.id);

        await detailResult.fold(
          (failure) async => emit(HomeDetailTvError(failure.message)),
          (tv) async {
            final watchlistStatus = await getWatchListStatus.execute(event.id);
            await recommendTv.fold((l) async {}, (r) async {
              emit(
                HomeDetailTvHasData(
                    tv: tv,
                    tvRecommendations: r,
                    watchlisStatus: watchlistStatus,
                    message: ''),
              );
            });
          },
        );
      },
    );
    on<RemoveFromWatchlist>((event, emit) async {
      final message = await removeWatchlist.execute(event.tv);
      final status = await getWatchListStatus.execute(event.tv.id);

      if (!status) {
        await message.fold(
          (l) async => emit(HomeDetailTvError(l.message)),
          (r) async {
            emit(event.state.copyWith(message: r));
          },
        );
      }
    });

    on<AddWatchlist>((event, emit) async {
      final message = await saveWatchlist.execute(event.tv);
      final status = await getWatchListStatus.execute(event.tv.id);

      if (status) {
        await message.fold(
          (l) async => emit(HomeDetailTvError(l.message)),
          (r) async {
            emit(event.state.copyWith(message: r));
          },
        );
      }
    });
  }
}
