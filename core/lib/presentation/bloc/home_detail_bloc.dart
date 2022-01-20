import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'home_detail_event.dart';
part 'home_detail_state.dart';

class HomeDetailBloc extends Bloc<HomeDetailEvent, HomeDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  HomeDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(HomeDetailEmpty()) {
    on<FetchDetail>(
      (event, emit) async {
        emit(HomeDetailLoading());

        final detailResult = await getMovieDetail.execute(event.id);
        final recommendMovies = await getMovieRecommendations.execute(event.id);

        await detailResult.fold(
          (failure) async => emit(HomeDetailError(failure.message)),
          (movie) async {
            final watchlistStatus = await getWatchListStatus.execute(event.id);
            await recommendMovies.fold((l) async {}, (r) async {
              emit(
                HomeDetailHasData(
                    movie: movie,
                    movieRecommendations: r,
                    watchlisStatus: watchlistStatus,
                    message: ''),
              );
            });
          },
        );
      },
    );

    on<RemoveFromWatchlist>((event, emit) async {
      final message = await removeWatchlist.execute(event.movie);
      final status = await getWatchListStatus.execute(event.movie.id);

      if (!status) {
        await message.fold(
          (l) async => emit(HomeDetailError(l.message)),
          (r) async {
            emit(event.state.copyWith(message: r));
          },
        );
      }
    });

    on<AddWatchlist>((event, emit) async {
      final message = await saveWatchlist.execute(event.movie);
      final status = await getWatchListStatus.execute(event.movie.id);

      if (status) {
        await message.fold(
          (l) async => emit(HomeDetailError(l.message)),
          (r) async {
            emit(event.state.copyWith(message: r));
          },
        );
      }
    });
  }
}
